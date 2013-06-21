require "log4r"
require 'ipaddr'

module VagrantPlugins
  module Fifo
    module Action
      # This action reads the SSH info for the machine and puts it into the
      # `:machine_ssh_info` key in the environment.
      class ReadSSHInfo
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_fifo::action::read_ssh_info")
        end

        def call(env)
          env[:machine_ssh_info] = read_ssh_info(env[:fifo_compute], env[:machine])

          @app.call(env)
        end

        def read_ssh_info(fifo, machine)
          return nil if machine.id.nil?

          # Find the machine
          server = fifo.vms.get(machine.id)
          if server.nil?
            # The machine can't be found
            @logger.info("Machine couldn't be found, assuming it got destroyed.")
            machine.id = nil
            return nil
          end
          
          # IP address to bootstrap
          bootstrap_ip_address = server['config']['networks'].first['ip']

          config = machine.provider_config

          
          # Read the DNS info
          return {
            :host => bootstrap_ip_address,
            :port => 22,
            :username => config.ssh_username,
            :private_key_path => config.ssh_private_key_path
          }
        end
      end
    end
  end
end
