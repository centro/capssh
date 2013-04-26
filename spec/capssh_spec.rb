require 'spec_helper'

describe Capssh do

  before do
    Capssh.stub(:log)
  end

  describe "connecting to the proper server" do
    it "should be able to ssh into a box configured for the staging environment" do
      Capssh.should_receive(:exec_ssh_command).with('ssh bobby@staging.foobar.net')
      Capssh.execute(:role => :app, :environment => 'staging')
    end

    it "should be able to ssh into a box configured for the production environment" do
      Capssh.should_receive(:exec_ssh_command).with('ssh bobby@app1.foobar.net')
      Capssh.execute(:role => :app, :environment => 'production')
    end

    it "should be able to ssh into the database server configured for the production environment" do
      Capssh.should_receive(:exec_ssh_command).with('ssh bobby@db.foobar.net')
      Capssh.execute(:role => :db, :environment => 'production')
    end
  end

  describe "listing servers" do
    it "should be able to list the servers for a specific environment" do
      Capssh.should_receive(:log).with("app1.foobar.net, app2.foobar.net")
      Capssh.execute(:role => :app, :environment => 'production', :list_servers => true)
    end

    it "should be able to list the servers for a specific environment and role" do
      Capssh.should_receive(:log).with("db.foobar.net")
      Capssh.execute(:role => :db, :environment => 'production', :list_servers => true)
    end
  end

  describe "input validation" do
    it "should raise an error if no environment was specified" do
      Capssh.should_receive(:display_error).with("Please specify a valid environment: production, staging")
      expect { Capssh.execute(:role => :app) }.to raise_error(SystemExit)
    end

    it "should raise an error and exit if no config file could be found for the specified environment" do
      Capssh.should_receive(:display_error).with("No stage file exists for 'test'")
      expect { Capssh.execute(:role => :app, :environment => 'test') }.to raise_error(SystemExit)
    end

    it "should raise an error if no servers could be found with the specified role" do
      Capssh.should_receive(:display_error).with("No servers could be found for environment 'production' and role 'slacker'")
      expect { Capssh.execute(:role => :slacker, :environment => 'production') }.to raise_error(SystemExit)
    end
  end

  it "should be able to start the Rails console" do
    Capssh.should_receive(:exec_ssh_command).with('ssh bobby@staging.foobar.net -t "cd /some/deployment/directory/current; if [ -f script/console ]; then bundle exec script/console staging; else bundle exec rails console staging; fi"')
    Capssh.execute(:role => :app, :environment => 'staging', :console => true)
  end

end
