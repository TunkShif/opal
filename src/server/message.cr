require "lsp"
require "json"
require "./messages/*"

module LSP
  abstract class RequestMessage
    use_json_discriminator "method", {
      "initialize" => InitializeRequest,
      "shutdown"   => ShutdownRequest,
    }
  end

  abstract class NotificationMessage
    use_json_discriminator "method", {
      "initialized"          => InitializedNotification,
      "exit"                 => ExitNotification,
      "textDocument/didOpen" => DidOpenTextDocumentNotification,
      "textDocument/didSave" => DidSaveTextDocumentNotification,
    }
  end
end
