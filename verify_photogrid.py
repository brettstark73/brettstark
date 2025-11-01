import os
import re

POSTS_DIR = "content/posts"

for root, dirs, files in os.walk(POSTS_DIR):
    for file in files:
        if file == "index.md":
            filepath = os.path.join(root, file)
            with open(filepath, "r") as f:
                content = f.read()

            image_count = len(re.findall(r"!\[.*?\]\(.*?\)", content))

            if image_count > 5:
                if "{{< photogrid >}}" not in content:
                    print(f"Found post with > 5 images and no photogrid: {filepath}")