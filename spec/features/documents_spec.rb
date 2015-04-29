require 'rails_helper'

RSpec.describe 'Authentication', type: :feature do
  before(:each) do
    @user = User.create
  end

  scenario 'creates a document' do
    page.set_rack_session(user_id: @user.id.to_s)
    visit('/dashboard')
    click_link('Create new document')

    within('form.document-form') do
      find('#document_content').set('some text')
      click_on 'Save'
    end

    expect(page).to have_content('Document created')

    doc = Document.find_by(content: 'some text')
    expect(doc).not_to be nil
    expect(doc.user).to eq @user

    word = DocumentWord.find_by(value: 'some')
    expect(word).not_to be nil
    expect(word.documents).to include doc.id
  end

  scenario 'updates a document' do
    page.set_rack_session(user_id: @user.id.to_s)
    document = Document.create(user: @user, content: 'some text')
    old_word = DocumentWord.create(value: 'some', documents: [document.id])

    visit('/dashboard')

    expect(page).to have_content ('some text')

    click_link('Edit')

    within('form.document-form') do
      find('#document_content').set('anything')
      click_on 'Save'
    end

    expect(page).to have_content('anything')
    old_word.reload

    expect(old_word.documents).not_to include document.id
  end

  scenario 'deletes a document' do
    page.set_rack_session(user_id: @user.id.to_s)
    document = Document.create(user: @user, content: 'some text')

    visit('/dashboard')

    click_link('Delete')

    expect(page).not_to have_content('some text')
  end
end