require 'rails_helper'

RSpec.describe DocumentProcessor do
  subject(:proc){DocumentProcessor.instance}

  before(:each) do
    @doc1 = Document.create(content: 'OMG')
    @doc2 = Document.create(content: 'EZ LIFE')

    @word1 = DocumentWord.create(value: 'omg', documents: [@doc1.id])
    @word2 = DocumentWord.create(value: 'ez', documents: [@doc2.id])
    @word3 = DocumentWord.create(value: 'life', documents: [@doc2.id])
  end

  describe '#build_doc' do
    it 'builds a new document' do
      doc = Document.new(content: 'OMG EZ AA')
      expect(proc.build_doc(doc)).to be true

      new_word = DocumentWord.where(value: 'aa').first
      expect(new_word).not_to be nil
      expect(new_word.documents).to include doc.id

      old_word = DocumentWord.where(value: 'omg').first

      expect(old_word.documents).to include doc.id
    end
  end

  describe '#update_doc' do
    it 'updates a existing document' do
      new_content = 'GG LIFE'
      expect(proc.update_doc(@doc2, new_content)).to be true

      new_word = DocumentWord.where(value: 'gg').first
      expect(new_word).not_to be nil

      old_word = DocumentWord.where(value: 'ez').first
      expect(old_word.documents).not_to include @doc2.id
    end
  end

  describe '#destroy_doc' do
    it 'destroys a existing document' do
      expect(proc.destroy_doc @doc1)
      @word1.reload
      expect(@word1.documents).not_to include @doc1.id
    end
  end
end