require "spec"
require "../src/opal/requires"
require "../src/opal/ext"
require "../src/opal/node_processors/*"

def parse(source : String)
  Crystal::Parser.parse(source)
end
