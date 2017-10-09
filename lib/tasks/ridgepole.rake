namespace :ridgepole do
  desc 'dry-run database schema'
  task dry_run: :environment do
    ridgepole('--apply', "--dry-run", "--file #{schema_file}")
  end

  desc 'Apply database schema'
  task apply: :environment do
    ridgepole('--apply', "--file #{schema_file}")
    Rake::Task['db:schema:dump'].invoke
  end

  desc 'Export database schema'
  task export: :environment do
    ridgepole('--export', "--output #{schema_file}")
  end

  private

  def schema_file
    Rails.root.join('db/Schemafile')
  end

  def config_file
    Rails.root.join('config/database.yml')
  end

  def rails_env
    ENV['RAILS_ENV'] || 'development'
  end

  def ridgepole(*options)
    command = ['bundle exec ridgepole', "--env #{rails_env}", "--config #{config_file}"]
    system [command + options].join(' ')
  end
end
