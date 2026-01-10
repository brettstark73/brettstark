#!/usr/bin/env node
/* Convert photogrid blocks to responsive param form: {{< photogrid images="..." >}} */
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

function convertFile(file) {
  const src = fs.readFileSync(file, 'utf8')
  const startRe = /\{\{<\s*photogrid\s*>\}\}/g
  const endRe = /\{\{<\s*\/photogrid\s*>\}\}/g
  let mStart,
    lastIndex = 0,
    result = '',
    changed = false
  while ((mStart = startRe.exec(src))) {
    const sIdx = mStart.index
    endRe.lastIndex = startRe.lastIndex
    const mEnd = endRe.exec(src)
    if (!mEnd) break // unmatched; skip
    const eIdx = mEnd.index + mEnd[0].length
    const inner = src.slice(startRe.lastIndex, mEnd.index)
    // extract image paths like ![](images/...) allowing optional alt/title
    const imgRe = /!\[[^\]]*\]\(([^)]+)\)/g
    let im,
      imgs = []
    while ((im = imgRe.exec(inner))) {
      const raw = im[1].trim().replace(/^"|"$/g, '').replace(/^'|'$/g, '')
      if (/^(\.\/)?images\//.test(raw)) imgs.push(raw.replace(/^\.\//, ''))
    }
    result += src.slice(lastIndex, sIdx)
    if (imgs.length) {
      const param = imgs.join(', ')
      result += `{{< photogrid images="${param}" >}}`
      changed = true
    } else {
      // keep original if nothing found
      result += src.slice(sIdx, eIdx)
    }
    lastIndex = eIdx
    startRe.lastIndex = eIdx
  }
  result += src.slice(lastIndex)
  if (changed && result !== src) {
    fs.writeFileSync(file, result, 'utf8')
    return true
  }
  return false
}

const root = path.join(process.cwd(), 'content', 'posts')
const files = findMarkdownFiles(root)
let count = 0
for (const f of files) if (convertFile(f)) count++
console.log(`Converted photogrid in ${count} files.`)
