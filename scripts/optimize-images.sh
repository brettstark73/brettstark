#!/bin/bash

# Hugo Image Optimization Script
# This script optimizes images in Hugo posts for better web performance

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONTENT_DIR="$SCRIPT_DIR/../content"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Hugo Image Optimization Script${NC}"
echo "======================================"

# Check if ImageMagick is available
if ! command -v magick &> /dev/null; then
    echo -e "${RED}Error: ImageMagick (magick command) is not installed${NC}"
    echo "Install with: brew install imagemagick"
    exit 1
fi

# Function to optimize images in a directory
optimize_directory() {
    local dir="$1"
    local post_name="$(basename "$(dirname "$dir")")"

    if [ ! -d "$dir" ]; then
        return
    fi

    local image_count=0
    local total_before=0
    local total_after=0

    echo -e "${YELLOW}Processing: $post_name${NC}"

    # Create backup if it doesn't exist
    if [ ! -d "${dir}_backup" ]; then
        echo "  Creating backup..."
        cp -r "$dir" "${dir}_backup"
    fi

    # Process JPEG files
    for img in "$dir"/*.jpg "$dir"/*.jpeg "$dir"/*.JPG "$dir"/*.JPEG; do
        if [ -f "$img" ]; then
            local before_size=$(stat -f%z "$img" 2>/dev/null || stat -c%s "$img" 2>/dev/null)

            echo "    Optimizing $(basename "$img")..."
            magick "$img" -quality 82 -resize '1920x1920>' -strip "$img"

            local after_size=$(stat -f%z "$img" 2>/dev/null || stat -c%s "$img" 2>/dev/null)

            total_before=$((total_before + before_size))
            total_after=$((total_after + after_size))
            image_count=$((image_count + 1))
        fi
    done

    if [ $image_count -gt 0 ]; then
        local saved_bytes=$((total_before - total_after))
        local saved_mb=$((saved_bytes / 1024 / 1024))
        local total_before_mb=$((total_before / 1024 / 1024))
        local total_after_mb=$((total_after / 1024 / 1024))
        local percent_saved=0

        if [ $total_before -gt 0 ]; then
            percent_saved=$((saved_bytes * 100 / total_before))
        fi

        echo -e "  ${GREEN}✓ Optimized $image_count images${NC}"
        echo "    Before: ${total_before_mb}MB → After: ${total_after_mb}MB"
        echo "    Saved: ${saved_mb}MB (${percent_saved}%)"
    else
        echo "    No images found"
    fi

    echo ""
}

# Main execution
if [ $# -eq 0 ]; then
    echo "Optimizing all post images..."
    echo ""

    # Find all image directories in posts
    find "$CONTENT_DIR/posts" -name "images" -type d | while read -r img_dir; do
        optimize_directory "$img_dir"
    done
else
    # Optimize specific post
    POST_NAME="$1"
    IMG_DIR="$CONTENT_DIR/posts/$POST_NAME/images"

    if [ ! -d "$IMG_DIR" ]; then
        echo -e "${RED}Error: Post '$POST_NAME' not found or has no images directory${NC}"
        exit 1
    fi

    optimize_directory "$IMG_DIR"
fi

echo -e "${GREEN}✓ Image optimization complete!${NC}"
echo ""
echo "Tips:"
echo "• Run 'hugo server' to verify images still display correctly"
echo "• Original images are backed up in *_backup directories"
echo "• This script uses 82% JPEG quality and max 1920px width/height"