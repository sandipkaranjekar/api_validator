# api_validator
[![Gem Version](https://badge.fury.io/rb/api_validator.svg)](https://badge.fury.io/rb/api_validator)
This gem helpful to validate api calls. You need to set rules and messages in yml file and rest of the things are handle by gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'api_validator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install api_validator

Also you need to run generator to set the files -

		$ rails g api_validator:install api_validator

Note : Here you can pass any name you want to set for initilizer file and validation yml file, instead of 'api_validator'.

## Usage

Before use of this gem you need to set ``` before_action :request_validation ``` in controller where you want to validate request before reach to controller's method.

Also you need to set rules in the api_validator.yml.erb file. Example are mentioned in yml file.

Sample pattern for validation as follows - 

```yaml
controller_name:
   method_name:
     param1:
       rules:
         presence: true
         integer: true
         min_length: 5
         max_length: 15
         pattern: <%= /\A^[a-zA-Z\s'.-]*$\Z/.source %>
         inclusion: 1..10"
       messages:
         presence: "Param1 must present."
         integer: "Param1 must contain integer only."
         min_length: "Param1 must have minimum length of 5."
         max_length: "Param1 must have maximum length of 15."
         pattern: "Invalid Param1"
         inclusion: "The param1 must be between 1 and 10"
```

Sample validation for JSON value in request parameter -

```yaml
 controller_name:
   method_name:
     param1:
       rules:
         presence: true
         json_string: true
       messages:
         presence: "Param1 must present."
         json_string: "Invalid json string."
       paramters:
         json_1st_param:
           rules:
             presence: true
           messages:
             presence: "Json first param must prresent."
         json_2nd_param:
           rules:
             integer: true
           messages:
             integer: "Json second param must be integer only."
```
## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

