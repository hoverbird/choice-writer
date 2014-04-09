namespace :db do
  desc "Load fixtures from /spec"
  task :load_spec_fixtures => :environment do
    `FIXTURES_PATH='spec/fixtures' RAILS_ENV=development rake db:fixtures:load`
  end


    # lib/tasks/kill_postgres_connections.rake
  task :kill_postgres_connections => :environment do
    db_name = "#{File.basename(Rails.root)}_#{Rails.env}"
    sh =
<<EOF
    ps xa \
      | grep postgres: \
      | grep #{db_name} \
      | grep -v grep \
      | awk '{print $1}' \
      | xargs kill
EOF
      puts `#{sh}`
  end

  task "drop" => :kill_postgres_connections
end
