require 'bundler'
Bundler.require

require 'date'
require_relative 'post'

class Blog < Sinatra::Base
  TITLE = "jackie kircher"

  helpers Sinatra::ContentFor

  helpers do
    def title
      return TITLE if @title.nil?
      "#{TITLE} &raquo; #{@title}"
    end

    def latest_posts
      posts = Dir.glob("posts/*.md").map do |post|
        post = post[/posts\/(.*?).md$/,1]
        Post.new(post)
      end
      posts.sort_by(&:name).reverse
    end

    def partial(page, options={})
      haml "_#{page}".to_sym, options.merge!(:layout => false)
    end

    def url_base
      "http://#{request.host_with_port}"
    end
  end

  get '/' do
    source = latest_posts.first
    @content = source.content
    @title = source.title
    @date = source.date
    @formatted_date = source.formatted_date

    haml :post
  end

  get '/posts/:id' do
    source = Post.new(params[:id])
    @content = source.content
    @title = source.title
    @date = source.date
    @formatted_date = source.formatted_date

    haml :post
  end

  get '/archive' do
    @posts = latest_posts

    haml :archive
  end

  get '/rss.xml' do
    @posts = latest_posts.first(10)

    content_type 'application/atom+xml'
    builder :feed
  end
end
