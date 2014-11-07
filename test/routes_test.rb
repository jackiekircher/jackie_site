require_relative 'test_helper'
require_relative '../base'

class RoutesTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    JackieSite
  end

  def test_home_route
    get '/'
    assert last_response.ok?
  end

  def test_blog
    get '/blog'
    assert last_response.ok?
  end

  def test_blog_post
    get '/blog/posts/2014-09-19-corgi-stylesheets'
    assert last_response.ok?
  end

  def test_blog_archive
    get '/blog/archive'
    assert last_response.ok?
  end

  def test_blog_ress
    get '/blog/rss.xml'
    assert last_response.ok?
  end

  def test_projects
    get '/projects'
    assert last_response.ok?
  end

  def test_projects_animations
    get '/projects/css3-animations'
    assert last_response.ok?
  end

  def test_project_l_systems
    get '/projects/l-systems'
    assert last_response.ok?
  end

  def test_hire
    get '/hire'
    assert last_response.ok?
  end
end
