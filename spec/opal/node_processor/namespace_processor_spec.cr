require "../../spec_helper.cr"

private def to_pins(source)
  node = parse(source)
  Opal::NodeProcessor::NamespaceProcessor.new.process(node)
end

module Opal::NodeProcessor
  describe NamespaceProcessor do
    it "class" do
      source = %(
	class Foo
	end
      )

      pin = to_pins(source).first

      pin.path.should eq(["Foo"])
      pin.path_name.should eq("Foo")
      pin.type.to_s.should eq("Class")
    end

    it "module" do
      source = %(
	module Foo
	end
      )

      pin = to_pins(source).first

      pin.path.should eq(["Foo"])
      pin.path_name.should eq("Foo")
      pin.type.to_s.should eq("Module")
    end

    it "enum" do
      source = %(
	enum Bar
	end
      )

      pin = to_pins(source).first

      pin.path.should eq(["Bar"])
      pin.path_name.should eq("Bar")
      pin.type.to_s.should eq("Enum")
    end

    it "nested" do
      source = %(
	module Top
	  class Outer
	    class Inner
	    end
	  end
	end
      )

      pins = to_pins(source)

      (pins.map(&.path) - [["Top"], ["Top", "Outer"], ["Top", "Outer", "Inner"]]).empty?.should eq(true)
      (pins.map(&.path_name) - ["Top", "Top::Outer", "Top::Outer::Inner"]).empty?.should eq(true)
      (pins.map(&.type.to_s) - ["Module", "Class", "Class"]).empty?.should eq(true)
    end

    it "complex path" do
      source = %(
	module Top
	  class Outer::Inner
	  end
	end
      )

      pins = to_pins(source)

      (pins.map(&.path) - [["Top"], ["Top", "Outer", "Inner"]]).empty?.should eq(true)
      (pins.map(&.path_name) - ["Top", "Top::Outer::Inner"]).empty?.should eq(true)
      (pins.map(&.type.to_s) - ["Module", "Class"]).empty?.should eq(true)
    end
  end
end
