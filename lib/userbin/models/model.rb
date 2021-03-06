require 'her'

module Userbin
  class Model
    include Her::Model
    use_api Userbin::API

    def initialize(args = {})
      # allow initializing with id as a string
      args = { id: args } if args.is_a? String
      super(args)
    end

    METHODS.each do |method|
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def self.instance_#{method}(action)
          instance_custom(:#{method}, action)
        end
      RUBY
    end

    def self.instance_custom(method, action)
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{action}(params={})
          self.class.#{method}("\#{request_path}/#{action}", params)
        end
      RUBY
    end
  end
end
