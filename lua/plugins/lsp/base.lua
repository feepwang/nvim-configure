local M = {}

M.language_servers = {
  lua = "lua_ls",
  c = "clangd",
  cpp = "clangd",
  cmake = "cmake",
  go = "gopls"
}

M.ls_opts = {
  lua_ls = {
    settings = {
      Lua = {
        workspace = { checkThirdParty = false, },
        codeLens = { enable = true, },
        completion = { callSnippet = "Replace", },
      },
    },
  },
  clangd = {
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" }
  }
}

M.formatters = {
  go = { "gofumpt" }
}

M.fts = vim.tbl_keys(M.language_servers)

return M
