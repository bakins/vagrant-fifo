require "log4r"

module VagrantPlugins
  module Fifo
    module Action
      # This terminates the running instance.
      class TerminateInstance
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_fifo::action::run_instance")
        end

        def call(env)
          server = env[:fifo_compute].vms.get(env[:machine].id)

          # Destroy the server and remove the tracking ID
          env[:ui].info(I18n.t("vagrant_fifo.terminating"))

          # Machine must be in a stopped state before it's destroyed.
          #
          # More info here:
          #
          #   https://us-west-1.api.fifocloud.com/docs#DeleteMachine
          #
          env[:fifo_compute].vms.delete(server['uuid'])

          # Wait for server to be completely gone from invetory
          while true do
            ids = env[:fifo_compute].vms.list

            unless ids.include?(env[:machine].id) then
              break
            end
            sleep 5
          end

          env[:machine].id = nil

          @app.call(env)
        end
      end
    end
  end
end
