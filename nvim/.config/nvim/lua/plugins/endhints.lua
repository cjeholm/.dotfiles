-- Display LSP inlay hints at the end of the line, rather than within the line.
return {
  "chrisgrieser/nvim-lsp-endhints",
  event = "LspAttach",
  opts = {}, -- required, even if empty
}
