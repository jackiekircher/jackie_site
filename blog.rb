class JackieSite < Sinatra::Base

  helpers do
    def latest_posts
      posts = Dir.glob("posts/*.md").map do |post|
        post = post[/posts\/(.*?).md$/,1]
        Post.new(post)
      end
      # since posts filenames start with the date, this
      # orders them most recent -> least recent
      posts.sort_by(&:name).reverse
    end
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
