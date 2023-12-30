task :rspec_watch do
  sh "RAILS_ENV=test bundle exec rake rspec_watcher:watch"
end
