class JackieSite < Sinatra::Base

  before '/hire*' do
    @subtitle = 'hire'
  end

  get '/hire' do
    @resume = File.read("hire/resume/resume.md")

    renderer = Site::Renderer.new("resume")
    r = Redcarpet::Markdown.new(renderer, :fenced_code_blocks => true, :tables => true)
    @resume = r.render(@resume)

    haml :hire
  end

end

