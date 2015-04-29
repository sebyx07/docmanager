class Document
  include Mongoid::Document
  field :content, type: String, default: ''
  include Mongoid::Timestamps::Updated
  belongs_to :user

  def words
    content.scan(/[a-zA-Z]+/)
  end

  def words_db
    words_down = words.map { |w| w.downcase}
    DocumentWord.any_in(value: words_down)
  end

  def slug(size)
    if content.size > size
      content[0..size] + '...'
    else
      content
    end
  end
end
