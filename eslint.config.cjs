const js = require('@eslint/js')
const globals = require('globals')

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
