require "../pins/*"
require "../helper/ast_node"

module Opal
  class NamespaceProcessor < Crystal::Visitor
    getter pins : Array(NamespacePin)

    def initialize
      @current = [] of Crystal::Path
      @pins = [] of NamespacePin
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
        type = NamespacePin::Type.from_node(node)
        @pins << NamespacePin.new(name, node, node.get_location, type, path)
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
