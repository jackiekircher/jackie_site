require 'yaml'
require 'date'


class Post
  attr_reader :name
  attr_reader :title
  attr_reader :date
  attr_reader :slug

  def initialize(name)
    @name = name
    begin
      content = File.read("blog/posts/#{name}.md")
    rescue
      return
    end

    match = content.match(/^---$(.*?)^---$(.*)/m)

    unless match.nil?
      meta_data = match[1]
      @content_raw = match[2]

      meta_data = YAML.load(meta_data)

      @title = meta_data["title"]
    end

    date_str = name.match(/^\d{4}-\d{2}-\d{2}/).to_s
    @date = Date.parse(date_str)
    @slug = name[/#{date_str}-(.*)$/,1]

    puts @slug

  end

  def content
    @content ||= begin
      renderer = Site::Renderer.new(@slug)
      r = Redcarpet::Markdown.new(renderer, :fenced_code_blocks => true)
      r.render(@content_raw)
    end
  end

  def formatted_date
    @formatted_date ||= @date.strftime("%Y.%m.%d")
  end
end
