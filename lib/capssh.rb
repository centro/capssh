module Capssh
  class << self

    def execute(options={})
      config = load_capistrano_configuration(options)
      servers = find_servers(config, options)

      if options[:list_servers]
        log servers.join(', ')
      else
        exec_ssh_command ssh_command(config, servers.first, options)
      end
    end

    private

    def load_capistrano_configuration(options)
      display_error_and_exit("No capistrano config file could be found in ./config/deploy.rb") unless File.exist?("./config/deploy.rb")

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

    def find_servers(config, options)
      servers = config.find_servers(:roles => options[:role])
      if servers.empty?
        display_error_and_exit("No servers could be found for environment '#{options[:environment]}' and role '#{options[:role]}'")
      end
      servers
    end

    def ssh_command(config, server, options)
      user = config[:user] || ENV['USER']

      log "Connecting to #{options[:environment]} #{options[:role]} at #{user}@#{server}..."
      ssh_command = "ssh #{user}@#{server}"

      command = nil
      if options[:console]
        command = "cd #{config[:deploy_to]}/current; if [ -f script/console ]; then bundle exec script/console #{config[:rails_env]}; else bundle exec rails console #{config[:rails_env]}; fi"
      end

      if command
        log "Running command: #{command}"
        ssh_command += " -t \"#{command}\""
      end

      ssh_command
    end

    def exec_ssh_command(cmd)
      exec cmd
    end

    def display_error_and_exit(error)
      display_error(error)
      exit(1)
    end

    def display_error(error)
      log "ERROR: #{error}"
    end

    def log(message)
      puts message
    end

    def valid_environments
      Dir.entries("./config/deploy").select { |f| f =~ /.rb$/ }.map { |f| f.sub(".rb", "") }
    end

  end
end
