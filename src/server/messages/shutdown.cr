require "lsp"

module LSP
  class ShutdownRequest < RequestMessage(Nil)
    @method = "shutdown"
  end

  class ShutdownResponse < ResponseMessage(Nil)
  end
end
