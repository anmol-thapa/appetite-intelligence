module.exports = {
  env: {
    es6: true,
    node: true,
  },
  parserOptions: {
    'ecmaVersion': 2018,
    'sourceType': 'script',
  },
  extends: [
    'eslint:recommended',
    'google',
  ], rules: {
    'no-restricted-globals': ['error', 'name', 'length'],
    'prefer-arrow-callback': 'error',
    // "quotes": ["error", "single", { "allowTemplateLiterals": true }],

    'indent': 'off',
    'max-len': 'off', // disables line length errors
    // "comma-dangle": "off",
    // "semi": "off",
    'require-jsdoc': 'off', // disables Google style doc warnings
    'object-curly-spacing': 'off', // disables spacing around object braces
  },

  overrides: [
    {
      files: ['**/*.spec.*'],
      env: {
        mocha: true,
      },
      rules: {},
    },
  ],
  globals: {},
};
