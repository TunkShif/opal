require "log"
require "./server"

module Opal
  def self.start
    log = File.open("/tmp/opal.log", "w")
    Log.setup(:debug, Log::IOBackend.new(log))

    Server.new.run
  end
end

Opal.start
