# Used for testing

set :rails_env, 'staging'

master = 'staging.foobar.net'

role :db, master, :primary => true
role :app, master
role :web, master
