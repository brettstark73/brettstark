/**
 * Escaping tests for the site's Hugo template overrides.
 *
 * Builds a tiny Hugo site that uses the real render-image hook and cover
 * partial from layouts/, then checks the generated HTML. These templates are
 * where the site bypasses html/template escaping (safeHTMLAttr, safeURL), so
 * they are the places an author-supplied value could break out of an attribute.
 */
import { describe, it, expect, beforeAll, afterAll } from 'vitest'
import { execFileSync } from 'node:child_process'
import {
  copyFileSync,
  mkdirSync,
  mkdtempSync,
  readFileSync,
  rmSync,
  writeFileSync,
} from 'node:fs'
import { tmpdir } from 'node:os'
import { dirname, join, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'

const repoRoot = resolve(dirname(fileURLToPath(import.meta.url)), '../..')

const write = (root, rel, content) => {
  const file = join(root, rel)
  mkdirSync(dirname(file), { recursive: true })
  writeFileSync(file, content)
}

const copyLayout = (root, rel) => {
  const dest = join(root, 'layouts', rel)
  mkdirSync(dirname(dest), { recursive: true })
  copyFileSync(join(repoRoot, 'layouts', rel), dest)
}

// Decode the attributes of the first <img> so the test checks what a browser
// would see, not one particular entity spelling.
const imgAttributes = html => {
  const tag = html.match(/<img\b[^>]*>/)
  if (!tag) throw new Error(`no <img> in output:\n${html}`)
  const attrs = {}
  for (const m of tag[0].matchAll(/\s([a-zA-Z-]+)(?:="([^"]*)")?/g)) {
    attrs[m[1]] = (m[2] ?? '')
      .replace(/&#34;|&quot;/g, '"')
      .replace(/&#39;/g, "'")
      .replace(/&lt;/g, '<')
      .replace(/&gt;/g, '>')
      .replace(/&amp;/g, '&')
  }
  return attrs
}

let site
let imagePage
let coverPage

beforeAll(() => {
  site = mkdtempSync(join(tmpdir(), 'brettstark-hugo-'))
  write(
    site,
    'hugo.toml',
    [
      'baseURL = "https://example.com/"',
      'disableKinds = ["taxonomy", "term", "RSS", "sitemap", "robotsTXT", "404", "home", "section"]',
      '[params.cover]',
      '  linkFullImages = true',
    ].join('\n')
  )
  write(
    site,
    'layouts/_default/single.html',
    '<html><body>{{ partial "cover.html" (dict "cxt" . "IsSingle" true "isHidden" false) }}{{ .Content }}</body></html>\n'
  )
  copyLayout(site, '_default/_markup/render-image.html')
  copyLayout(site, 'partials/cover.html')
  write(
    site,
    'content/image.md',
    [
      '---',
      'title: Image',
      '---',
      '',
      '![He said "hi" onerror=alert(1) & <b>left</b>](https://example.com/x.png (A "quoted" title))',
      '',
    ].join('\n')
  )
  write(
    site,
    'content/cover.md',
    [
      '---',
      'title: Cover',
      'cover:',
      '  image: "javascript:alert(1)"',
      '---',
      '',
      'Body.',
      '',
    ].join('\n')
  )
  execFileSync(
    'hugo',
    ['--source', site, '--destination', join(site, 'public'), '--quiet'],
    { stdio: 'pipe' }
  )
  imagePage = readFileSync(join(site, 'public/image/index.html'), 'utf8')
  coverPage = readFileSync(join(site, 'public/cover/index.html'), 'utf8')
})

afterAll(() => {
  if (site) rmSync(site, { recursive: true, force: true })
})

describe('render-image hook (external image path)', () => {
  it('keeps quotes in alt text inside the alt attribute, as plain text', () => {
    const attrs = imgAttributes(imagePage)
    // Hugo's typographer turns "hi" into curly quotes; the alt must hold the
    // characters, not double-escaped entities such as &amp;ldquo;.
    expect(attrs.alt).toBe('He said \u201chi\u201d onerror=alert(1) & left')
    expect(attrs).not.toHaveProperty('onerror')
  })

  it('keeps quotes in the title inside the title attribute', () => {
    expect(imgAttributes(imagePage).title).toBe('A "quoted" title')
  })

  it('still renders src, loading and decoding', () => {
    const attrs = imgAttributes(imagePage)
    expect(attrs.src).toBe('https://example.com/x.png')
    expect(attrs.loading).toBe('lazy')
    expect(attrs.decoding).toBe('async')
  })
})

describe('cover partial', () => {
  it('does not emit a javascript: URL in href or src', () => {
    expect(coverPage).not.toMatch(/(href|src)="javascript:/i)
    expect(coverPage).toContain('#ZgotmplZ')
  })
})
