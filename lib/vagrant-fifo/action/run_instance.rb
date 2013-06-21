require "log4r"
require 'vagrant/util/retryable'
require 'vagrant-fifo/util/timer'

module VagrantPlugins
  module Fifo
    module Action

      # This runs the configured instance.
      class RunInstance
        include Vagrant::Util::Retryable

        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_fifo::action::run_instance")
        end

        def wait_for_server(connection, server)
          id = server["uuid"]
          while true do
            s = connection.vms.get(id)
            break if s['state'] == "running"
            print "."
            sleep 10
          end
          sleep 10
        end

        def call(env)
          # Initialize metrics if they haven't been
          env[:metrics] ||= {}

          # Get the configs
          dataset = env[:machine].provider_config.dataset
          package = env[:machine].provider_config.package
          iprange = env[:machine].provider_config.iprange
          node_name = env[:machine].provider_config.node_name || env[:machine].name

          # Launch!
          env[:ui].info(I18n.t("vagrant_fifo.launching_instance"))
          env[:ui].info(" -- Package: #{package}")
          env[:ui].info(" -- Dataset: #{dataset}")
          env[:ui].info(" -- IPrange: #{iprange}")
          env[:ui].info(" -- Node name: #{node_name}")

          options = {
            dataset: env[:fifo_compute].datasets.get_by_name(dataset).last['dataset'],
            package: env[:fifo_compute].packages.get_by_name(package).first['uuid'],
            config: {
              alias: node_name,
              resolvers: [ "8.8.8.8" ],
              ssh_keys: env[:fifo_compute].ssh_keys,
              networks: {
                net0: env[:fifo_compute].ipranges.get_by_name(iprange).first['uuid']
              }
            }
          }

          server = env[:fifo_compute].vms.create(options)

          # Immediately save the ID since it is created at this point.
          env[:machine].id = server["uuid"]

          wait_for_server(env[:fifo_compute], server)

          if !env[:interrupted]
            env[:metrics]["instance_ssh_time"] = Util::Timer.time do
              # Wait for SSH to be ready.
              env[:ui].info(I18n.t("vagrant_fifo.waiting_for_ssh"))
              while true
                # If we're interrupted then just back
                # out
                break if env[:interrupted]
                break if env[:machine].communicate.ready?
                puts "sleeping"
                sleep 2
              end
            end

            @logger.info("Time for SSH ready: #{env[:metrics]["instance_ssh_time"]}")

            # Ready and booted!
            env[:ui].info(I18n.t("vagrant_fifo.ready"))
          end

          # Terminate the instance if we were interrupted
          terminate(env) if env[:interrupted]

          @app.call(env)
        end

        def recover(env)
          return if env["vagrant.error"].is_a?(Vagrant::Errors::VagrantError)

          if env[:machine].provider.state.id != :not_created
            # Undo the import
            terminate(env)
          end
        end

        def terminate(env)
          destroy_env = env.dup
          destroy_env.delete(:interrupted)
          destroy_env[:config_validate] = false
          destroy_env[:force_confirm_destroy] = true
          env[:action_runner].run(Action.action_destroy, destroy_env)
        end
      end
    end
  end
end


