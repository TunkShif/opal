require "./*"

module Opal::Pin
  class Namespace < Base
    enum Type
      Class
      Module
      Enum
      Toplevel

      def self.from_node(node : Crystal::ASTNode)
        case node
        when Crystal::ClassDef
          Class
        when Crystal::ModuleDef
          Module
        when Crystal::EnumDef
          Enum
        else
          raise "Unreachable"
        end
      end
    end

    getter type : Type
    getter path : Array(String)
    getter path_name : String
    # getter variables : Array(Pin::Variable)
    # getter methods : Array(Pin::Method)
    # getter included : Array(Pin::Namespace)
    # getter extended : Array(Pin::Namespace)
    getter visibility : Pin::Visibility

    def initialize(@name, @node, @location, @type, @path, @visibility = Pin::Visibility::Public)
      @path_name = @path.join("::")
    end

    def completion_item_kind
      case @type
      when Type::Class
        CompletionItemKind::Class
      when Type::Module
        CompletionItemKind::Module
      when Type::Enum
        CompletionItemKind::Enum
      end
    end
  end
end
