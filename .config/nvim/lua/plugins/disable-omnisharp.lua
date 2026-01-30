return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                omnisharp = false, -- <- Disable omnisharp
            },
        },
    },
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            ensure_installed = {
                -- DO NOT include "omnisharp"
            },
            automatic_installation = false,
        },
    },
}
