require "../pin"

module Opal
  class VariablePin < Pin
    enum Type
      Const
      Local
      Class
      Instance

      def self.from_node(node : Crystal::ASTNode)
        case node
        when Crystal::Path
          Const
        when Crystal::Var
          Local
        when Crystal::InstanceVar
          Instance
        when Crystal::ClassVar
          Class
        else
          raise "Unknown variable node type."
        end
      end
    end

    getter type : Type

    def initialize(@name, @node, @location, @type)
    end

    def completion_item_kind
      case @type
      when Const
        CompletionItemKind::Constant
      else
        CompletionItemKind::Variable
      end
    end
  end
end
