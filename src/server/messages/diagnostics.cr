require "lsp"

module LSP
  class PublishDiagnosticsNotification < NotificationMessage(PublishDiagnosticsParams)
    @method = "textDocument/publishDiagnostics"

    def initialize(uri : String, diagnostics : Array(Diagnostic))
      @params = PublishDiagnosticsParams.new(uri: uri, diagnostics: diagnostics)
    end
  end
end
