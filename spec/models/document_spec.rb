require 'rails_helper'

RSpec.describe Document, type: :model do
  subject(:doc){
    Document.create(content: 'OMG LOL 33')
  }

  describe '#words' do
    it 'has 2 words' do
      expect(doc.words.size).to eq 2
    end
  end

  describe '#words_db' do
    before(:each) do

    end

    it 'has 2 words in db' do
      DocumentWord.create(value: 'omg')
      DocumentWord.create(value: 'lol')

      expect(doc.words_db.size).to eq 2
    end
  end
end
