web: bundle exec puma -p $PORT
worker: bundle exec sidekiq -c 2
release: rake db:migrate
