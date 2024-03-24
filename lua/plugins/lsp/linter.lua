local M = {}

M.fts = {
  "proto"
}

M.plugins = {
  {
    "mfussenegger/nvim-lint",
    dependencies = "williamboman/mason.nvim",
    ft = M.fts
  }
}

return M
