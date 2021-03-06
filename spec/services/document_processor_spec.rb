require 'rails_helper'

RSpec.describe DocumentProcessorService do
  subject(:proc){DocumentProcessorService}

  before(:each) do
    @doc1 = Document.create(content: 'OMG')
    @doc2 = Document.create(content: 'EZ LIFE')

    @word1 = DocumentWord.create(value: 'omg', documents: [@doc1.id])
    @word2 = DocumentWord.create(value: 'ez', documents: [@doc2.id])
    @word3 = DocumentWord.create(value: 'life', documents: [@doc2.id])
  end

  describe '#build_doc' do
    it 'builds a new document' do
      doc = Document.create(content: 'OMG EZ AA')
      expect(proc.build_doc(doc.id.to_s)).to be true

      new_word = DocumentWord.where(value: 'aa').first
      expect(new_word).not_to be nil
      expect(new_word.documents).to include doc.id

      old_word = DocumentWord.where(value: 'omg').first

      expect(old_word.documents).to include doc.id
    end
  end

  describe '#update_doc' do
    it 'updates a existing document' do
      @doc2.update(content: 'GG')
      expect(proc.update_doc(@doc2.id.to_s, 'EZ LIFE')).to be true

      new_word = DocumentWord.where(value: 'gg').first
      expect(new_word).not_to be nil
    end
  end
end