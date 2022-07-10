require "lsp"
require "./requires"

module Opal
  enum Visibility
    Public
    Protected
    Private
  end

  class Pin
    getter name : String
    getter location : LSP::Location?
    getter node : Crystal::ASTNode

    def initialize(@name, @node, @location)
    end

    def completion_item_kind
      CompletionItemKind::Keyword
    end
  end
end
