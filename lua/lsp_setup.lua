local autocmd = vim.api.nvim_create_autocmd

-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require('lspconfig')


-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
require'lspconfig'.pylsp.setup{
  capabilities = capabilities,
  settings = {
    pylsp = {
      plugins = {
          ruff = {
              enabled = true,
              formatEnabled = true,
              extendSelect = { "I", "E", "W" },
              extendIgnore = { "E501" },
              format = { "I" },
              preview = true,
          }
      }
    }
  }
}

local servers = { 'gopls' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
  }
end

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
    ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
    -- C-b (back) C-f (forward) for snippet placeholder navigation.
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {noremap = true})
vim.keymap.set('n', '<leader>ri', function()
    vim.lsp.buf.code_action { context = { only = { "source.organizeImports" } }, apply = true }
end, {noremap = true})
vim.keymap.set('n', '<leader>f', function()
    vim.lsp.buf.format({async = false})
end, {noremap = true})

vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, {noremap = true})
vim.keymap.set('n', '<C-c>g', vim.lsp.buf.definition, {noremap = true})
vim.keymap.set('n', '<C-c><C-c>g', function()
    vim.cmd "tab split"
    vim.lsp.buf.definition()
end, {noremap = true})

vim.api.nvim_create_user_command(
    "OR",
    function()
        vim.lsp.buf.code_action { context = { only = { "source.organizeImports" } }, apply = true }
    end,
    {}
)

-- https://cs.opensource.google/go/x/tools/+/refs/tags/gopls/v0.17.1:gopls/doc/vim.md#neovim-imports
autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        local params = vim.lsp.util.make_range_params()
        params.context = {only = {"source.organizeImports"}}
        -- buf_request_sync defaults to a 1000ms timeout. Depending on your
        -- machine and codebase, you may want longer. Add an additional
        -- argument after params if you find that you have to write the file
        -- twice for changes to be saved.
        -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
        for cid, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
                if r.edit then
                    local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                    vim.lsp.util.apply_workspace_edit(r.edit, enc)
                end
            end
        end
        vim.lsp.buf.format({async = false})
    end
})

autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        vim.fn.timer_start(200, function()
            vim.diagnostic.setloclist()
        end)
    end
})
