require "../pin"
require "./method_pin"
require "./variable_pin"

module Opal
  class NamespacePin < Pin
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
          raise "Unknown namespace node type."
        end
      end
    end

    getter type : Type
    getter path : Array(String)
    getter path_name : String
    # getter variables : Array(VariablePin)
    # getter methods : Array(MethodPin)
    # getter included : Array(NamespacePin)
    # getter extended : Array(NamespacePin)
    getter visibility : Visibility

    def initialize(@name, @node, @location, @type, @path, @visibility = Visibility::Public)
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
