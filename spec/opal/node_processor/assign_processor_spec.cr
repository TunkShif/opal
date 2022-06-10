require "../../spec_helper.cr"

private def to_pins(source)
  node = parse(source)
  Opal::NodeProcessor::AssignProcessor.new.process(node)
end

module Opal::NodeProcessor
  describe AssignProcessor do
  end
end
