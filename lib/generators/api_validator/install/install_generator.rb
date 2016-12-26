require 'rails/generators'

module ApiValidator
  module Generators
    class CreateGenerator < Rails::Generators::Base
    	def self.source_root
        source_root ||= File.join(File.dirname(__FILE__), 'templates/')
      end

      def copy_initializer_file
        copy_file "load_validate_api_config.rb", "config/initializers/#{file_name}.rb"
      end

      def copy_validate_api_yml_file
      	copy_file "validate_api.yml.erb", "config/#{file_name}.yml.erb"
      end
    end
  end
end