local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set(
  "n", 
  "<C-h>", 
  function()
    vim.cmd.RustLsp('externalDocs') 
  end,
  { silent = true, buffer = bufnr }
)

vim.keymap.set(
  "n", 
  "<C-d>", 
  function()
    vim.lsp.buf.definition()
  end,
  { buffer = bufnr }
)

vim.keymap.set(
  "n", 
  "r", 
  function()
    vim.lsp.buf.references()
  end,
  { buffer = bufnr }
)
