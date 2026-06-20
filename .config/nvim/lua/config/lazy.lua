local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
    spec = {
        { "LazyVim/LazyVim", import = "lazyvim.plugins" },
        -- 1. Enable LazyVim's built-in Debugging UI and core framework
        { import = "lazyvim.plugins.extras.dap.core" },
        -- 2. Add the CORRECTED .NET Debugging Extension
        {
            "NicholasMata/nvim-dap-cs",
            dependencies = { "mfussenegger/nvim-dap" },
            config = function()
                require("dap-cs").setup({
                    netcoredbg = {
                        -- Automatically finds netcoredbg if installed via Mason
                        path = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg",
                    },
                })

                -- Override the cs configuration to add a pre-launch build step
                local dap = require("dap")
                local original_configs = dap.configurations.cs or {}
                for _, config in ipairs(original_configs) do
                    local original_program = config.program
                    config.program = function()
                        vim.notify("Building project...", vim.log.levels.INFO)
                        local result = vim.fn.system("dotnet build " .. vim.fn.getcwd())
                        if vim.v.shell_error ~= 0 then
                            vim.notify("Build failed:\n" .. result, vim.log.levels.ERROR)
                            return dap.ABORT
                        end
                        vim.notify("Build succeeded", vim.log.levels.INFO)
                        if type(original_program) == "function" then
                            return original_program()
                        end
                        return original_program
                    end
                end
            end,
        },
        -- LSP Core
        { "neovim/nvim-lspconfig" },
        -- Syntax Highlighting
        { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
        {
            "windwp/nvim-ts-autotag",
            dependencies = { "nvim-treesitter/nvim-treesitter" },
            config = true,
        },
        { import = "plugins" }, -- This will include plugins/razor.lua
    },
    defaults = {
        lazy = false,
        version = false,
    },
    install = { colorscheme = { "tokyonight", "habamax" } },
    checker = { enabled = true, notify = false },
    performance = {
        rtp = {
            disabled_plugins = { "gzip", "tarPlugin", "tohtml", "zipPlugin" },
        },
    },
})
