class DocumentProcessorService
  def self.build_doc(doc_id)
    begin
      doc = Document.find(doc_id)
      doc_words = doc.words.map { |w| w.downcase }
      db_doc_words = doc.words_db

      new_words = doc_words - db_doc_words.pluck(:value)
      new_words_hashes = new_words.uniq.map { |w| {value: w, documents: [doc_id]} }

      new_words_hashes.in_groups_of(1000).each do |batch|
        DocumentWord.collection.insert(batch)
      end

      db_doc_words.to_a.each do |word|
        unless word.documents.include? doc_id
          word.documents.push(doc_id)
          word.save
        end
      end

      true
    rescue Mongoid::Errors::DocumentNotFound
      false
    end
  end

  def self.update_doc(doc_id, old_content)
    begin
      doc = Document.find(doc_id)
      new_content = doc.words.map { |w| w.downcase }
      old_content = old_content.scan(/[a-zA-Z]+/).map { |w| w.downcase }

      all_words = (old_content + new_content).uniq

      words_to_add = new_content - old_content
      words_from_to_remove = old_content - new_content
      all_words_in_db = DocumentWord.any_in(value: all_words)

      db_words_to_dcr = all_words_in_db.any_in(value: words_from_to_remove)
      db_words_to_incr = all_words_in_db.any_in(value: words_to_add)

      db_words_to_dcr.to_a.each do |word|
        word.documents.delete(doc_id)
        word.save
      end

      db_words_to_incr.to_a.each do |word|
        word.documents.push(doc_id)
        word.save
      end

      words_to_create = all_words - all_words_in_db.pluck(:value)

      words_to_create = words_to_create.map { |w| {value: w, documents: [doc_id]} }

      words_to_create.in_groups_of(1000).each do |batch|
        DocumentWord.collection.insert(batch)
      end
      true
    rescue Mongoid::Errors::DocumentNotFound
      false
    end
  end

  def self.destroy_doc(doc_id, old_content)
    begin
      old_words = old_content.scan(/[a-zA-Z]+/).map { |w| w.downcase }

      words = DocumentWord.any_in(value: old_words)

      words.to_a.each do |w|
        w.documents.delete doc_id
        w.save
      end
      true
    rescue Mongoid::Errors::DocumentNotFound
      false
    end
  end
end