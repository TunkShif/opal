require "../pin/*"
require "../helper/ast_node"

module Opal::NodeProcessor
  class AssignProcessor < Crystal::Visitor
    getter pins : Array(Pin::Variable)

    def initialize
      @pins = [] of Pin::Variable
    end

    def process(node : Crystal::ASTNode)
      node.accept(self)
      @pins
    end

    def visit(node : Crystal::Assign)
      target = node.target
      name = Helper::ASTNode.get_name(node)
      type = Pin::Variable::Type.from_node(target)
      @pins << Pin::Variable.new(name, target, target.get_location, type)
      false
    end

    def visit(node : Crystal::ASTNode)
      true
    end
  end
end
