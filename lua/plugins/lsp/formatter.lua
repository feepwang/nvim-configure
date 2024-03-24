local M = {}

M.fts = {
  "cmake",
  "gomod",
  "proto"
}

M.plugins = {
  {
    "stevearc/conform.nvim",
    dependencies = "williamboman/mason.nvim",
    ft = M.fts,
    opts = {},
  }
}

return M
