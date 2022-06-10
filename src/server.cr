require "log"
require "json"
require "./server/*"

module Opal
  class Server
    def initialize(@in : IO = STDIN, @out : IO = STDOUT)
      @handler = MessageHandler.new
    end

    def self.run
      server = self.new
      loop do
        server.read
      end
    end

    private def prepend_header(content : String)
      "Content-Length: #{content.bytesize}\r\n\r\n#{content}"
    end

    def send(response : LSP::ResponseMessage | LSP::NotificationMessage)
      @out << prepend_header(response.to_json)
      @out.flush
    end

    def read
      return exit(1) if @in.closed?

      MessageParser.parse(@in) do |contents|
        Log.debug { "received raw content: #{contents}" }

        json = JSON.parse(contents)

        if json["id"]?
          message = LSP::RequestMessage.from_json(contents)
        else
          message = LSP::NotificationMessage.from_json(contents)
        end

        Log.debug { "parsed message: #{message}" }

        if response = @handler.handle_message(message)
          Log.debug { "response to reply: #{response.to_json}" }

          send(response)
        end
      end
    rescue error
      Log.error { error }
      error.backtrace?.try(&.each { |item| Log.error { item } })
    end
  end
end
