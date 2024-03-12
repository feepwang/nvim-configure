local plugins = {}

if not vim.g.vscode then
  local utils = require("utils")
  plugins = utils.arr_concat(plugins, {
    {
      "mfussenegger/nvim-dap",
    },
    {
      "rcarriga/nvim-dap-ui",
      dependencies = {
        "mfussenegger/nvim-dap",
      },
      ft = { "c", "cpp", "go" }
    }
  })
end

return plugins
