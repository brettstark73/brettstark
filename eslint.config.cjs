const js = require('@eslint/js')
const globals = require('globals')


// Complexity gates (AI quality)
configs.push({
  files: ['**/*.{js,jsx,ts,tsx,mjs,cjs}'],
  rules: {
    complexity: ['warn', 15],
    'max-depth': ['warn', 4],
    'max-params': ['warn', 5],
  },
})


// Import verification (eslint-plugin-n)
let nPlugin = null
try {
  nPlugin = require('eslint-plugin-n')
} catch {
  // eslint-plugin-n not installed
}

if (nPlugin) {
  configs.push({
    files: ['**/*.{js,mjs,cjs}'],
    plugins: { n: nPlugin },
    rules: {
      'n/no-missing-require': 'error',
      'n/no-missing-import': 'off', // Often handled by bundlers
      'n/no-unpublished-require': 'off',
    },
  })
}

module.exports = [
  {
    ignores: [
      '**/node_modules/**',
      '**/dist/**',
      '**/build/**',
      '**/public/**',
      '**/layouts/**',
      '**/themes/**',
      '**/content/**',
      '**/static/**',
      '**/resources/**',
      '**/.lighthouseci/**',
      '**/*.html',
    ],
  },
  js.configs.recommended,
  {
    files: ['**/*.{js,jsx,mjs,cjs}'],
    languageOptions: {
      ecmaVersion: 2022,
      sourceType: 'module',
      globals: {
        ...globals.browser,
        ...globals.node,
      },
    },
    rules: {},
  },
]
