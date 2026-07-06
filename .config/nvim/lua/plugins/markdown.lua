return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      checkbox = {
        enabled = true,
      },
      -- LazyVim's markdown extra sets heading.icons = {} (background tint only, no
      -- marker replacement) — restore the icon-per-level look on top of that default.
      heading = {
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
    },
  },
}
