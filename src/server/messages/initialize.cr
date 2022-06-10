require "lsp"
require "json"

module LSP
  class InitializeRequest < RequestMessage(InitializeParams)
    @method = "initialize"
  end

  class InitializeResponse < ResponseMessage(InitializeResult)
    def initialize(@id)
      server_info = {name: "Opal", version: "dev"}

      workspace = ServerCapabilities::Workspace.new(
        workspace_folders: WorkspaceFoldersServerCapabilities.new,
      )
      diagnostic_options = DiagnosticOptions.new(true, false)

      capabilities = ServerCapabilities.new(
        workspace: workspace,
        diagnostic_provider: diagnostic_options
      )
      @result = InitializeResult.new(capabilities, server_info)
    end
  end

  class InitializedNotification < NotificationMessage(JSON::Any)
    @method = "initialized"
  end
end
