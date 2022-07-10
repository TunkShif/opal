require "../pins/*"

module Opal
  class MethodProcessor < Crystal::Visitor
    getter namespace : NamespacePin
    getter pins : Array(MethodPin)

    def process(node : Crystal::ASTNode)
      node.accept self
      @pins
    end

    def initialize(@namespace)
      @pins = [] of MethodPin
    end

    private def get_type(node : Crystal::Def)
      type = case @namespace.type
             in NamespacePin::Type::Class, NamespacePin::Type::Module, NamespacePin::Type::Enum
               MethodPin::Type::Instance
             in NamespacePin::Type::Toplevel
               MethodPin::Type::Toplevel
             end
      type = MethodPin::Type::Class if node.receiver
      # TODO: check for constructor methods
      type
    end

    def visit(node : Crystal::Def)
      type = get_type(node)
      params = [] of Pin::Variable # TODO: get method params
      # TODO: toplevel namespace edge case
      # ```
      # def Foo.bar
      # end
      # ```
      @pins << MethodPin.new(node.name, node, node.get_location, type, params, @namespace)
      false
    end

    def visit(node : Crystal::Expressions)
      node.expressions.select(Crystal::Def).each(&.accept self)
      false
    end

    def visit(node : Crystal::ClassDef | Crystal::ModuleDef)
      node.body.accept self
      false
    end

    def visit(node : Crystal::EnumDef)
      node.members.select(Crystal::Def).each(&.accept self)
    end

    def visit(node : Crystal::ASTNode)
      false
    end
  end
end
