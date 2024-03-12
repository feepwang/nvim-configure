local fzf_keybinding = function()
  -- lsp
  vim.keymap.set({ "n", "v", "x" },
    "<leader>p", "<cmd>lua require('fzf-lua').files()<CR>",
    {
      silent = true,
      desc = "Go to File",
    })
  vim.keymap.set({ "n", "v", "x" },
    "<leader>t", "<cmd>lua require('fzf-lua').lsp_live_workspace_symbols()<CR>",
    {
      silent = true,
      desc = "Go to Symbol in Workspace",
    })
  vim.keymap.set({ "n", "v", "x" }, "<leader>o",
    "<cmd>lua require('fzf-lua').lsp_document_symbols()<CR>",
    {
      silent = true,
      desc = "Go to Symbol in Buffer",
    })
end

return {
  {
    "ibhagwan/fzf-lua",
    dependencies = "nvim-tree/nvim-web-devicons",
    init = function()
      fzf_keybinding()
    end,
    cmd = { "FzfLua" },
    opts = {},
  },
}
