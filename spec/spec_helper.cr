require "spec"
require "../src/opal"

def parse(source : String)
  Crystal::Parser.parse(source)
end
