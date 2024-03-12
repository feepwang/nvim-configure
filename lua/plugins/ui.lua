return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    init = function()
      vim.opt.termguicolors = true
    end,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme kanagawa]])
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
  }
}
