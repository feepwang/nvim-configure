local opt = vim.opt

if vim.fn.has("nvim-0.8") == 1 then
  vim.opt.backup = true
  vim.opt.cmdheight = 0
  vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup"
end

-- vim.g.node_host_prog = "/Users/folke/.pnpm-global/5/node_modules/neovim/bin/cli.js"
-- vim.g.loaded_python3_provider = 0
-- vim.g.loaded_perl_provider = 0
-- vim.g.loaded_ruby_provider = 0
-- vim.g.loaded_node_provider = 0

-- appearance
opt.number = true
opt.numberwidth = 3
opt.wrap = false

-- default tab style
opt.tabstop = 2
opt.shiftwidth = 2
opt.smartindent = true

-- search/replace
opt.ignorecase = true
opt.smartcase = true

if vim.g.neovide then
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_scroll_animation_length = 0
end
