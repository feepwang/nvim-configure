-- list supported languages
local language_ls = {
  lua = "lua_ls",
  c = "clangd",
  cpp = "clangd",
  cmake = "cmake",
  go = "gopls",
  proto = "bufls"
}
local mason_ensure_installed = { "lua_ls" }
local lsp_fts = vim.tbl_keys(language_ls)
local lsp_handlers = {}
local lsp_opts = {
  lua_ls = {
    settings = {
      Lua = {
        workspace = { checkThirdParty = false, },
        codeLens = { enable = true, },
        completion = { callSnippet = "Replace", },
      },
    },
  },
  clangd = {
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" }
  }
}

local function lsp_attach_keymap(ev)
  -- Buffer local mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {
    buffer = ev.buf,
    desc = "Go to definition"
  })
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {
    buffer = ev.buf,
    desc = "Go to Declaration"
  })
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {
    buffer = ev.buf,
    desc = "Go to Implementation"
  })
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, {
    buffer = ev.buf,
    desc = "Show all References"
  })
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = ev.buf })
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { buffer = ev.buf })
  -- vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { buffer = ev.buf })
  -- vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { buffer = ev.buf })
  -- vim.keymap.set('n', '<leader>wl', function()
  --     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, { buffer = ev.buf })
  vim.keymap.set('n', '<leader>f', function()
    vim.lsp.buf.format { async = true }
  end, { buffer = ev.buf, desc = "Format" })
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, {
    buffer = ev.buf,
    desc = "Go to type definition"
  })
  vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {
    buffer = ev.buf,
    desc = "Show all code actions"
  })
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {
    buffer = ev.buf,
    desc = "Rename symbol under the cursor"
  })
end

return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = { "Mason", "MasonUpdate", "MasonInstall" },
    opts = {}
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/nvim-cmp",
      {
        "williamboman/mason-lspconfig.nvim",
        dependencies = "williamboman/mason.nvim"
      },
      {
        "folke/neodev.nvim",
        opts = {}
      },
    },
    ft = lsp_fts,
    init = function()
      -- Global mappings.
      -- See `:help vim.diagnostic.*` for documentation on any of the below functions
      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, { desc = "Show diagnostic" })
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Goto previous diagnostic" })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Goto next diagnostic" })
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, { desc = "List all diagnostics" })
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
      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      end

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

      local servers = lsp_opts
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
        }, servers[server] or {})

        if lsp_handlers[server] then
          if lsp_handlers[server](server, server_opts) then
            return
          end
        elseif lsp_handlers["*"] then
          if lsp_handlers["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if vim.tbl_contains(all_mslp_servers, server) and vim.tbl_contains(mason_ensure_installed, server) then
            ensure_installed[#ensure_installed + 1] = server
          else
            setup(server)
          end
        end
      end

      if have_mason then
        mlsp.setup({
          ensure_installed = { "lua_ls" },
          handlers = { setup }
        })
      end

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = lsp_attach_keymap,
      })
    end,
  }
}
