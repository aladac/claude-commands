---
description: Search the web for a subject and store categorized documentation
args:
  - name: subject
    description: "Topic to search for and document"
    type: string
    required: true
  - name: category
    description: "Category subdirectory (e.g., rust, web, devops)"
    type: string
  - name: glob
    description: "Store in global ~/Projects/docs/ instead of project-local ./docs/"
    type: boolean
    default: false
---

Search the web for the specified subject and create organized documentation.

## Workflow

1. **Parse Arguments**
   - Extract `subject` from `$ARGUMENTS` (required)
   - Extract `category` if provided (optional subdirectory)
   - Check for `glob` flag to determine storage location

2. **Determine Output Path**
   - If `glob` is set: `~/Projects/docs/{category}/{subject}.md`
   - Otherwise: `./docs/{category}/{subject}.md`
   - If no category: omit the category subdirectory
   - Slugify the subject for the filename (lowercase, hyphens for spaces)

3. **Search the Web**
   Use `WebSearch` to find authoritative information about the subject:
   - Search for: `{subject} documentation guide tutorial`
   - Search for: `{subject} best practices examples`
   - Focus on official docs, reputable sources, recent content

4. **Synthesize Documentation**
   Create a comprehensive markdown document with:

   ```markdown
   ---
   subject: {subject}
   category: {category or "general"}
   sources:
     - {url1}
     - {url2}
   fetched: {YYYY-MM-DD}
   ---

   # {Subject Title}

   ## Overview
   {Brief introduction and what this is}

   ## Key Concepts
   {Main ideas, terminology, fundamentals}

   ## Usage / Getting Started
   {How to use, install, or get started}

   ## Examples
   {Code examples, practical usage}

   ## Best Practices
   {Recommendations, patterns, tips}

   ## Common Issues
   {Troubleshooting, gotchas, FAQs}

   ## References
   - [Source Title](url)
   - [Source Title](url)
   ```

5. **Write the File**
   - Create directory structure if needed: `mkdir -p {output_dir}`
   - Write the documentation file
   - Report the file path and a summary

## Examples

- `/docs:get rust traits` → `./docs/rust/traits.md`
- `/docs:get "kubernetes pods"` → `./docs/kubernetes-pods.md`
- `/docs:get typescript generics glob` → `~/Projects/docs/typescript-generics.md`
- `/docs:get "github actions" devops glob` → `~/Projects/docs/devops/github-actions.md`

## Output

After completion, display:

```
Documentation saved: {path}

Subject: {subject}
Category: {category or "none"}
Sources: {count} references
```
