require 'bundler'
Bundler.require
require_relative 'helpers'

class JackieSite < Sinatra::Base
  TITLE    = "jackie kircher"
  SUBTITLE = "dotcom"
  SECTIONS = {
               SUBTITLE   => { :path  => "/",
                               :label =>  "/.." },
               "blog"     => { :path  => "/blog",
                               :label =>  "blog" },
               "projects" => { :path  => "/projects",
                               :label =>  "projects" },
               "hire"     => { :path  => "/hire",
                               :label =>  "hire" }
              }

  helpers Sinatra::ContentFor
  helpers SiteHelpers

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
