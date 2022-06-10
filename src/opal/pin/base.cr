require "../base/location"

module Opal::Pin
  enum Visibility
    Public
    Protected
    Private
  end

  class Base
    getter name : String
    getter location : Location?
    getter node : Crystal::ASTNode

    def initialize(@name, @node, @location)
    end

    def completion_item_kind
      CompletionItemKind::KEYWORD
    end
  end
end
