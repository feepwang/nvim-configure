local utils = require("utils")
local plugins = {
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {}
  }
}

if not vim.g.vscode then
  local cmp = require("plugins.edit.cmp")
  plugins = utils.arr_concat(plugins, {
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      opts = {
        check_ts = true,
      }
    },
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {}
    }
  }, cmp.plugins)
end

return plugins
