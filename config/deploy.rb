require "bundler/capistrano"

load 'deploy/assets'

set :application, "eastern_league"
set :repository,  "git@github.com:jared/eastern_league.git"

set :scm, :git

set :user, "deploy"  # The server's user for deploys

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "50.57.149.168"                          # Your HTTP server, Apache/etc
role :app, "50.57.149.168"                          # This may be the same as your `Web` server
role :db,  "50.57.149.168", :primary => true # This is where Rails migrations will run


default_run_options[:pty] = true

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

after "deploy:update_code", "deploy:copy_configuration_files"
after 'deploy:update_code', 'deploy:precompile_those_assets'

namespace :deploy do
  task :copy_configuration_files do
    run "cp #{shared_path}/secure/*.rb #{release_path}/config/initializers"
    run "cp #{shared_path}/secure/database.yml #{release_path}/config"
  end
  
  task :precompile_those_assets do
    run "cd #{release_path}; RAILS_ENV=production rake assets:precompile"
  end
  
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end