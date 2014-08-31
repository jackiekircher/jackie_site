require 'bundler'
Bundler.require

require 'date'
require_relative 'post'

class JackieSite < Sinatra::Base
  TITLE    = "jackie kircher"
  SUBTITLE = "dotcom"

  helpers Sinatra::ContentFor

  helpers do
    def title
      return TITLE if @title.nil?
      "#{TITLE} &raquo; #{@title}"
    end

    def subtitle
      @subtitle || SUBTITLE
    end

    def subsection_url
      url_base + '/' + (@subtitle || '')
    end

    def partial(page, options={})
      haml "_#{page}".to_sym, options.merge!(:layout => false)
    end

    def url_base
      "http://#{request.host_with_port}"
    end
  end

end

require_relative 'blog'
require_relative 'projects'
