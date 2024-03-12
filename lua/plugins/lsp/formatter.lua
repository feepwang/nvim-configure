local M = {}

local base = require("plugins.lsp.base")

M.plugins = {
  {
    "stevearc/conform.nvim",
    dependencies = "williamboman/mason.nvim",
    ft = base.fts,
    opts = {
      formatters_by_ft = {
        go = { "gofumpt" }
      }
    },
    config = function (_, opts)
      local conform = require("conform")
      conform.setup(opts)
      vim.bo.formatexpr = "v:lua.require('conform').formatexpr()"
    end
  }
}

return M
