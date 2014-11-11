require_relative 'blog/post'

class JackieSite < Sinatra::Base

  before '/blog*' do
    @subtitle = 'blog'
  end

  get '/blog' do
    source   = latest_posts.first
    @content = source.content
    @title   = source.title
    @date    = source.date
    @formatted_date = source.formatted_date

    haml :post
  end

  get '/blog/posts/:id' do
    source   = Post.new(params[:id])
    @content = source.content
    @title   = source.title
    @date    = source.date
    @formatted_date = source.formatted_date

    haml :post
  end

  get '/blog/archive' do
    @posts = latest_posts

    haml :archive
  end

  get '/blog/rss.xml' do
    @posts = latest_posts.first(10)

    content_type 'application/atom+xml'
    builder :feed
  end

end
