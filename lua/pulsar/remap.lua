vim.g.mapleader = " "
vim.keymap.set("n", "<leader>t", vim.cmd.Ex)

local builtin = require('telescope.builtin')
vim.keymap.set('n', ',ff', builtin.find_files, { desc = 'Telescope find files' })
-- global keymap (works for all buffers)
vim.keymap.set("n", ",e", function()
  vim.diagnostic.open_float(nil, { focus = false })
end, { desc = "Show diagnostics in floating window" })

