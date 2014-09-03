require 'bundler'
Bundler.require

require 'date'
require_relative 'post'

class JackieSite < Sinatra::Base
  TITLE    = "jackie kircher"
  SUBTITLE = "dotcom"
  SECTIONS = {
               SUBTITLE   => { :path  => "/",
                               :label =>  ".." },
               "blog"     => { :path  => "/blog",
                               :label =>  "blog" },
               "projects" => { :path  => "/projects",
                               :label =>  "projects" }
              }

  helpers Sinatra::ContentFor

  helpers do
    def title
      return TITLE if @title.nil?
      "#{TITLE} &raquo; #{@title}"
    end

    def section_path
      SECTIONS[@subtitle][:path]
    end

    def partial(page, options={})
      haml "_#{page}".to_sym, options.merge!(:layout => false)
    end

    def url_base
      "http://#{request.host_with_port}"
    end
  end

  # set default subtitle, this is overriden in most sections
  before do
    @subtitle = SUBTITLE
  end

end

require_relative 'blog'
require_relative 'projects'
