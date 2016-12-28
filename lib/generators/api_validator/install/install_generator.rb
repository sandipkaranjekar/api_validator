require 'rails/generators'

module ApiValidator
  module Generators
    class InstallGenerator < Rails::Generators::NamedBase
    	def self.source_root
        source_root ||= File.join(File.dirname(__FILE__), 'templates/')
      end

      def copy_initializer_file
        create_file "config/initializers/#{file_name}.rb", <<-FILE
        validation_template = ERB.new(File.new(File.expand_path('../../#{file_name}.yml.erb', __FILE__)).read)
        VALIDATION_CONFIG = HashWithIndifferentAccess.new(YAML.load(validation_template.result(binding)))
        FILE
      end

      def copy_validate_api_yml_file
      	copy_file "validate_api.yml.erb", "config/#{file_name}.yml.erb"
      end

      def add_module
        line = "class ApplicationController < ActionController::Base"
        gsub_file 'app/controllers/application_controller.rb', /(#{Regexp.escape(line)})/mi do |match|
          "#{match}\n include ApiValidator\n"
        end 
      end
    end
  end
end