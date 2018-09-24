module Pushkin
  class SetupGenerator < Rails::Generators::Base

    include ::Rails::Generators::Migration
    include ::Rails::Generators::Migration

    source_root File.expand_path('templates', __dir__)

    def self.next_migration_number(dir)
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end

    def setup_application
      file_name = "tokens_controller.rb"
      copy_file file_name, "app/controllers/pushkin/api/v1/#{file_name}"
      migration_template "create_pushkin_tables.rb", "db/migrate/create_pushkin_tables.rb"

      route "namespace :pushkin do\n" +
            "    namespace :api do\n" +
            "      namespace :v1 do\n" +
            "        resources :tokens, only: [:create]\n" +
            "      end\n" +
            "    end\n" +
            "  end\n"
    end
  end
end