require "../message_handler"
require "../../opal/diagnostic_analyzer"

module Opal
  class MessageHandler
    def handle_message(message : LSP::DidOpenTextDocumentNotification)
      uri = message.params.text_document.uri
      DiagnosticAnalyzer.analyze(uri).each do |uri, diagnostics|
        yield LSP::PublishDiagnosticsNotification.new(uri, diagnostics)
      end
    end

    def handle_message(message : LSP::DidSaveTextDocumentNotification)
      uri = message.params.text_document.uri
      DiagnosticAnalyzer.analyze(uri).each do |uri, diagnostics|
        yield LSP::PublishDiagnosticsNotification.new(uri, diagnostics)
      end
    end
  end
end
