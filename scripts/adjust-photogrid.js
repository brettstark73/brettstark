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

function adjust(file) {
  const src = fs.readFileSync(file, 'utf8')
  const re = /\{\{<\s*photogrid\s+images=(['"])([^'"<>]+)\1\s*>\}\}/g
  let changed = false
  const out = src.replace(re, (_, q, val) => {
    const compact = val.replace(/,\s+/g, ',')
    changed = changed || compact !== val
    return `{{< photogrid images=${q}${compact}${q} >}}`
  })
  if (changed) fs.writeFileSync(file, out, 'utf8')
  return changed
}

const root = path.join(process.cwd(), 'content', 'posts')
let count = 0
for (const f of findMarkdownFiles(root)) if (adjust(f)) count++
console.log(`Adjusted ${count} files.`)
