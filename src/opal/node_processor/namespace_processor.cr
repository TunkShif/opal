require "../pin/*"
require "../helper/ast_node"

module Opal::NodeProcessor
  class NamespaceProcessor < Crystal::Visitor
    getter pins : Array(Pin::Namespace)

    def initialize
      @current = [] of Crystal::Path
      @pins = [] of Pin::Namespace
    end

    def process(node : Crystal::ASTNode)
      node.accept(self)
      @pins
    end

    def visit(node : Crystal::ClassDef | Crystal::ModuleDef | Crystal::EnumDef)
      # TODO: visibility
      @current << node.name
      path = @current.map(&.names).flatten
      unless @pins.map(&.path_name).includes?(path.join("::"))
        name = Helper::ASTNode.get_name(node)
        type = Pin::Namespace::Type.from_node(node)
        @pins << Pin::Namespace.new(name, node, node.get_location, type, path)
      end
      true
    end

    def visit(node : Crystal::ASTNode)
      true
    end

    def end_visit(node : Crystal::ClassDef | Crystal::ModuleDef | Crystal::EnumDef)
      @current.pop
    end
  end
end
