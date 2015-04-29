class Dashboard::PagesController < ApplicationController
  def index
    @users_documents = current_user.documents
    @other_documents = Document.not.where(user_id: current_user.id)
  end
end
