#!/bin/bash

# Hugo Bulk SEO Fix Script
# Automatically adds descriptions and tags to posts missing them

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONTENT_DIR="$SCRIPT_DIR/../content/posts"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Hugo Bulk SEO Fix Script${NC}"
echo "=================================="

# Function to generate description from title and content
generate_description() {
    local title="$1"
    local content="$2"
    local categories="$3"

    # Extract first meaningful sentence from content (if any)
    local first_sentence=$(echo "$content" | head -n 20 | grep -v "^---" | grep -v "^#" | grep -v "^!" | head -n 1 | cut -c1-120)

    if [ ${#first_sentence} -gt 30 ]; then
        echo "$first_sentence"
    elif [[ "$categories" =~ "travel" ]]; then
        echo "Travel memories and photo highlights from $title"
    elif [[ "$categories" =~ "family" ]]; then
        echo "Family moments and memories from $title"
    elif [[ "$categories" =~ "life" ]]; then
        echo "Life experiences and reflections from $title"
    else
        echo "Memories and experiences from $title"
    fi
}

# Function to generate tags from title, categories, and content
generate_tags() {
    local title="$1"
    local categories="$2"
    local content="$3"
    local year="$4"

    local tags=""

    # Add category-based tags
    if [[ "$categories" =~ "travel" ]]; then
        tags="travel, photography"
    fi
    if [[ "$categories" =~ "family" ]]; then
        tags="${tags}, family"
    fi
    if [[ "$categories" =~ "life" ]]; then
        tags="${tags}, life"
    fi

    # Add location-based tags from title and content
    if [[ "$title$content" =~ [Aa]ustralia ]]; then
        tags="${tags}, australia"
    fi
    if [[ "$title$content" =~ [Gg]ermany|[Rr]egensburg|[Nn]uremberg ]]; then
        tags="${tags}, germany"
    fi
    if [[ "$title$content" =~ [Cc]hicago ]]; then
        tags="${tags}, chicago"
    fi
    if [[ "$title$content" =~ [Ll]ondon|UK|England ]]; then
        tags="${tags}, london, uk"
    fi

    # Add year tag for travel posts
    if [[ "$categories" =~ "travel" ]] && [[ "$year" =~ ^20[0-9][0-9]$ ]]; then
        tags="${tags}, $year"
    fi

    # Add activity-based tags
    if [[ "$title$content" =~ [Hh]alloween ]]; then
        tags="${tags}, halloween"
    fi
    if [[ "$title$content" =~ [Cc]hristmas ]]; then
        tags="${tags}, christmas"
    fi
    if [[ "$title$content" =~ [Aa]utumn|[Ff]all ]]; then
        tags="${tags}, autumn, fall"
    fi

    # Clean up tags
    tags=$(echo "$tags" | sed 's/^, //' | sed 's/,  */, /g')
    echo "$tags"
}

# Function to process a single post
process_post() {
    local post_file="$1"
    local post_dir="$(dirname "$post_file")"
    local post_name="$(basename "$post_dir")"

    if [ ! -f "$post_file" ]; then
        return
    fi

    # Read the file
    local content=$(cat "$post_file")

    # Check if already has description and tags
    local has_description=$(echo "$content" | grep -c "^description:" || true)
    local has_tags=$(echo "$content" | grep -c "^tags:" || true)

    if [ $has_description -gt 0 ] && [ $has_tags -gt 0 ]; then
        echo "  ✓ $post_name (already optimized)"
        return
    fi

    # Extract existing front matter
    local title=$(echo "$content" | awk '/^title:/ {gsub(/^title: *"?|"? *$/, ""); print}')
    local date=$(echo "$content" | awk '/^date:/ {gsub(/^date: */, ""); print}')
    local categories=$(echo "$content" | awk '/^categories:/,/^[a-zA-Z]/' | grep -v "^categories:" | grep -v "^[a-zA-Z]" | tr '\n' ' ')
    local year=$(echo "$date" | cut -d'-' -f1)

    # Extract content after front matter
    local post_content=$(echo "$content" | awk '/^---$/,/^---$/ {if (p) print} /^---$/ {p=!p}')

    # Generate description and tags if missing
    local new_description=""
    local new_tags=""

    if [ $has_description -eq 0 ]; then
        new_description=$(generate_description "$title" "$post_content" "$categories")
    fi

    if [ $has_tags -eq 0 ]; then
        new_tags=$(generate_tags "$title" "$categories" "$post_content" "$year")
    fi

    # Update the file
    if [ $has_description -eq 0 ] || [ $has_tags -eq 0 ]; then
        echo "  → $post_name"

        # Create backup
        cp "$post_file" "${post_file}.backup"

        # Process the file with awk to add missing fields
        awk -v desc="$new_description" -v tags="$new_tags" -v has_desc="$has_description" -v has_tags="$has_tags" '
        BEGIN { in_frontmatter = 0; frontmatter_ended = 0 }
        /^---$/ {
            if (!frontmatter_ended) {
                in_frontmatter = !in_frontmatter
                if (!in_frontmatter) {
                    frontmatter_ended = 1
                    # Add missing fields before closing front matter
                    if (has_desc == 0 && desc != "") {
                        print "description: \"" desc "\""
                    }
                    if (has_tags == 0 && tags != "") {
                        print "tags: [" tags "]"
                    }
                }
            }
            print
            next
        }
        { print }
        ' "$post_file" > "${post_file}.tmp" && mv "${post_file}.tmp" "$post_file"

        [ $has_description -eq 0 ] && echo "    + Description: $new_description"
        [ $has_tags -eq 0 ] && echo "    + Tags: $new_tags"
    fi
}

# Main execution
posts_processed=0
posts_updated=0

echo "Processing all posts..."
echo ""

for post_dir in "$CONTENT_DIR"/*; do
    if [ -d "$post_dir" ]; then
        post_file="$post_dir/index.md"
        if [ -f "$post_file" ]; then
            # Check if needs updating
            content=$(cat "$post_file")
            has_description=$(echo "$content" | grep -c "^description:" || true)
            has_tags=$(echo "$content" | grep -c "^tags:" || true)

            if [ $has_description -eq 0 ] || [ $has_tags -eq 0 ]; then
                process_post "$post_file"
                posts_updated=$((posts_updated + 1))
            fi
            posts_processed=$((posts_processed + 1))
        fi
    fi
done

echo ""
echo -e "${GREEN}✓ SEO optimization complete!${NC}"
echo "Posts processed: $posts_processed"
echo "Posts updated: $posts_updated"
echo ""
echo "Backup files created with .backup extension"
echo "Run 'hugo server' to verify changes"