class JackieSite < Sinatra::Base

  before '/hire*' do
    @subtitle = 'hire'
  end

  get '/hire' do
    haml :hire
  end

end

