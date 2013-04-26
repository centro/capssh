# Used for testing

set :rails_env, 'production'

role :db, 'db.foobar.net', :primary => true
role :app, 'app1.foobar.net', 'app2.foobar.net'
role :web, 'app1.foobar.net', 'app2.foobar.net'
