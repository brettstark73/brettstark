#!/usr/bin/env node
const fs = require('fs')
const path = require('path')

function findMarkdownFiles(dir) {
  const out = []
  const stack = [dir]
  while (stack.length) {
    const d = stack.pop()
    for (const e of fs.readdirSync(d)) {
      const p = path.join(d, e)
      const st = fs.statSync(p)
      if (st.isDirectory()) stack.push(p)
      else if (st.isFile() && e.endsWith('.md')) out.push(p)
    }
  }
  return out
}

function fix(file) {
  const src = fs.readFileSync(file, 'utf8')
  const openRe = /\{\{<\s*photogrid\s+images=(?:'[^']+'|"[^"]+")\s*>\}\}/g
  const closeRe = /\{\{<\s*\/photogrid\s*>\}\}/g
  let changed = false
  // If file contains an open with images but no close, append close immediately after each open
  if (openRe.test(src)) {
    // reset lastIndex
    openRe.lastIndex = 0
    let out = ''
    let last = 0
    let m
    while ((m = openRe.exec(src))) {
      out += src.slice(last, m.index) + m[0] + '{{< /photogrid >}}'
      last = openRe.lastIndex
      changed = true
    }
    out += src.slice(last)
    // Avoid duplicating if a close already exists right after
    out = out.replace(
      /\}\}\{\{<\s*\/photogrid\s*>\}\}/g,
      '}}{{< /photogrid >}}'
    )
    fs.writeFileSync(file, out, 'utf8')
    return true
  }
  return false
}

const root = path.join(process.cwd(), 'content', 'posts')
let count = 0
for (const f of findMarkdownFiles(root)) if (fix(f)) count++
console.log(`Ensured closing tag in ${count} files.`)
