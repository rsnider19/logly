#!/bin/bash

# Configuration
# SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY must be set in your environment
# Example:
# export SUPABASE_URL=https://your-project.supabase.co
# export SUPABASE_SERVICE_ROLE_KEY=your-service-role-key

CSV_FILE="/Users/robsnider/StudioProjects/logly_app/supabase/Supabase Snippet Activity Icons (1).csv"
BUCKET_NAME="activity_category_icons" # Update this to your storage bucket name
SUPABASE_URL="https://vblosujbjjfiprmlzhyx.supabase.co"
SUPABASE_SERVICE_ROLE_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZibG9zdWpiampmaXBybWx6aHl4Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcyOTAxNDIwMiwiZXhwIjoyMDQ0NTkwMjAyfQ.IYgVHsEc59LMKxkFGxISZw_SaofuVe1Lwnfytn0WXRU"

# Check if environment variables are set
if [ -z "$SUPABASE_URL" ] || [ -z "$SUPABASE_SERVICE_ROLE_KEY" ]; then
  echo "Error: SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY must be set."
  echo "Usage: SUPABASE_URL=... SUPABASE_SERVICE_ROLE_KEY=... $0"
  exit 1
fi

# Check if CSV file exists
if [ ! -f "$CSV_FILE" ]; then
  echo "Error: CSV file not found at $CSV_FILE"
  exit 1
fi

echo "Starting upload process..."

# Use awk to handle CSV columns and skip the header
# -F',' sets field separator to comma
# NR > 1 skips the header line
awk -F',' 'NR > 1 {print $1 "," $2}' "$CSV_FILE" | while IFS=, read -r activity_category_id icon_url; do
  # Remove potential carriage returns and whitespace
  activity_category_id=$(echo "$activity_category_id" | tr -d '\r' | xargs)
  icon_url=$(echo "$icon_url" | tr -d '\r' | xargs)

  if [ -z "$activity_category_id" ] || [ -z "$icon_url" ]; then
    continue
  fi

  echo "--------------------------------------------------"
  echo "Processing: $activity_category_id"
  
  # Temporary file path
  temp_file="/tmp/${activity_category_id}.png"

  # Download the image
  echo "Downloading $icon_url ..."
  curl -s -L "$icon_url" -o "$temp_file"

  if [ $? -ne 0 ]; then
    echo "Error: Failed to download $icon_url"
    continue
  fi

  # Upload to Supabase Storage
  # Note: x-upsert: true allows overwriting existing files
  echo "Uploading to Supabase: ${activity_category_id}.png ..."
  response=$(curl -s -X POST \
    "${SUPABASE_URL}/storage/v1/object/${BUCKET_NAME}/${activity_category_id}.png" \
    -H "Authorization: Bearer ${SUPABASE_SERVICE_ROLE_KEY}" \
    -H "Content-Type: image/png" \
    -H "x-upsert: true" \
    --data-binary "@${temp_file}")

  # Check if response contains an error
  if echo "$response" | grep -q '{"error"'; then
    echo "Error uploading $activity_category_id: $response"
  else
    echo "Successfully uploaded $activity_category_id"
  fi

  # Cleanup
  rm "$temp_file"
done

echo "--------------------------------------------------"
echo "Process completed!"
