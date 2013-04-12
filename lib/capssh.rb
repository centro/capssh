require 'rubygems'
require 'capistrano'

class Capssh

  def self.execute(environment, role=nil)
    if environment.nil? || environment.empty?
      display_error_and_exit("environment must be specified", true)
    end

    if environment =~ /help/
      display_usage
      exit
    end

    config_file = "./config/deploy/#{environment}.rb"
    display_error_and_exit("No stage file exists for '#{environment}'") unless File.exist?(config_file)

    config = Capistrano::Configuration.new
    config.load(:file => "./config/deploy.rb")
    config.load(:file => config_file)

    role = role.nil? ? :app : role.to_sym
    servers = config.find_servers(:roles => role)
    display_error_and_exit("no servers could be found for environment '#{environment}' and role ':#{role}'") if servers.empty?

    user = config[:user] || ENV['USER']
    server = servers.first
    puts "Connecting to #{environment} #{role} at #{user}@#{server}..."
    exec "ssh #{user}@#{server}"
  end

  def self.display_error_and_exit(error, should_display_usage=false)
    puts "ERROR: #{error}"
    display_usage if should_display_usage
    exit(1)
  end

  def self.display_usage
    puts "Usage: capssh <environment> [role]"
  end

end
