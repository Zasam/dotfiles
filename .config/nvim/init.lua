-- =========================
-- INITIAL NVIM SETUP
-- =========================
vim.g.mapleader = " "

-- Basic editor options
local opt = vim.opt
opt.number = true
opt.cursorline = true
opt.scrolloff = 10
opt.list = true
opt.confirm = true
opt.ignorecase = true
opt.smartcase = true

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = vim.highlight.on_yank,
})

-- Terminal navigation keymaps
local modes = { "n", "t", "i" }
for _, m in ipairs(modes) do
    vim.keymap.set(m, "<A-h>", "<C-\\><C-n><C-w>h")
    vim.keymap.set(m, "<A-j>", "<C-\\><C-n><C-w>j")
    vim.keymap.set(m, "<A-k>", "<C-\\><C-n><C-w>k")
    vim.keymap.set(m, "<A-l>", "<C-\\><C-n><C-w>l")
end
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
vim.keymap.set("v", "<leader>c", function()
    -- add <!-- above selection
    vim.cmd('\'<-1put ="<!--"')
    -- add --> below selection
    vim.cmd('\'>put ="-->"')
end, { desc = "Wrap selection in HTML comment block" })

-- Git blame for current line
vim.api.nvim_create_user_command("GitBlameLine", function()
    local line_number = vim.fn.line(".")
    local filename = vim.api.nvim_buf_get_name(0)
    print(vim.fn.system({
        "git",
        "blame",
        "-L",
        line_number .. ",+1",
        filename,
    }))
end, { desc = "Print git blame for current line" })

vim.filetype.add({
    extension = {
        cs = "cs",
        razor = "razor",
        cshtml = "razor",
    },
})

vim.opt.updatetime = 300

require("config.lazy")
