# Used for testing

set :rails_env, 'production'

master = 'foobar.net'

role :db, 'db.foobar.net', :primary => true
role :app, master
role :web, master
