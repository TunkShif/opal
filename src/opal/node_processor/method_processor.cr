require "../pin/*"

module Opal::NodeProcessor
  class MethodProcessor < Crystal::Visitor
    getter namespace : Pin::Namespace
    getter pins : Array(Pin::Method)

    def process(node : Crystal::ASTNode)
      node.accept self
      @pins
    end

    def initialize(@namespace)
      @pins = [] of Pin::Method
    end

    private def get_type(node : Crystal::Def)
      type = case @namespace.type
             in Pin::Namespace::Type::Class, Pin::Namespace::Type::Module, Pin::Namespace::Type::Enum
               Pin::Method::Type::Instance
             in Pin::Namespace::Type::Toplevel
               Pin::Method::Type::Toplevel
             end
      type = Pin::Method::Type::Class if node.receiver
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
      @pins << Pin::Method.new(node.name, node, node.get_location, type, params, @namespace)
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
