require 'babel/transpiler'
require 'sprockets'
require 'sprockets/es6/version'
require 'tilt'

module Sprockets
  class ES6 < Tilt::Template
    def prepare
    end

    def evaluate(scope, locals, &block)
      if scope.pathname.to_s.include? 'vendor'
        data
      else
        result = Babel::Transpiler.transform(data, {
          'filename' => scope.pathname.to_s,
        })
        result['code']
      end
    end

    def self.install(environment = ::Sprockets)
      environment.append_path Babel::Transpiler.source_path
      environment.register_preprocessor 'application/javascript', Sprockets::ES6
    end
  end
end
