require 'minitest/autorun'
require_relative '../base'

class HelpersTest < MiniTest::Test
  include SiteHelpers
  def haml(page, options)
  end

  def test_title_contains_title
    @title = rand(100).to_s
    assert_match @title, title
  end

  def test_partial_does_not_use_layout
    called = false
    l = lambda do |name, options|
          assert_equal false, options[:layout]
          called = true
        end

    stub(:haml, l) do
      partial("header")
      assert called
    end
  end

  def test_optional_partial_does_not_fail_if_file_does_not_exist
    optional_partial("does not exist")
    assert true
  end
end
