validation_template = ERB.new(File.new(File.expand_path('../../validation.yml.erb', __FILE__)).read)
VALIDATION_CONFIG = HashWithIndifferentAccess.new(YAML.load(validation_template.result(binding)))