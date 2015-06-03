require 'babel/transpiler'
require 'sprockets'
require 'sprockets/es6/version'
require 'tilt'

module Sprockets
  class ES6 < Tilt::Template
    def prepare
    end

    def self.babel_options
      @babel_options || {}
    end

    def self.ignore_pattern
      @ignore_pattern
    end

    def ignored?(filepath)
      if self.class.ignore_pattern
        filepath =~ self.class.ignore_pattern
      else
        false
      end
    end

    def evaluate(scope, locals, &block)
      return data if ignored?(scope.pathname.to_s)

      result = Babel::Transpiler.transform(
        data,
        self.class.babel_options.merge({
          'filename' => scope.pathname.to_s,
        })
      )
      result['code']
    end

    def self.install(environment = ::Sprockets, &block)
      preprocessor_class = if block_given?
        Class.new(Sprockets::ES6, &block)
      else
        Sprockets::ES6
      end

      environment.append_path Babel::Transpiler.source_path
      environment.register_preprocessor 'application/javascript', preprocessor_class
    end
  end
end
