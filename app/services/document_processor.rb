class DocumentProcessor
  include Singleton

  def build_doc(doc)
    doc_words = doc.words.map { |w| w.downcase }
    db_doc_words = doc.words_db

    new_words = doc_words - db_doc_words.pluck(:value)

    new_words.map { |w| DocumentWord.create(value: w, documents: [doc.id])}

    db_doc_words.each {|w| w.documents.push doc.id; w.save }
    true
  end

  def update_doc(doc, content)
    old_content = doc.words.map { |w| w.downcase }
    new_content = content.scan(/[a-zA-Z]+/).map { |w| w.downcase }

    words_to_add = new_content - old_content
    words_to_update = old_content - new_content

    existing_words_to_add = DocumentWord.any_in(value: words_to_add)
    existing_words_to_add.each { |w| w.documents.push(doc.id); w.save}

    words_to_create = words_to_add - existing_words_to_add.pluck(:value)

    words_to_create.map {|w| DocumentWord.create(value: w, documents: [doc.id])}

    DocumentWord.any_in(value: words_to_update).map {|w| w.documents.delete(doc.id); w.save}
    true
  end

  def destroy_doc(doc)
    doc_words_exist = doc.words_db
    doc_words_exist.each {|w| w.documents.delete(doc.id); w.save}
    true
  end
end