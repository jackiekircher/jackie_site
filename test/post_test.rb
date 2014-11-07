require_relative 'test_helper'
require_relative '../base'

class PostTest < MiniTest::Test

  def file_template(title: "foo", content: "bar")
    return <<EOF
---
title: #{title}
---

#{content}
EOF
  end

  def test_post_reads_title
    @title   = "title" + rand(100).to_s
    @example = file_template(title: @title)

    File.stub(:read, @example) do
      assert_equal @title, Post.new("2014-11-07-foo").title
    end
  end

  def test_post_reads_content
    @content = "content" + rand(100).to_s
    @example = file_template(content: @content)

    # assert_match here because content uses the
    # Site::Renderer to add html markup
    File.stub(:read, @example) do
      assert_match @content, Post.new("2014-11-07-foo").content
    end
  end

  def test_post_reads_date_from_file_name
    File.stub(:read, file_template) do
      assert_equal Date.parse("2014-11-07"), Post.new("2014-11-07-foo").date
    end
  end

  def test_post_slug_does_not_contain_the_date
    File.stub(:read, file_template) do
      refute_match "2014-11-07", Post.new("2014-11-07-foo").slug
    end
  end
end
