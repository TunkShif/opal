require "../spec_helper"
require "../../src/opal/ext"

module Opal
  describe Crystal::ASTNode do
    it "node#get_location" do
      source = [%(foo = "bar"), %(bar = "baz")].join "\n"

      root = parse(source).as(Crystal::Expressions)
      first = root.expressions[0]
      second = root.expressions[1]

      root.get_location.to_s.should eq("0:0-1:10")
      first.get_location.to_s.should eq("0:0-0:10")
      second.get_location.to_s.should eq("1:0-1:10")
    end
  end
end
