return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                omnisharp = false,
            },
        },
    },
    {
        "mason-org/mason.nvim",
        opts = {
            registries = {
                "github:mason-org/mason-registry",
                "github:Crashdummyy/mason-registry",
            },
        },
    },
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            ensure_installed = {},
            automatic_installation = false,
        },
    },
}
