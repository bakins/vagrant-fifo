require 'project-fifo'
require "log4r"
require "pp"

module VagrantPlugins
  module Fifo
    module Action
      # This action connects to Fifo, verifies credentials work, and
      # puts the Fifo connection object into the `:fifo_compute` key
      # in the environment.
      class ConnectFifo
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_fifo::action::connect_fifo")
        end

        def call(env)

          fifo_username = env[:machine].provider_config.username
          fifo_password = env[:machine].provider_config.password
          fifo_api_url  = env[:machine].provider_config.api_url

          @logger.info("Connecting to Fifo...")
          env[:fifo_compute] = begin
                                 fifo = ProjectFifo.new(fifo_api_url, fifo_username, fifo_password)
                                 fifo.connect
                                 fifo
                               end
          @app.call(env)
        end
      end
    end
  end
end
