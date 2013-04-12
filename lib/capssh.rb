require 'rubygems'
require 'capistrano'

module Capssh
  class << self

    def execute(options={})
      environment = options[:environment]
      role = options[:role]

      config = Capistrano::Configuration.new
      config.load(:file => "./config/deploy.rb")

      if environment
        config_file = "./config/deploy/#{environment}.rb"
        display_error_and_exit("No stage file exists for '#{environment}'") unless File.exist?(config_file)
        config.load(:file => config_file)
      end

      if config.find_servers.empty?
        display_error_and_exit("Please speicfy a valid environment: #{valid_environments.join(", ")}")
      end

      servers = config.find_servers(:roles => role)
      display_error_and_exit("no servers could be found for environment '#{environment}' and role '#{role}'") if servers.empty?

      user = config[:user] || ENV['USER']
      server = servers.first
      puts "Connecting to #{environment} #{role} at #{user}@#{server}..."
      exec "ssh #{user}@#{server}"
    end

    def display_error_and_exit(error)
      puts "ERROR: #{error}"
      exit(1)
    end

    def valid_environments
      Dir.entries("./config/deploy").select { |f| f =~ /.rb$/ }.map { |f| f.sub(".rb", "") }
    end

  end
end
