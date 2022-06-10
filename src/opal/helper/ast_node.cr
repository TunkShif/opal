module Opal::Helper
  module ASTNode
    def self.get_name(node : Crystal::ClassDef | Crystal::ModuleDef | Crystal::EnumDef)
      node.name.names.last
    end

    def self.get_name(node : Crystal::Path)
      node.names.last
    end

    def self.get_name(node : Crystal::Var | Crystal::ClassVar | Crystal::InstanceVar)
      node.name
    end

    def self.get_name(node : Crystal::Assign)
      get_name(node.target)
    end

    def self.get_name(node : Crystal::ASTNode)
      ""
    end
  end
end
