require "log"
require "json"
require "./server/*"

module Opal
  class Server
    def initialize(@in : IO = STDIN, @out : IO = STDOUT)
      @context = Context.new
      @handler = MessageHandler.new(@context)
    end

    def run
      loop do
        return exit(0) if @context.shutdown
        return exit(1) if @in.closed?

        message = read()

        @handler.handle_message(message) do |response|
          response && send(response)
        end
      end
    end

    private def prepend_header(content : String)
      "Content-Length: #{content.bytesize}\r\n\r\n#{content}"
    end

    def send(response : LSP::ResponseMessage | LSP::NotificationMessage)
      @out << prepend_header(response.to_json)
      @out.flush
      Log.debug { "sent: #{response.to_json}" }
    end

    def read
      MessageParser.parse(@in) do |contents|
        Log.debug { "received raw content: #{contents}" }

        json = JSON.parse(contents)

        if json["id"]?
          message = LSP::RequestMessage.from_json(contents)
        else
          message = LSP::NotificationMessage.from_json(contents)
        end

        Log.debug { "parsed message: #{message}" }

        message
      end
    rescue error
      Log.error { error }
      error.backtrace?.try(&.each { |item| Log.error { item } })
    end
  end
end
