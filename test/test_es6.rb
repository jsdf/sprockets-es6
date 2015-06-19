require 'minitest/autorun'
require 'sprockets'
require 'sprockets/es6'

class TestES6 < MiniTest::Test
  def setup
    @env = Sprockets::Environment.new
    @env.append_path File.expand_path("../fixtures", __FILE__)
    Sprockets::ES6.install(@env) do
      @babel_options = {'blacklist' => ["spec.functionName"] }
    end
  end

  def test_transform_arrow_function
    assert asset = @env["math.js"]
    assert_equal 'application/javascript', asset.content_type
    assert_equal <<-JS.chomp, asset.to_s.strip
"use strict";

var square = function (n) {
  return n * n;
};
    JS
  end

  def test_common_modules
    assert asset = @env["mod.js"]
    assert_equal 'application/javascript', asset.content_type
    assert_equal <<-JS.chomp, asset.to_s.strip
"use strict";

require("foo");
    JS
  end
end
