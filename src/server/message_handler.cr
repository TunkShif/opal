require "log"
require "./context"
require "./message"
require "./handlers/*"

module Opal
  class MessageHandler
    def initialize(@context : Context)
    end

    def handle_message(message)
      Log.warn { "unhandled message: #{message}" }
      yield nil
    end
  end
end
