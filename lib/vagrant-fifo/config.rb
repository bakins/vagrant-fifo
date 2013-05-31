#: utf-8 -*-
require "vagrant"

module VagrantPlugins
  module Fifo
    class Config < Vagrant.plugin("2", :config)
      attr_accessor :fifo_username
      attr_accessor :fifo_keyname
      attr_accessor :fifo_keyfile
      attr_accessor :fifo_api_url
      attr_accessor :dataset
      attr_accessor :flavor
      attr_accessor :node_name
      attr_accessor :ssh_username
      attr_accessor :ssh_private_key_path

      def initialize(datacenter_specific=false)
        @fifo_username    = UNSET_VALUE
        @fifo_keyname    = UNSET_VALUE
        @fifo_keyfile    = UNSET_VALUE
        @fifo_api_url     = UNSET_VALUE
        @dataset            = UNSET_VALUE
        @flavor             = UNSET_VALUE
        @node_name          = UNSET_VALUE
        @ssh_username       = UNSET_VALUE
        @ssh_private_key_path = UNSET_VALUE
      end

      #-------------------------------------------------------------------
      # Internal methods.
      #-------------------------------------------------------------------

      def finalize!
        # API
        @fifo_username = nil if @fifo_username == UNSET_VALUE
        @fifo_keyname = nil if @fifo_keyname == UNSET_VALUE
        @fifo_keyfile = nil if @fifo_keyfile == UNSET_VALUE
        @fifo_api_url  = nil if @fifo_api_url  == UNSET_VALUE

        # Machines
        @dataset = nil if @dataset == UNSET_VALUE
        @flavor = "Small 1GB" if @instance_type == UNSET_VALUE
        @node_name = nil if @node_name == UNSET_VALUE
        @ssh_username = nil if @ssh_username == UNSET_VALUE
        @ssh_private_key_path = nil if @ssh_private_key_path == UNSET_VALUE

      end

      def validate(machine)
        config = self.class.new(true)

        errors = []
        errors << I18n.t("vagrant_fifo.config.fifo_username_required") if config.fifo_username.nil?
        errors << I18n.t("vagrant_fifo.config.fifo_keyname_required") if config.fifo_keyname.nil?
        errors << I18n.t("vagrant_fifo.config.fifo_keyfile_required") if config.fifo_keyfile.nil?
        errors << I18n.t("vagrant_fifo.config.fifo_api_url_required") if config.fifo_api_url.nil?
        errors << I18n.t("vagrant_fifo.config.dataset_required") if config.dataset.nil?
        errors << I18n.t("vagrant_fifo.config.flavor_required") if config.flavor.nil?
        errors << I18n.t("vagrant_fifo.config.ssh_username_required") if config.ssh_username.nil?
        errors << I18n.t("vagrant_fifo.config.ssh_private_key_path_required") if config.ssh_private_key_path.nil?
        { "Fifo Provider" => errors }
      end
    end
  end
end
