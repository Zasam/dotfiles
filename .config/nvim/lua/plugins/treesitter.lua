return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    -- Main config goes here
    main = "nvim-treesitter.configs",
    opts = {
        ensure_installed = { "rust", "toml", "ron", "c_sharp", "razor", "html", "lua", "vim", "vimdoc" },
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
    },
}
