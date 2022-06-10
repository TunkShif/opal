require "./source"
require "./pin/*"

module Opal
  class SourceMap
    getter source : Source
    getter pins : Array(Pin::Base)
    getter requries : Array(SourceMap)

    def initialize(@source, @pins = [] of Pin::Base)
    end
  end
end
