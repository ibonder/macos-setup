return {
  "saghen/blink.cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = { "rafamadriz/friendly-snippets" },
  -- Tagged releases ship a prebuilt fuzzy matcher, so no Rust toolchain needed.
  version = "1.*",
  opts = {
    keymap = { preset = "default" },
    appearance = { nerd_font_variant = "mono" },
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
      ghost_text = { enabled = true },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      providers = {
        lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
      },
    },
    signature = { enabled = true },
  },
  opts_extend = { "sources.default" },
}
