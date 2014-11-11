class JackieSite < Sinatra::Base

  before '/projects*' do
    @subtitle = 'projects'
  end

  get '/projects' do
    haml :projects
  end

  get '/projects/css3-animations' do
    @animations = css3_animations

    haml :animations
  end

  get '/projects/l-systems' do
    haml :lsystems
  end

end
