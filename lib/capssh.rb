module Capssh
  class << self

    def execute(options={})
      config = load_capistrano_configuration(options)
      server = find_server(config, options)
      exec ssh_command(config, server, options)
    end

    private

    def load_capistrano_configuration(options)
      config = Capistrano::Configuration.new
      config.load(:file => "./config/deploy.rb")

      if options[:environment]
        config_file = "./config/deploy/#{options[:environment]}.rb"
        display_error_and_exit("No stage file exists for '#{options[:environment]}'") unless File.exist?(config_file)
        config.load(:file => config_file)
      end

      if config.find_servers.empty?
        display_error_and_exit("Please specify a valid environment: #{valid_environments.join(", ")}")
      end

      config
    end

    def find_server(config, options)
      servers = config.find_servers(:roles => options[:role])
      if servers.empty?
        display_error_and_exit("no servers could be found for environment '#{options[:environment]}' and role '#{options[:role]}'")
      end

      servers.first
    end

    def ssh_command(config, server, options)
      user = config[:user] || ENV['USER']

      puts "Connecting to #{options[:environment]} #{options[:role]} at #{user}@#{server}..."
      ssh_command = "ssh #{user}@#{server}"

      command = nil
      if options[:console]
        command = "cd #{config[:deploy_to]}/current; bundle exec rails console #{config[:rails_env]}"
      end

      if command
        puts "Running command: #{command}"
        ssh_command += " -t \"#{command}\""
      end

      ssh_command
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
