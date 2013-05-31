require "vagrant"

module VagrantPlugins
  module Fifo
    module Errors
      class VagrantFifoError < Vagrant::Errors::VagrantError
        error_namespace("vagrant_fifo.errors")
      end

      class FogError < VagrantFifoError
        error_key(:fog_error)
      end

      class RsyncError < VagrantFifoError
        error_key(:rsync_error)
      end
    end
  end
end
