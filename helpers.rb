module SiteHelpers

  def title
    return JackieSite::TITLE if @title.nil?
    "#{JackieSite::TITLE} &raquo; #{@title}"
  end

  def section_path
    JackieSite::SECTIONS[@subtitle][:path]
  end

  def partial(page, options={})
    haml "_#{page}".to_sym, options.merge!(:layout => false)
  end

  def optional_partial(page, options={})
    file = settings.views + "/_" + page + ".haml"
    partial(page, options) if File.exists?(file)
  end

  def url_base
    "http://#{request.host_with_port}"
  end
end
