require "../pins/*"
require "../helper/ast_node"

module Opal
  class AssignProcessor < Crystal::Visitor
    getter pins : Array(VariablePin)

    def initialize
      @pins = [] of VariablePin
    end

    def process(node : Crystal::ASTNode)
      node.accept(self)
      @pins
    end

    def visit(node : Crystal::Assign)
      target = node.target
      name = Helper::ASTNode.get_name(node)
      type = VariablePin::Type.from_node(target)
      @pins << VariablePin.new(name, target, target.get_location, type)
      false
    end

    def visit(node : Crystal::ASTNode)
      true
    end
  end
end
