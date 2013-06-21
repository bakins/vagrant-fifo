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

        def is_linklocal(ip)
          linklocal = IPAddr.new "169.254.0.0/16"
          return linklocal.include?(ip)
        end
        
        def is_loopback(ip)
          loopback = IPAddr.new "127.0.0.0/8"
          return loopback.include?(ip)
        end

        def is_private(ip)
          block_a = IPAddr.new "10.0.0.0/8"
          block_b = IPAddr.new "172.16.0.0/12"
          block_c = IPAddr.new "192.168.0.0/16"
          return (block_a.include?(ip) or block_b.include?(ip) or block_c.include?(ip))
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
          info =  {
            :host => bootstrap_ip_address,
            :port => 22,
            :username => config.ssh_username
          }
          pp info
          info
        end
      end
    end
  end
end
