require "lsp"

module LSP
  class DidOpenTextDocumentNotification < NotificationMessage(DidOpenTextDocumentParams)
    @method = "textDocument/didOpen"
  end

  class DidSaveTextDocumentNotification < NotificationMessage(DidSaveTextDocumentParams)
    @method = "textDocument/didSave"
  end
end
