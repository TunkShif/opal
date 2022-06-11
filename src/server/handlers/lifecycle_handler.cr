require "../message_handler"

module Opal
  class MessageHandler
    def handle_message(message : LSP::InitializeRequest)
      yield LSP::InitializeResponse.new(message.id)
    end

    def handle_message(message : LSP::InitializedNotification)
      yield nil
    end

    def handle_message(message : LSP::ShutdownRequest)
      @context.shutdown = true
      yield LSP::ShutdownResponse.new(message.id)
    end

    def handle_message(message : LSP::ExitNotification)
      exit 0
    end
  end
end
