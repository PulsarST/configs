-- Mason setup
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "pyright" }, -- optional
  -- automatic_enable is true by default
})
local cmp_autopairs = require("nvim-autopairs.completion.cmp")

-- nvim-cmp setup
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  }),
})

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- capabilities (so LSP knows we support completion)
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Configure Lua LSP
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = { library = vim.api.nvim_get_runtime_file("", true) },
      telemetry = { enable = false },
    },
  },
})

-- Configure Pyright (optional)
vim.lsp.config("pyright", {
  capabilities = capabilities,
})

-- Define your on_attach once
local function on_attach(_, bufnr)
  local opts = { buffer = bufnr, silent = true }

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gb", "<C-o>", opts)
end

-- Hook into *all* LSPs automatically
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    on_attach(nil, bufnr)
  end,
})


