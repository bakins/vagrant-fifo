#: utf-8 -*-
require "vagrant"

module VagrantPlugins
  module Fifo
    class Config < Vagrant.plugin("2", :config)
      attr_accessor :username
      attr_accessor :password
      attr_accessor :api_url
      attr_accessor :dataset
      attr_accessor :package
      attr_accessor :iprange
      attr_accessor :node_name
      attr_accessor :ssh_username

      def initialize(datacenter_specific=false)
        @username    = UNSET_VALUE
        @password    = UNSET_VALUE
        @api_url     = UNSET_VALUE
        @dataset            = UNSET_VALUE
        @package            = UNSET_VALUE
        @iprange            = UNSET_VALUE
        @node_name          = UNSET_VALUE
        @ssh_username       = UNSET_VALUE
      end

      #-------------------------------------------------------------------
      # Internal methods.
      #-------------------------------------------------------------------

      def finalize!
        # API
        @username = nil if @username == UNSET_VALUE
        @password = nil if @password == UNSET_VALUE
        @api_url  = nil if @api_url  == UNSET_VALUE

        # Machines
        @dataset = nil if @dataset == UNSET_VALUE
        @package = "medium" if @package == UNSET_VALUE
        @iprange = "default" if @iprange == UNSET_VALUE
        @node_name = nil if @node_name == UNSET_VALUE
        @ssh_username = "root" if @ssh_username == UNSET_VALUE

      end

      def validate(machine)
        config = self.class.new(true)

        errors = []
        errors << I18n.t("vagrant_fifo.config.username_required") if config.username.nil?
        errors << I18n.t("vagrant_fifo.config.password_required") if config.password.nil?
        errors << I18n.t("vagrant_fifo.config.api_url_required") if config.api_url.nil?
        errors << I18n.t("vagrant_fifo.config.dataset_required") if config.dataset.nil?
        errors << I18n.t("vagrant_fifo.config.package_required") if config.package.nil?
        errors << I18n.t("vagrant_fifo.config.iprange_required") if config.iprange.nil?
        errors << I18n.t("vagrant_fifo.config.ssh_username_required") if config.ssh_username.nil?
        { "Fifo Provider" => errors }
      end
    end
  end
end
