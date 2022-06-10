require "log"
require "./messages"

module Opal
  class MessageHandler
    def handle_message(request : LSP::InitializeRequest)
      LSP::InitializeResponse.new(request.id)
    end

    def handle_message(request : LSP::ShutdownRequest)
      LSP::ShutdownResponse.new(request.id)
    end

    def handle_message(request : LSP::ExitNotification)
      exit 0
    end

    def handle_message(message)
      Log.warn { "unhandled message: #{message}" }
      nil
    end
  end
end
