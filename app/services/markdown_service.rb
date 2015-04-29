class MarkdownService
  def self.instance
    if @instance
      @instance
    else
      @instance = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    end
  end
end