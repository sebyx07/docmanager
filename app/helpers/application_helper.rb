module ApplicationHelper
  def markdown(text)
    sanitized_html = sanitize text
    MarkdownService.instance.render sanitized_html
  end
end
