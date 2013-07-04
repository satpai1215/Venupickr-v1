require 'heroku-api'
  desc "Scale UP dynos"
   task :spin_up => :environment do
     heroku = Heroku::API.new(:api_key => '78d788c1-7770-4de3-91d6-e856e812548f')
     heroku.post_ps_scale(ENV['APP_NAME'], 'worker', 1)
   end

  desc "Scale DOWN dynos"
   task :spin_down => :environment do
     heroku = Heroku::API.new(:api_key => '78d788c1-7770-4de3-91d6-e856e812548f')
     heroku.post_ps_scale(ENV['APP_NAME'], 'worker', 0)
   end

  desc "Execute past jobs in DJ queue"
   task :work_off_queue => :environment do
    worker = Delayed::Worker.new
    results = worker.work_off
  end