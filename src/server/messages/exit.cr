require "lsp"

module LSP
  class ExitNotification < NotificationMessage(Nil)
    @method = "exit"
  end
end
