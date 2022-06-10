require "./requires"

module Opal
  class Source
    getter uri : String
    getter code : String
    getter ast : Crystal::ASTNode

    def initialize(source)
      # @uri = URI.parse(filename)
      # @code = File.read(filename)
      @code = source
      @ast = Crystal::Parser.parse(@code)
    end
  end
end
