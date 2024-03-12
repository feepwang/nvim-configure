local M = {}

-- make all keymaps silent by default
local keymap_set = vim.keymap.set
---@diagnostic disable-next-line: duplicate-set-field
vim.keymap.set = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  return keymap_set(mode, lhs, rhs, opts)
end

-- initialize
function M.init()
  pcall(require, "config.keymaps")
  pcall(require, "config.options")

  local loaded, setup_lazy = pcall(require, "config.lazy")
  if loaded then
    setup_lazy({})
  end
end

return M
