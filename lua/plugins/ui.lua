local plugins = {}

if not vim.g.vscode then
  local utils = require("utils")
  plugins = utils.arr_concat(plugins, {
    -- {
    --   "rebelot/kanagawa.nvim",
    --   lazy = false,
    --   priority = 1000,
    --   config = function()
    --     require("kanagawa").load("lotus")
    --   end
    -- },
    {
      "gruvbox-community/gruvbox",
      lazy = false,
      priority = 1000,
      config = function()
        vim.cmd.colorscheme("gruvbox")
        vim.go.background = "light"
        vim.go.termguicolors = true
      end
    },
    {
      'crispgm/nvim-tabline',
      dependencies = 'nvim-tree/nvim-web-devicons', -- optional
      event = "VeryLazy",
      config = true
    },
    {
      'nvim-lualine/lualine.nvim',
      dependencies = 'nvim-tree/nvim-web-devicons',
      event = "VeryLazy",
      opts = {
        options = {
          theme = 'auto'
        }
      }
    },
    {
      "anuvyklack/windows.nvim",
      dependencies = "anuvyklack/middleclass",
      event = "VeryLazy",
      config = function()
        require("windows").setup({})
        vim.keymap.set('n', '<C-w>m', "<CMD>WindowsMaximize<CR>", { desc = "Maximize the current window" })
        vim.keymap.set('n', '<C-w>_', "<CMD>WindowsMaximizeVertically<CR>", { desc = "Max out the height" })
        vim.keymap.set('n', '<C-w>|', "<CMD>WindowsMaximizeHorizontally<CR>", { desc = "Max out the width" })
        vim.keymap.set("n", "<C-w>=", "<CMD>WindowsEqualize<CR>", { desc = "Equally higt and wide" })
      end
    },
    {
      "OXY2DEV/markview.nvim",
      lazy = false,
      -- ft = "markdown"
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
      }
    }
  })
end

return plugins
