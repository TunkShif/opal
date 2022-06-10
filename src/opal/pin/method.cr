require "./*"

module Opal::Pin
  class Method < Pin::Base
    enum Type
      Class
      Instance
      Constructor
      Toplevel
    end

    getter type : Type
    getter params : Array(Pin::Variable)
    # getter variables : Array(Pin::Variable)
    getter namespace : Pin::Namespace

    def initialize(@name, @node, @location, @type, @params, @namespace)
    end
  end
end
