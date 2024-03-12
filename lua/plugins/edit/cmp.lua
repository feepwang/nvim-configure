local M = {}

local cmp_dependencies = {
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "windwp/nvim-autopairs",
}

local cmp_sources = {
  { name = "nvim_lsp" },
  { name = "buffer" },
  { name = "path" }
}

M.plugins = {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = cmp_dependencies,
    config = function()
      local cmp = require('cmp')

      cmp.setup({
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert(),
        sources = cmp_sources,
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" }
        }, {
          { name = "cmdline" }
        })
      })

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" }
        }
      })

      local exist, autopairs = pcall(require, "nvim-autopairs.completion.cmp")
      if exist then
        cmp.event:on(
          "confirm_done",
          autopairs.on_confirm_done()
        )
      end
    end
  }
}

return M
