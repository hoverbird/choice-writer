namespace :db do
  desc "Load fixtures from /spec"
  task :load_spec_fixtures => :environment do
    `FIXTURES_PATH='spec/fixtures' RAILS_ENV=development be rake db:fixtures:load`
  end
end
