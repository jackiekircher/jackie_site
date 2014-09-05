require 'bundler'
Bundler.require

class JackieSite < Sinatra::Base
  TITLE    = "jackie kircher"
  SUBTITLE = "dotcom"
  SECTIONS = {
               SUBTITLE   => { :path  => "/",
                               :label =>  ".." },
               "blog"     => { :path  => "/blog",
                               :label =>  "blog" },
               "projects" => { :path  => "/projects",
                               :label =>  "projects" },
               "hire"     => { :path  => "/hire",
                               :label =>  "hire" }
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

    def optional_partial(page, options={})
      file = settings.views + "/_" + page + ".haml"
      partial(page, options) if File.exists?(file)
    end

    def url_base
      "http://#{request.host_with_port}"
    end
  end

  # set default subtitle, this is overriden in most sections
  before do
    @subtitle = SUBTITLE
  end

  get '/' do
    haml :index
  end

end

require_relative 'renderer'

require_relative 'blog'
require_relative 'projects'
require_relative 'hire'
