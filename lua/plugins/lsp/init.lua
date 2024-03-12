local plugins = {}

local base = require("plugins.lsp.base")

local function lsp_attach_keymap(ev)
  local client = vim.lsp.get_client_by_id(ev.data.client_id)
  local opts = { buffer = ev.buf }

  if client and client.supports_method('textDocument/declaration') then
    vim.keymap.set('n', 'gd', vim.lsp.buf.declaration,
      vim.tbl_deep_extend("force", opts, { desc = "Jumps to the declaration of the symbol under the cursor" }))
  end

  if client and client.supports_method('textDocument/declaration') then
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,
      vim.tbl_deep_extend("force", opts, { desc = "Jumps to the declaration of the symbol under the cursor" }))
  end

  if client and client.supports_method('textDocument/references') then
    vim.keymap.set('n', '<leader>rf', vim.lsp.buf.references,
      vim.tbl_deep_extend("force", opts, { desc = "Split window to show references" }))
  end

  if client and client.supports_method('textDocument/rename') then
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,
      vim.tbl_deep_extend("force", opts, { desc = "Rename symbol under the cursor" }))
  end

  if client and client.supports_method('textDocument/codeAction') then
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action,
      vim.tbl_deep_extend("force", opts, { desc = "Show code actions" }))
  end
end

local mason = require("plugins.lsp.mason")
local linter = require("plugins.lsp.linter")
local formatter = require("plugins.lsp.formatter")
local extra = require("plugins.lsp.extra")

if not vim.g.vscode then
  plugins = {
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        "hrsh7th/nvim-cmp",
        "williamboman/mason-lspconfig.nvim",
        {
          "folke/neodev.nvim",
          opts = {}
        },
      },
      ft = base.fts,
      init = function()
        -- Global mappings.
        -- See `:help vim.diagnostic.*` for documentation on any of the below functions
        vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })
        vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, { desc = "List all diagnostics" })
      end,
      opts = {
        inlay_hints = {
          enable = true
        },
        codelens = {
          enable = true
        }
      },
      config = function(_, opts)
        local have_mason, mlsp = pcall(require, "mason-lspconfig")

        local function on_attach(fn)
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              local buffer = args.buf ---@type number
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              fn(client, buffer)
            end,
          })
        end

        local function inlay_hints(buf, value)
          local ih = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
          if type(ih) == "function" then
            ih(buf, value)
          elseif type(ih) == "table" and ih.enable then
            if value == nil then
              value = not ih.is_enabled(buf)
            end
            ih.enable(buf, value)
          end
        end

        -- inlay hints
        if opts.inlay_hints.enabled then
          on_attach(function(client, buffer)
            if client.supports_method("textDocument/inlayHint") then
              inlay_hints(buffer, true)
            end
          end)
        end

        -- code lens
        if opts.codelens.enabled and vim.lsp.codelens then
          on_attach(function(client, buffer)
            if client.supports_method("textDocument/codeLens") then
              vim.lsp.codelens.refresh()
              --- autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()
              vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                buffer = buffer,
                callback = vim.lsp.codelens.refresh,
              })
            end
          end)
        end

        local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
          "force",
          {},
          vim.lsp.protocol.make_client_capabilities(),
          has_cmp and cmp_nvim_lsp.default_capabilities() or {},
          opts.capabilities or {}
        )
        local function setup(server)
          local server_opts = vim.tbl_deep_extend("force", {
            capabilities = vim.deepcopy(capabilities),
          }, base.ls_opts[server] or {})

          if mason.lsp_handlers[server] then
            if mason.lsp_handlers[server](server, server_opts) then
              return
            end
          elseif mason.lsp_handlers["*"] then
            if mason.lsp_handlers["*"](server, server_opts) then
              return
            end
          end
          require("lspconfig")[server].setup(server_opts)
        end

        for _, server in pairs(base.language_servers) do
          if not vim.tbl_contains(mason.lsp_ensured_list, server) and
              have_mason and
              not vim.tbl_contains(mlsp.get_installed_servers(), server) then
            setup(server)
          end
        end

        if have_mason then
          mlsp.setup({
            ensure_installed = mason.lsp_ensured_list,
            handlers = { setup }
          })
        end

        -- Use LspAttach autocommand to only map the following keys
        -- after the language server attaches to the current buffer
        vim.api.nvim_create_autocmd("LspAttach", {
          group = vim.api.nvim_create_augroup("UserLspConfig", {}),
          callback = lsp_attach_keymap,
        })
      end,
    }
  }

  local utils = require("utils")
  plugins = utils.arr_concat(plugins,
    mason.plugins,
    linter.plugins,
    formatter.plugins,
    extra.plugins
  )
end

return plugins
