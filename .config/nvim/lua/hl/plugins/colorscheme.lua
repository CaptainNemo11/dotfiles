return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
  config = function() 
    require("catppuccin").setup({
    integrations = {
      cmp = true,
      gitsigns = true,
      nvimtree = true,
      treesitter = true,
      notify = false,
      mini = {
          enabled = true,
          indentscope_color = "",
      },
      -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
      indent_blankline = {
        enabled = true,
        scope_color = "", -- catppuccin color (eg. `lavender`) Default: text
        colored_indent_levels = false,
      },
      mason = false,
      dap = true,
      dap_ui = true,
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = { "italic" },
          hints = { "italic" },
          warnings = { "italic" },
          information = { "italic" },
          ok = { "italic" },
        },
        underlines = {
          errors = { "underline" },
          hints = { "underline" },
          warnings = { "underline" },
          information = { "underline" },
          ok = { "underline" },
        },
        inlay_hints = {
          background = true,
        },
      },
      nvim_surround = false,
      nvimtree = true,
      treesitter_context = true,
      telescope = {
        enabled = true,
        -- style = "nvchad"
      },
      which_key = false,
    },
    })
  vim.cmd.colorscheme "catppuccin"
  end
}
