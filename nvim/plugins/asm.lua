-- ARM64 / GNU assembler support
return {
  -- treesitter parser: highlighting + indent for .s files
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "asm" })
    end,
  },
  -- LSP: mason-lspconfig auto-installs the matching asm-lsp mason package
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        asm_lsp = {
          filetypes = { "asm", "vmasm" },
        },
      },
    },
  },
}
