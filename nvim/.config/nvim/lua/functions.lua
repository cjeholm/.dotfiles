-- Function to show connected LSP clients for the current buffer
function ShowLSPs()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })

  if vim.tbl_isempty(clients) then
    print("No LSP clients attached to this buffer.")
    return
  end

  print("Connected LSPs:")
  for _, client in ipairs(clients) do
    print(" - " .. client.name)
  end
end
