# Used for testing

set :application, 'dummy'

set :deploy_to, '/some/deployment/directory'
set :user, 'bobby'

set :stages, %w(production staging)
set :default_stage, 'staging'
require 'capistrano/ext/multistage'

