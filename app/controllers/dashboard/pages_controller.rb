class Dashboard::PagesController < DashboardController
  def index
    @users_documents = current_user.documents.order_by(:updated_at.desc)
    @other_documents = Document.not.where(user_id: current_user.id).order_by(:updated_at.desc)
  end
end
