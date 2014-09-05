class Site
  class Renderer < Redcarpet::Render::HTML

    def initialize(slug, *args)
      @slug = slug
      super *args
    end

    def image(link, title, alt_text)
      unless link.match /^http|^\//
        link = "/images/#{@slug}/#{link}"
      end
      "</p><p class='image'><img src='#{link}' title='#{title}' alt='#{alt_text}' /><br /><span class='caption'>#{alt_text}</span>"
    end

  end
end
