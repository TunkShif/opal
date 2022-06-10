require "log"
require "./server"
require "./server/messages"

def main
  log = File.open("/tmp/opal.log", "w")
  Log.setup(:debug, Log::IOBackend.new(log))

  Opal::Server.run
end

main
