class JackieSite < Sinatra::Base

  before '/projects*' do
    @subtitle = 'projects'
  end

  helpers do
    def css3_animations
      animations = Dir.entries("public/css3_animations/animations")
      return animations[2 .. animations.length]
    end
  end

  get '/projects' do
    haml :projects
  end

  get '/projects/css3-animations' do
    @animations = css3_animations

    haml :animations
  end

end
