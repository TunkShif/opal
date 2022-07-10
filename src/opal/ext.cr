require "lsp"

class Crystal::ASTNode
  def get_location : LSP::Location?
    start = location
    ending = end_location
    # TODO: use real source file uri
    uri = ""
    if start && ending
      start_position = LSP::Position.new((start.line_number - 1).to_u, (start.column_number - 1).to_u)
      end_position = LSP::Position.new((ending.line_number - 1).to_u, (ending.column_number - 1).to_u)
      range = LSP::Range.new(start_position, end_position)
      return LSP::Location.new(uri, range)
    end
  end
end
