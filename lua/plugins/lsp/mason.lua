local M = {}

M.lsp_ensured_list = { "lua_ls" }
M.lsp_handlers = {}

M.plugins = {
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = "williamboman/mason.nvim"
  },
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = { "Mason", "MasonUpdate", "MasonInstall" },
    opts = {}
  },
}

return M
