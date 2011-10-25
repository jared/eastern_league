require "bundler/capistrano"

load 'deploy/assets'

set :application, "eastern_league"
set :repository,  "git@github.com:jared/eastern_league.git"

set :scm, :git

set :user, "deploy"  # The server's user for deploys

role :web, "50.57.149.168"                          # Your HTTP server, Apache/etc
role :app, "50.57.149.168"                          # This may be the same as your `Web` server
role :db,  "50.57.149.168", :primary => true # This is where Rails migrations will run

default_run_options[:pty] = true

after "deploy:update_code", "deploy:copy_configuration_files"

namespace :deploy do
  task :copy_configuration_files do
    run "cp #{shared_path}/secure/*.rb #{release_path}/config/initializers"
    run "cp #{shared_path}/secure/database.yml #{release_path}/config"
    run "cp #{shared_path}/secure/*.pem #{release_path}/config/paypal"
  end
  
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end