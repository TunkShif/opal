require "lsp"
require "uri"
require "json"

module Opal
  module DiagnosticAnalyzer
    private def self.run_cmd(cmd, args)
      stdout = IO::Memory.new
      stderr = IO::Memory.new
      status = Process.run(cmd, args: args, output: stdout, error: stderr)
      if status.success?
        {status.exit_code, stdout.to_s}
      else
        {status.exit_code, stderr.to_s}
      end
    end

    def self.analyze(uri : String)
      file = URI.parse(uri).to_s.sub(/^file:\/\//, "")
      status, output = run_cmd("crystal", ["build", file, "-fjson", "--no-codegen"])

      return {uri => [] of LSP::Diagnostic} if status == 0

      diagnostics = {} of String => Array(LSP::Diagnostic)

      JSON.parse(output).as_a
        .map { |it| to_diagnostic(it) }
        .each do |item|
          uri, diagnostic = item
          diagnostics[uri] ||= [] of LSP::Diagnostic
          diagnostics[uri] << diagnostic
        end

      diagnostics
    end

    def self.to_diagnostic(json : JSON::Any)
      uri = "file://#{json["file"].as_s}"
      line = json["line"].as_i.to_u32 - 1
      start = json["column"].as_i.to_u32 - 1
      ending = start + json["size"].as_i.to_u32
      range = LSP::Range.new(line, start, line, ending)
      message = json["message"].as_s

      {uri, LSP::Diagnostic.new(range, message, source: "crystal")}
    end
  end
end
