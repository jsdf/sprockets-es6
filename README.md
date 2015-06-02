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
