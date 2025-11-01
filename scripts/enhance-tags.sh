#!/bin/bash

# Enhanced Hugo Tag Generation Script
# Adds comprehensive tags to posts based on titles, categories, and patterns

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONTENT_DIR="$SCRIPT_DIR/../content/posts"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Enhanced Hugo Tag Generation Script${NC}"
echo "==========================================="

# Enhanced tag generation function
generate_comprehensive_tags() {
    local title="$1"
    local categories="$2"
    local content="$3"
    local year="$4"
    local post_name="$5"

    local tags=""

    # Category-based tags (always add these)
    if [[ "$categories" =~ "travel" ]]; then
        tags="travel, photography"
    fi
    if [[ "$categories" =~ "family" ]]; then
        tags="${tags}, family"
    fi
    if [[ "$categories" =~ "life" ]]; then
        tags="${tags}, life"
    fi
    if [[ "$categories" =~ "business" ]]; then
        tags="${tags}, business"
    fi
    if [[ "$categories" =~ "chicago" ]]; then
        tags="${tags}, chicago"
    fi
    if [[ "$categories" =~ "home" ]]; then
        tags="${tags}, home"
    fi
    if [[ "$categories" =~ "general" ]]; then
        tags="${tags}, personal"
    fi
    if [[ "$categories" =~ "technology" ]]; then
        tags="${tags}, technology"
    fi

    # Location-based tags from title and content
    local text="$title $content $post_name"

    # Countries
    if [[ "$text" =~ [Aa]ustralia ]]; then
        tags="${tags}, australia"
    fi
    if [[ "$text" =~ [Gg]ermany|[Rr]egensburg|[Nn]uremberg|[Bb]erlin ]]; then
        tags="${tags}, germany"
    fi
    if [[ "$text" =~ [Cc]hicago ]]; then
        tags="${tags}, chicago"
    fi
    if [[ "$text" =~ [Ll]ondon|UK|England ]]; then
        tags="${tags}, london, uk"
    fi
    if [[ "$text" =~ [Pp]aris ]]; then
        tags="${tags}, paris, france"
    fi
    if [[ "$text" =~ [Bb]eijing|China ]]; then
        tags="${tags}, beijing, china"
    fi
    if [[ "$text" =~ [Bb]ali ]]; then
        tags="${tags}, bali, indonesia"
    fi
    if [[ "$text" =~ [Ss]ydney ]]; then
        tags="${tags}, sydney"
    fi
    if [[ "$text" =~ [Mm]ichigan ]]; then
        tags="${tags}, michigan"
    fi

    # Year tags for travel and significant posts
    if [[ "$year" =~ ^20[0-9][0-9]$ ]]; then
        if [[ "$categories" =~ "travel" ]] || [[ "$title" =~ [0-9]{4} ]]; then
            tags="${tags}, $year"
        fi
    fi

    # Activity/Event-based tags from titles
    if [[ "$text" =~ [Hh]alloween ]]; then
        tags="${tags}, halloween"
    fi
    if [[ "$text" =~ [Cc]hristmas ]]; then
        tags="${tags}, christmas"
    fi
    if [[ "$text" =~ [Aa]utumn|[Ff]all ]]; then
        tags="${tags}, autumn, fall"
    fi
    if [[ "$text" =~ [Ss]now ]]; then
        tags="${tags}, snow, winter"
    fi
    if [[ "$text" =~ [Cc]amping ]]; then
        tags="${tags}, camping, outdoors"
    fi
    if [[ "$text" =~ [Gg]raduat ]]; then
        tags="${tags}, graduation, milestone"
    fi
    if [[ "$text" =~ [Ww]edding ]]; then
        tags="${tags}, wedding"
    fi
    if [[ "$text" =~ [Bb]irthday ]]; then
        tags="${tags}, birthday, celebration"
    fi

    # Theme park / Entertainment
    if [[ "$text" =~ [Ss]ix.*[Ff]lags|[Tt]heme.*[Pp]ark ]]; then
        tags="${tags}, theme-park, entertainment"
    fi
    if [[ "$text" =~ [Dd]isney ]]; then
        tags="${tags}, disney, theme-park"
    fi
    if [[ "$text" =~ U2|concert ]]; then
        tags="${tags}, concert, music"
    fi

    # Life events
    if [[ "$text" =~ [Pp]andemic ]]; then
        tags="${tags}, pandemic, covid-19"
    fi
    if [[ "$text" =~ [Rr]ecap|[Rr]eview ]]; then
        tags="${tags}, year-review, reflection"
    fi
    if [[ "$text" =~ 50th ]]; then
        tags="${tags}, birthday, milestone, 50th"
    fi

    # Technology
    if [[ "$text" =~ PC|[Bb]uilding ]]; then
        tags="${tags}, technology, diy"
    fi
    if [[ "$text" =~ CES ]]; then
        tags="${tags}, technology, ces, vegas"
    fi

    # Animals/Pets
    if [[ "$text" =~ [Hh]orse|[Bb]riscoe ]]; then
        tags="${tags}, pets, animals"
    fi

    # General photo posts (if has images but minimal other tags)
    if [ -d "$(dirname "$(find "$CONTENT_DIR" -name "index.md" | grep "$post_name")")/images" ]; then
        if [[ ! "$tags" =~ photography ]]; then
            tags="${tags}, photography"
        fi
    fi

    # Clean up tags
    tags=$(echo "$tags" | sed 's/^, //' | sed 's/,  */, /g' | sed 's/, $//')

    # Ensure every post has at least basic tags
    if [ -z "$tags" ]; then
        if [[ "$categories" =~ "travel" ]]; then
            tags="travel, memories"
        elif [[ "$categories" =~ "family" ]]; then
            tags="family, memories"
        elif [[ "$categories" =~ "life" ]]; then
            tags="life, personal"
        else
            tags="memories"
        fi
    fi

    echo "$tags"
}

# Function to process a single post
enhance_post_tags() {
    local post_file="$1"
    local post_dir="$(dirname "$post_file")"
    local post_name="$(basename "$post_dir")"

    if [ ! -f "$post_file" ]; then
        return
    fi

    # Read the file
    local content=$(cat "$post_file")

    # Check if already has tags
    local has_tags=$(echo "$content" | grep -c "^tags:" || true)

    if [ $has_tags -gt 0 ]; then
        echo "  ✓ $post_name (already has tags)"
        return
    fi

    # Extract existing front matter
    local title=$(echo "$content" | awk '/^title:/ {gsub(/^title: *"?|"? *$/, ""); print}')
    local date=$(echo "$content" | awk '/^date:/ {gsub(/^date: */, ""); print}')
    local categories=$(echo "$content" | awk '/^categories:/,/^[a-zA-Z]/' | grep -v "^categories:" | grep -v "^[a-zA-Z]" | tr '\n' ' ')
    local year=$(echo "$date" | cut -d'-' -f1)

    # Extract content after front matter
    local post_content=$(echo "$content" | awk '/^---$/,/^---$/ {if (p) print} /^---$/ {p=!p}')

    # Generate comprehensive tags
    local new_tags=$(generate_comprehensive_tags "$title" "$categories" "$post_content" "$year" "$post_name")

    if [ -n "$new_tags" ]; then
        echo "  → $post_name"

        # Create backup
        cp "$post_file" "${post_file}.tags-backup"

        # Add tags after description line or before closing front matter
        awk -v tags="$new_tags" '
        BEGIN { in_frontmatter = 0; frontmatter_ended = 0; tags_added = 0 }
        /^---$/ {
            if (!frontmatter_ended) {
                in_frontmatter = !in_frontmatter
                if (!in_frontmatter && !tags_added) {
                    frontmatter_ended = 1
                    # Add tags before closing front matter
                    print "tags: [" tags "]"
                    tags_added = 1
                }
            }
            print
            next
        }
        # Add after description if it exists
        /^description:/ && in_frontmatter && !tags_added {
            print
            print "tags: [" tags "]"
            tags_added = 1
            next
        }
        { print }
        ' "$post_file" > "${post_file}.tmp" && mv "${post_file}.tmp" "$post_file"

        echo "    + Tags: $new_tags"
    fi
}

# Main execution
posts_processed=0
posts_updated=0

echo "Processing posts without tags..."
echo ""

for post_dir in "$CONTENT_DIR"/*; do
    if [ -d "$post_dir" ]; then
        post_file="$post_dir/index.md"
        if [ -f "$post_file" ]; then
            # Check if needs tags
            content=$(cat "$post_file")
            has_tags=$(echo "$content" | grep -c "^tags:" || true)

            if [ $has_tags -eq 0 ]; then
                enhance_post_tags "$post_file"
                posts_updated=$((posts_updated + 1))
            fi
            posts_processed=$((posts_processed + 1))
        fi
    fi
done

echo ""
echo -e "${GREEN}✓ Enhanced tagging complete!${NC}"
echo "Posts processed: $posts_processed"
echo "Posts updated: $posts_updated"
echo ""
echo "Backup files created with .tags-backup extension"