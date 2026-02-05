#!/usr/bin/env python3
"""
download_ios_icons.py - Download iOS icons from icons8.com via web scraping

This script scrapes iOS-style icons from icons8.com in SVG format,
organizing them by category.

Usage:
    python download_ios_icons.py [options]

See --help for full options list.
"""

import argparse
import json
import logging
import os
import re
import signal
import sys
import time
import unicodedata
from dataclasses import dataclass, field, asdict
from datetime import datetime
from pathlib import Path
from typing import List, Optional, Dict, Set
from urllib.parse import urljoin, urlparse

from playwright.sync_api import sync_playwright, Page, Browser, TimeoutError as PlaywrightTimeout

# Version
__version__ = "1.0.0"

# Configuration
BASE_URL = "https://icons8.com"
ICONS_IOS_URL = f"{BASE_URL}/icons/ios"
ICONS_IOS_FILLED_URL = f"{BASE_URL}/icons/ios-filled"

# Delays (in seconds) to be respectful
PAGE_LOAD_DELAY = 2
SCROLL_DELAY = 0.5
ICON_DOWNLOAD_DELAY = 0.3


# ============================================================================
# Data Classes
# ============================================================================

@dataclass
class Category:
    name: str
    slug: str
    url: str
    subcategories: List['Category'] = field(default_factory=list)


@dataclass
class Icon:
    name: str
    slug: str
    url: str
    category: str
    svg_content: Optional[str] = None


@dataclass
class DownloadProgress:
    started_at: str
    last_updated: str
    style: str
    current_category: Optional[str] = None
    downloaded_icons: Set[str] = field(default_factory=set)
    failed_icons: Dict[str, str] = field(default_factory=dict)
    total_downloaded: int = 0
    total_errors: int = 0
    categories_completed: List[str] = field(default_factory=list)

    def to_dict(self) -> dict:
        return {
            'started_at': self.started_at,
            'last_updated': self.last_updated,
            'style': self.style,
            'current_category': self.current_category,
            'downloaded_icons': list(self.downloaded_icons),
            'failed_icons': self.failed_icons,
            'total_downloaded': self.total_downloaded,
            'total_errors': self.total_errors,
            'categories_completed': self.categories_completed,
        }

    @classmethod
    def from_dict(cls, data: dict) -> 'DownloadProgress':
        return cls(
            started_at=data['started_at'],
            last_updated=data['last_updated'],
            style=data['style'],
            current_category=data.get('current_category'),
            downloaded_icons=set(data.get('downloaded_icons', [])),
            failed_icons=data.get('failed_icons', {}),
            total_downloaded=data.get('total_downloaded', 0),
            total_errors=data.get('total_errors', 0),
            categories_completed=data.get('categories_completed', []),
        )


# ============================================================================
# Utility Functions
# ============================================================================

def slugify(name: str) -> str:
    """Convert name to valid filename slug."""
    # Normalize unicode
    name = unicodedata.normalize('NFKD', name)
    name = name.encode('ascii', 'ignore').decode('ascii')

    # Lowercase
    name = name.lower()

    # Replace problematic chars with hyphens
    name = re.sub(r'[/\\()&]', '-', name)
    name = re.sub(r'[\s_]+', '-', name)

    # Remove remaining special chars
    name = re.sub(r'[^a-z0-9-]', '', name)

    # Collapse multiple hyphens
    name = re.sub(r'-+', '-', name)

    # Strip edge hyphens
    name = name.strip('-')

    return name or 'unnamed'


def setup_logging(verbose: bool, log_file: Optional[str] = None) -> logging.Logger:
    """Configure logging."""
    logger = logging.getLogger('icons8_scraper')
    logger.setLevel(logging.DEBUG if verbose else logging.INFO)

    formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')

    # Console handler
    console_handler = logging.StreamHandler()
    console_handler.setLevel(logging.DEBUG if verbose else logging.INFO)
    console_handler.setFormatter(formatter)
    logger.addHandler(console_handler)

    # File handler (optional)
    if log_file:
        file_handler = logging.FileHandler(log_file)
        file_handler.setLevel(logging.DEBUG)
        file_handler.setFormatter(formatter)
        logger.addHandler(file_handler)

    return logger


# ============================================================================
# Icons8 Scraper
# ============================================================================

class Icons8Scraper:
    """Scraper for icons8.com using Playwright."""

    def __init__(self, headless: bool = True, logger: Optional[logging.Logger] = None):
        self.headless = headless
        self.logger = logger or logging.getLogger('icons8_scraper')
        self.playwright = None
        self.browser: Optional[Browser] = None
        self.page: Optional[Page] = None

    def __enter__(self):
        self.start()
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.stop()

    def start(self):
        """Start the browser."""
        self.playwright = sync_playwright().start()
        self.browser = self.playwright.chromium.launch(headless=self.headless)
        self.page = self.browser.new_page()
        self.page.set_viewport_size({"width": 1920, "height": 1080})
        # Set a realistic user agent
        self.page.set_extra_http_headers({
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
        })

    def stop(self):
        """Stop the browser."""
        if self.page:
            self.page.close()
        if self.browser:
            self.browser.close()
        if self.playwright:
            self.playwright.stop()

    def discover_categories(self, style_url: str) -> List[Category]:
        """Discover all categories from the style page."""
        self.logger.info(f"Discovering categories from {style_url}")

        self.page.goto(style_url, wait_until="networkidle")
        time.sleep(PAGE_LOAD_DELAY)

        categories = []

        # Try to find category links in the sidebar or navigation
        # Icons8 typically has category links in the left sidebar
        try:
            # Wait for the page to load categories
            self.page.wait_for_selector('[data-testid="icons-sidebar"], .sidebar, nav', timeout=10000)

            # Try multiple selectors for category links
            category_selectors = [
                'a[href*="/icons/set/"]',
                '.sidebar a[href*="/set/"]',
                'nav a[href*="/set/"]',
                '[data-testid="category-link"]',
            ]

            for selector in category_selectors:
                elements = self.page.query_selector_all(selector)
                if elements:
                    self.logger.info(f"Found {len(elements)} category links with selector: {selector}")
                    for el in elements:
                        href = el.get_attribute('href')
                        text = el.inner_text().strip()
                        if href and text:
                            # Filter to only include links that look like categories
                            if '/icons/set/' in href or '/set/' in href:
                                full_url = urljoin(BASE_URL, href)
                                # Add style parameter if not present
                                if 'ios' not in href.lower():
                                    # Determine style from the original URL
                                    if 'ios-filled' in style_url:
                                        full_url = f"{full_url}--ios17-filled"
                                    else:
                                        full_url = f"{full_url}--ios17"
                                categories.append(Category(
                                    name=text,
                                    slug=slugify(text),
                                    url=full_url
                                ))
                    break

            # Deduplicate by slug
            seen_slugs = set()
            unique_categories = []
            for cat in categories:
                if cat.slug not in seen_slugs:
                    seen_slugs.add(cat.slug)
                    unique_categories.append(cat)

            self.logger.info(f"Found {len(unique_categories)} unique categories")
            return unique_categories

        except PlaywrightTimeout:
            self.logger.warning("Timeout waiting for category sidebar")
            return []

    def scrape_category_icons(self, category: Category, max_icons: Optional[int] = None) -> List[Icon]:
        """Scrape all icons from a category page."""
        self.logger.info(f"Scraping category: {category.name} from {category.url}")

        self.page.goto(category.url, wait_until="networkidle")
        time.sleep(PAGE_LOAD_DELAY)

        icons = []

        try:
            # Wait for icons to load
            self.page.wait_for_selector('[data-testid="icon-card"], .icon-card, .icons-grid img, svg', timeout=15000)

            # Scroll to load more icons (handle infinite scroll)
            prev_count = 0
            scroll_attempts = 0
            max_scroll_attempts = 10 if max_icons is None else 3

            while scroll_attempts < max_scroll_attempts:
                # Get current icon count
                icon_elements = self.page.query_selector_all('[data-testid="icon-card"], .icon-card, .icons-grid > div, .icon-item')
                current_count = len(icon_elements)

                if max_icons and current_count >= max_icons:
                    break

                if current_count == prev_count:
                    scroll_attempts += 1
                else:
                    scroll_attempts = 0

                prev_count = current_count

                # Scroll down
                self.page.evaluate("window.scrollTo(0, document.body.scrollHeight)")
                time.sleep(SCROLL_DELAY)

            # Extract icon information
            icon_elements = self.page.query_selector_all('[data-testid="icon-card"], .icon-card, a[href*="/icon/"]')

            self.logger.info(f"Found {len(icon_elements)} icon elements")

            for idx, el in enumerate(icon_elements):
                if max_icons and idx >= max_icons:
                    break

                try:
                    # Try to get the icon link and name
                    href = el.get_attribute('href')
                    if not href:
                        # Try to find a link inside
                        link = el.query_selector('a[href*="/icon/"]')
                        if link:
                            href = link.get_attribute('href')

                    if href and '/icon/' in href:
                        # Extract name from URL or element
                        name = el.get_attribute('title') or el.get_attribute('alt')
                        if not name:
                            # Try to extract from URL: /icon/123/icon-name
                            match = re.search(r'/icon/\d+/([^/?]+)', href)
                            if match:
                                name = match.group(1).replace('-', ' ').title()

                        if name:
                            icons.append(Icon(
                                name=name,
                                slug=slugify(name),
                                url=urljoin(BASE_URL, href),
                                category=category.slug
                            ))
                except Exception as e:
                    self.logger.debug(f"Error extracting icon: {e}")

            self.logger.info(f"Extracted {len(icons)} icons from {category.name}")
            return icons

        except PlaywrightTimeout:
            self.logger.warning(f"Timeout loading icons for category {category.name}")
            return []

    def download_icon_svg(self, icon: Icon) -> Optional[str]:
        """Download SVG content for an icon."""
        self.logger.debug(f"Downloading SVG for: {icon.name}")

        try:
            self.page.goto(icon.url, wait_until="networkidle")
            time.sleep(ICON_DOWNLOAD_DELAY)

            # Look for SVG in the page
            # Icons8 typically shows the icon in an SVG element or has a download button

            # Try to find SVG element directly
            svg_element = self.page.query_selector('svg.icon-preview, .icon-preview svg, [data-testid="icon-preview"] svg')

            if svg_element:
                svg_content = svg_element.evaluate('el => el.outerHTML')
                return svg_content

            # Try to find download button and get SVG URL
            download_btn = self.page.query_selector('button:has-text("SVG"), a:has-text("SVG"), [data-testid="download-svg"]')
            if download_btn:
                # Click to potentially reveal SVG or trigger download
                # For now, try to get the SVG from the page
                pass

            # Try to extract SVG from any visible icon on the page
            all_svgs = self.page.query_selector_all('svg')
            for svg in all_svgs:
                svg_html = svg.evaluate('el => el.outerHTML')
                # Check if this looks like an icon (has paths, not too small)
                if '<path' in svg_html and len(svg_html) > 100:
                    return svg_html

            self.logger.warning(f"Could not find SVG for {icon.name}")
            return None

        except Exception as e:
            self.logger.error(f"Error downloading SVG for {icon.name}: {e}")
            return None


# ============================================================================
# Download Manager
# ============================================================================

class DownloadManager:
    """Manages icon downloading with progress tracking."""

    def __init__(self, args: argparse.Namespace, logger: logging.Logger):
        self.args = args
        self.logger = logger
        self.progress: Optional[DownloadProgress] = None
        self.scraper: Optional[Icons8Scraper] = None

    def load_progress(self) -> Optional[DownloadProgress]:
        """Load progress from file."""
        progress_file = Path(self.args.progress_file)
        if progress_file.exists():
            try:
                with open(progress_file) as f:
                    data = json.load(f)
                return DownloadProgress.from_dict(data)
            except Exception as e:
                self.logger.warning(f"Could not load progress file: {e}")
        return None

    def save_progress(self):
        """Save progress to file."""
        if self.progress:
            self.progress.last_updated = datetime.now().isoformat()
            progress_file = Path(self.args.progress_file)
            with open(progress_file, 'w') as f:
                json.dump(self.progress.to_dict(), f, indent=2)
            self.logger.info(f"Progress saved to {progress_file}")

    def run(self):
        """Main download loop."""
        # Determine which styles to download
        styles = []
        if self.args.style in ('outline', 'both'):
            styles.append(('outline', ICONS_IOS_URL, self.args.output_outline))
        if self.args.style in ('filled', 'both'):
            styles.append(('filled', ICONS_IOS_FILLED_URL, self.args.output_filled))

        with Icons8Scraper(headless=not self.args.headful, logger=self.logger) as scraper:
            self.scraper = scraper

            for style_name, style_url, output_dir in styles:
                self.logger.info(f"Processing style: {style_name}")

                # Initialize or load progress
                if self.args.resume:
                    self.progress = self.load_progress()

                if not self.progress or self.progress.style != style_name:
                    self.progress = DownloadProgress(
                        started_at=datetime.now().isoformat(),
                        last_updated=datetime.now().isoformat(),
                        style=style_name
                    )

                # Discover categories
                categories = scraper.discover_categories(style_url)

                if self.args.list_categories:
                    print(f"\nCategories for {style_name}:")
                    for cat in categories:
                        print(f"  - {cat.name} ({cat.slug})")
                    continue

                # Filter categories if specified
                if self.args.categories:
                    filter_cats = [c.strip().lower() for c in self.args.categories.split(',')]
                    categories = [c for c in categories if c.slug in filter_cats or c.name.lower() in filter_cats]

                # Limit categories for testing
                if self.args.limit_categories:
                    categories = categories[:self.args.limit_categories]

                self.logger.info(f"Will process {len(categories)} categories")

                # Create output directory
                output_path = Path(output_dir)
                output_path.mkdir(parents=True, exist_ok=True)

                # Process each category
                for cat_idx, category in enumerate(categories):
                    if category.slug in self.progress.categories_completed:
                        self.logger.info(f"Skipping completed category: {category.name}")
                        continue

                    self.progress.current_category = category.slug
                    self.logger.info(f"Processing category {cat_idx + 1}/{len(categories)}: {category.name}")

                    # Create category directory
                    cat_dir = output_path / category.slug
                    cat_dir.mkdir(parents=True, exist_ok=True)

                    # Scrape icons
                    max_icons = self.args.limit_icons if hasattr(self.args, 'limit_icons') else None
                    icons = scraper.scrape_category_icons(category, max_icons=max_icons)

                    if self.args.dry_run:
                        print(f"  Would download {len(icons)} icons from {category.name}")
                        for icon in icons[:5]:
                            print(f"    - {icon.name}")
                        if len(icons) > 5:
                            print(f"    ... and {len(icons) - 5} more")
                        continue

                    # Download each icon
                    for icon_idx, icon in enumerate(icons):
                        icon_key = f"{category.slug}/{icon.slug}"

                        if icon_key in self.progress.downloaded_icons:
                            self.logger.debug(f"Skipping already downloaded: {icon.name}")
                            continue

                        self.logger.info(f"  Downloading {icon_idx + 1}/{len(icons)}: {icon.name}")

                        svg_content = scraper.download_icon_svg(icon)

                        if svg_content:
                            # Save SVG file
                            svg_path = cat_dir / f"{icon.slug}.svg"
                            with open(svg_path, 'w') as f:
                                f.write(svg_content)

                            self.progress.downloaded_icons.add(icon_key)
                            self.progress.total_downloaded += 1
                            self.logger.info(f"    Saved: {svg_path}")
                        else:
                            self.progress.failed_icons[icon_key] = "Could not extract SVG"
                            self.progress.total_errors += 1

                        # Save progress periodically
                        if (icon_idx + 1) % 10 == 0:
                            self.save_progress()

                    self.progress.categories_completed.append(category.slug)
                    self.save_progress()

                self.logger.info(f"Completed {style_name}: {self.progress.total_downloaded} icons downloaded, {self.progress.total_errors} errors")


# ============================================================================
# CLI
# ============================================================================

def create_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog='download_ios_icons.py',
        description='Download iOS icons from icons8.com in SVG format via web scraping',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Download all icons (both outline and filled)
  python download_ios_icons.py

  # Dry run - show what would be downloaded
  python download_ios_icons.py --dry-run

  # Download only outline icons
  python download_ios_icons.py --style outline

  # Download only specific categories
  python download_ios_icons.py --categories arrows,business

  # Resume interrupted download
  python download_ios_icons.py --resume

  # List available categories
  python download_ios_icons.py --list-categories

  # Test with limited scope
  python download_ios_icons.py --limit-categories 1 --limit-icons 5

  # Verbose logging with visible browser
  python download_ios_icons.py -v --headful
        """
    )

    # Output options
    parser.add_argument(
        '--output-outline',
        default='assets/icons',
        help='Output directory for outline icons (default: assets/icons)'
    )
    parser.add_argument(
        '--output-filled',
        default='assets/icons-filled',
        help='Output directory for filled icons (default: assets/icons-filled)'
    )

    # Style selection
    parser.add_argument(
        '--style',
        choices=['outline', 'filled', 'both'],
        default='both',
        help='Icon style to download (default: both)'
    )

    # Filtering
    parser.add_argument(
        '--categories',
        type=str,
        help='Comma-separated list of categories to download (default: all)'
    )

    # Limits for testing
    parser.add_argument(
        '--limit-categories',
        type=int,
        help='Limit number of categories to process (for testing)'
    )
    parser.add_argument(
        '--limit-icons',
        type=int,
        help='Limit number of icons per category (for testing)'
    )

    # Resume & progress
    parser.add_argument(
        '--resume',
        action='store_true',
        help='Resume from previous interrupted download'
    )
    parser.add_argument(
        '--progress-file',
        default='.icons8_download_progress.json',
        help='Progress file path for resume capability'
    )

    # Execution modes
    parser.add_argument(
        '--dry-run',
        action='store_true',
        help='Show what would be downloaded without downloading'
    )
    parser.add_argument(
        '--list-categories',
        action='store_true',
        help='List available categories and exit'
    )

    # Browser options
    parser.add_argument(
        '--headful',
        action='store_true',
        help='Run browser in visible mode (for debugging)'
    )

    # Logging
    parser.add_argument(
        '-v', '--verbose',
        action='store_true',
        help='Enable verbose output'
    )
    parser.add_argument(
        '--log-file',
        type=str,
        help='Write logs to file in addition to console'
    )

    return parser


def main():
    parser = create_parser()
    args = parser.parse_args()

    logger = setup_logging(args.verbose, args.log_file)
    logger.info(f"Icons8 iOS Icon Scraper v{__version__}")

    # Setup signal handlers for graceful shutdown
    manager = DownloadManager(args, logger)

    def signal_handler(signum, frame):
        logger.info("Interrupt received, saving progress...")
        manager.save_progress()
        if manager.scraper:
            manager.scraper.stop()
        sys.exit(1)

    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)

    # Run download
    try:
        manager.run()
        return 0
    except Exception as e:
        logger.error(f"Fatal error: {e}", exc_info=True)
        manager.save_progress()
        return 1


if __name__ == "__main__":
    sys.exit(main())
