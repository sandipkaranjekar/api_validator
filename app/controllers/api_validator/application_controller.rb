module ApiValidator
	class ApplicationController < ActionController::Base
	  # request validation method
	  # Input - params
	  # Process - Validate params with there rules & definition
	  # Output - report error on invalidity
	  def request_validation
	    # to support legacy - the validation is only applicable when "version_number" presents
	    #if params[:version_number].present? && params[:controller].present? && params[:action].present? && VALIDATION_CONFIG[params[:controller]][params[:action]].present?
	    if params[:controller].present? && params[:action].present? && VALIDATION_CONFIG[params[:controller]].present?  && VALIDATION_CONFIG[params[:controller]][params[:action]].present?
	      # validation - parameters defination 
	      validation_pd = VALIDATION_CONFIG[params[:controller]][params[:action]]
	      
	      validation_pd.keys.each do |key|
	        next if params.has_key?(key) == false && validation_pd[key]["rules"].has_key?("presence") == false
	        validation_pd[key]["rules"].each do |rule, definition|
	          # when param's value is JSON string then parse it and validate parameters
	          if (rule == "json_string" and definition == true)
	            begin
	              json_data = JSON.parse(params[key])
	              json_data = [json_data] unless json_data.class == Array
	              json_data.each do |data|
	                data.keys.each do |json_data_key|
	                  if validation_pd[key].has_key?("parameters")
	                    next unless validation_pd[key]["parameters"].has_key?(json_data_key)
	                    validation_pd[key]["parameters"][json_data_key]["rules"].each do |json_data_rule, json_data_definition|
	                      #CAUTION: if nested JSON, this should be recursive
	                      return error_response(validation_pd[key]["parameters"][json_data_key]["messages"][json_data_rule]) if validate?(json_data_key, data[json_data_key], json_data_rule, json_data_definition, validation_pd[key]["parameters"][json_data_key])
	                    end
	                  end
	                end
	              end
	            rescue JSON::ParserError => e  
	              return error_response(validation_pd[key]["messages"][rule], 422)
	            end
	          # when param's value is NOT JSON
	          else
	            return error_response(validation_pd[key]["messages"][rule]) if validate?(key, params[key], rule, definition, validation_pd[key])
	          end
	        end # param rule loop end
	      end # params list loop end
	    end # main if end
	  end

	  def error_response(message = nil, status = 400)
	    response = {status: 'error', message: message}
	    render json: response, status: status
	  end

	  def is_mobile_no_valid?(mobile, country_code = "+91")
	    mobile_no = country_code + mobile
	    return (Phonelib.valid?(mobile_no) ? true : false)
	  end

	  def is_integer?(value)
	    !!(value =~ INTEGER_REGEX)
	  end

	  def is_pattern_match?(value, pattern)
	    !!(value =~ pattern)
	  end

	  def validate_array_string?(value, separator)
	    parameter_ids = value.split(separator)
	    parameter_ids.each do |parameter|
	        return false unless !!(parameter =~ INTEGER_REGEX)
	    end
	    return true
	  end

	  def validate?(key, value, rule, definition, dtd)
      is_error_found = false
      case
      when (rule == "ignore_if_present" and definition.present?)
        # return error if not present & defination absence
        is_error_found = true if value.present? == false and params[definition].present? == false
      when (rule == "presence" and definition == true)
        # return error if not present
        is_error_found = true unless value.present?
      when (rule == "array_string" and definition.present?)
        # return error if array string invalid
        is_error_found = true unless validate_array_string?(value, definition)
      when (rule == "integer" and definition == true)
        # return error if not match with integer
        is_error_found = true unless is_integer?(value)
      when (rule == "min_length" and definition > 0)
        # return error if minimum length is not achived
        is_error_found = true unless value.length >= definition
      when (rule == "max_length" and definition > 0)
        # return error if maximum length is not achived
        is_error_found = true unless value.length <= definition
      when (rule == "max_value" and definition > 0)
        # return error if param's value is less or equal to definition
        is_error_found = true unless value.to_f <= definition
      when (rule == "pattern" and definition.present?)
        # return error if pattern doesn't match
        if dtd["rules"].has_key?("presence") == true || value.present?
          is_error_found = true unless is_pattern_match?(value, Regexp.new(definition))
        end
      end
      return is_error_found
    end
	end
end