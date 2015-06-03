# Sprockets ES6
### Sprockets 2.12 compatible fork

**Experimental**

A Sprockets transformer that converts ES6 code into vanilla ES5 with [Babel JS](https://babeljs.io).

## Usage

``` ruby
# Gemfile
gem 'sprockets', '~> 2.12'
gem 'sprockets-es6', git: "git@github.com:jsdf/sprockets-es6.git", :branch => 'sprockets2'
```


``` ruby
require 'sprockets/es6'

# install with configuration
Sprockets::ES6.install do
  # any file paths matching this won't be processed
  @ignore_pattern = /vendor/
  # babel options as per https://babeljs.io/docs/usage/options/
  @babel_options = {
    'loose' => ['es6.classes', 'es6.properties.computed', 'es6.modules'],
    'optional' => ['spec.protoToAssign'],
  }
end

# you can also pass a custom Sprockets environment
Sprockets::ES6.install(app.assets)
```

``` js
// app.js

square = (x) => x * x

class Animal {
  constructor(name) {
    this.name = name
  }
}
```
