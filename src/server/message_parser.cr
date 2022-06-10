module Opal
  # Copyright (c) 2018, Gusztáv Szikszai
  # All rights reserved.
  # https://github.com/mint-lang/mint/blob/master/src/lsp/message_parser.cr
  module MessageParser
    extend self

    alias Header = Tuple(String, String)

    # Reads the headers from the given IO.
    def self.read_headers(io : IO) : Array(Header)
      headers = [] of Tuple(String, String)

      loop do
        header = read_header(io)
        break if header.nil?
        headers << header
      end

      headers
    end

    # Reads a header from the given IO.
    def self.read_header(io : IO) : Header?
      io.gets.try do |raw|
        parts =
          raw.split(':')

        {parts[0].strip, parts[1].strip} if parts.size == 2
      end
    end

    # Parses a message (header + contents) from a given IO
    # and yields the contents.
    def self.parse(io : IO)
      headers =
        read_headers(io)

      content_length =
        headers
          .find(&.first.==("Content-Length"))
          .try(&.last)

      if content_length
        yield io.read_string(content_length.to_i)
      end
    end
  end
end
