class Document
  include Mongoid::Document
  field :content, type: String, default: ''

  def words
    content.scan(/[a-zA-Z]+/)
  end

  def words_db
    words_down = words.map { |w| w.downcase}
    DocumentWord.any_in(value: words_down)
  end
end
