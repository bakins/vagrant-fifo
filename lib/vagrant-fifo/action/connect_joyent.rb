require "fog"
require "log4r"

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

          fifo_username = env[:machine].provider_config.fifo_username
          fifo_keyname = env[:machine].provider_config.fifo_keyname
          fifo_keyfile = env[:machine].provider_config.fifo_keyfile
          fifo_api_url  = env[:machine].provider_config.fifo_api_url

          @logger.info("Connecting to Fifo...")
          env[:fifo_compute] = Fog::Compute.new({
              :provider => 'Fifo',
              :fifo_username => fifo_username,
              :fifo_keyname => fifo_keyname,
              :fifo_keyfile => fifo_keyfile,
              :fifo_url => fifo_api_url
            })

          @app.call(env)
        end
      end
    end
  end
end
