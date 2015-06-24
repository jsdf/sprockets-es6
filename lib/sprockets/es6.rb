require 'babel/transpiler'
require 'sprockets'
require 'tilt'

module Sprockets
  class ES6 < Tilt::Template
    def self.install(environment = ::Sprockets, &block)
      preprocessor_class = if block_given?
        Class.new(Sprockets::ES6, &block)
      else
        Sprockets::ES6
      end

      environment.append_path Babel::Transpiler.source_path
      environment.register_preprocessor 'application/javascript', preprocessor_class
    end

    def self.module_wrapper
      return @module_wrapper if defined?(@module_wrapper)
      @module_wrapper = true
    end

    def self.babel_options
      @babel_options ||= {}
    end

    def self.include_matcher
      @include_matcher ||= Proc.new { true }
    end

    def self.exclude_matcher
      @exclude_matcher ||= Proc.new { false }
    end

    def prepare
    end

    def ignored?(filepath)
      !(
        self.class.include_matcher.call(filepath) &&
        !self.class.exclude_matcher.call(filepath)
      )
    end

    def whitespace_only?(code)
      !(code =~ /\S/)
    end

    def evaluate(scope, locals, &block)
      return data if ignored?(scope.pathname.to_s) || whitespace_only?(data)

      result = Babel::Transpiler.transform(
        data,
        self.class.babel_options.merge({
          'filename' => scope.pathname.to_s,
        })
      )

      code = result['code']

      if self.class.module_wrapper
        apply_module_wrapper(code)
      else
        code
      end
    end

    private    

    def apply_module_wrapper(code)
      ";(function(){\n#{code}\n})();"
    end
  end
end
