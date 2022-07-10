require "../pin"
require "./variable_pin"
require "./namespace_pin"

module Opal
  class MethodPin < Pin
    enum Type
      Class
      Instance
      Constructor
      Toplevel
    end

    getter type : Type
    getter params : Array(VariablePin)
    # getter variables : Array(VariablePin)
    getter namespace : NamespacePin

    def initialize(@name, @node, @location, @type, @params, @namespace)
    end
  end
end
