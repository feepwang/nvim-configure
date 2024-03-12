-- vim.g.node_host_prog = "/Users/folke/.pnpm-global/5/node_modules/neovim/bin/cli.js"
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

-- fold
vim.go.foldlevelstart = 3

vim.wo.number = true
vim.wo.numberwidth = 3
vim.wo.wrap = false

-- disable inline diagnostic
vim.diagnostic.config({
  sign = {
    severity = vim.diagnostic.severity.WARN
  },
  underline = {
    severity = vim.diagnostic.severity.WARN
  },
  virtual_text = false,
})

-- default tab style
vim.bo.tabstop = 4
vim.bo.shiftwidth = 0

-- search/replace
vim.go.ignorecase = true
vim.go.smartcase = true
