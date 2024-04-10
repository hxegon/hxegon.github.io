# A hidden default task so it lists commands when you call just with no args
_default:
    @just --list

# Build the blog
build:
    hugo

# Build the blog, including drafts
build-drafts:
    hugo --buildDrafts

# Build the blog every time a file changes, including drafts
serve:
    hugo server --buildDrafts

# Create a new post
new-post NAME:
    hugo new content posts/{{NAME}}.md
