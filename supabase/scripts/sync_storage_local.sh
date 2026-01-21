#!/bin/bash

# Configuration
BUCKETS=("activity_category_icons" "activity_icons" "sub_activity_icons")
TEMP_DIR="./temp_storage_sync"

# Progress Bar function
# Arguments: current, total, label
progress_bar() {
    local current=$1
    local total=$2
    local label=$3
    local width=40
    
    if [ "$total" -eq 0 ]; then
        local percent=0
    else
        local percent=$((current * 100 / total))
    fi
    
    local completed=$((current * width / total))
    local remaining=$((width - completed))
    
    printf "\r  %-12s [%-40s] %d%% (%d/%d)" "$label" "$(printf '#%.0s' $(seq 1 $completed 2>/dev/null); printf ' %.0s' $(seq 1 $remaining 2>/dev/null))" "$percent" "$current" "$total"
}

for BUCKET_NAME in "${BUCKETS[@]}"; do
    echo "--------------------------------------------------"
    echo "🔄 Syncing bucket '$BUCKET_NAME'..."

    # 1. Count total files
    echo -n "  📊 Calculating total files... "
    # Filter out CLI noise and directories to get an accurate file count
    TOTAL_FILES=$(supabase storage ls -r "ss:///$BUCKET_NAME" --experimental 2>/dev/null \
        | grep -v "Initialising" \
        | grep -v "Loading page" \
        | grep -v "new version" \
        | grep -v "recommend updating" \
        | grep -v "/$" \
        | grep -c "." || echo 0)
    
    if [ "$TOTAL_FILES" -eq 0 ]; then
        echo "Empty or bucket not found."
        continue
    fi
    echo "$TOTAL_FILES files found."

    # 2. Download from Remote
    mkdir -p "$TEMP_DIR"
    CURRENT=0
    progress_bar 0 "$TOTAL_FILES" "Downloading"
    
    while IFS= read -r line; do
        if [[ "$line" == Downloading:* ]]; then
            ((CURRENT++))
            progress_bar "$CURRENT" "$TOTAL_FILES" "Downloading"
        fi
    done < <(supabase storage cp -r "ss:///$BUCKET_NAME" "$TEMP_DIR" --experimental 2>&1)
    echo ""

    # 3. Upload to Local
    CURRENT=0
    progress_bar 0 "$TOTAL_FILES" "Uploading"
    
    while IFS= read -r line; do
        if [[ "$line" == Uploading:* ]]; then
            ((CURRENT++))
            progress_bar "$CURRENT" "$TOTAL_FILES" "Uploading"
        fi
    done < <(supabase storage cp -r "$TEMP_DIR/$BUCKET_NAME" "ss:///" --local --experimental 2>&1)
    echo ""

    # 4. Cleanup
    rm -rf "$TEMP_DIR"
done

echo "--------------------------------------------------"
echo "✨ All buckets synchronized!"
