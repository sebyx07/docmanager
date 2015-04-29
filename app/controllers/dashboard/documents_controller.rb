class Dashboard::DocumentsController < DashboardController

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(doc_params)
    @document.user = current_user

    if @document.save
      flash_success 'Document created'
      DocumentProcessorService.delay(:retry => false).build_doc(@document.id.to_s)
      redirect_to dashboard_path
    else
      flash_error @document.errors
      render :new
    end
  end

  def edit
    begin
      @document = Document.find(params[:id])
      render :new
    rescue Mongoid::Errors::DocumentNotFound
      flash_error 'Document not found'
      redirect_to dashboard_path
    end
  end

  def edit_post
    begin
      @document = Document.find(params[:id])
      old_content = @document.content
      if document_belongs_to_user?(@document) && @document.update(doc_params)
        DocumentProcessorService.delay(:retry => false).update_doc(@document.id.to_s, old_content)
        flash_success 'Document saved'
        redirect_to dashboard_path
      else
        flash_error @document.errors
        render :new
      end
    rescue Mongoid::Errors::DocumentNotFound
      flash_error 'Document not found'
      redirect_to dashboard_path
    end
  end

  def delete
    begin
      @document = Document.find(params[:id])
      old_content = @document.content
      if document_belongs_to_user?(@document) && @document.destroy
        DocumentProcessorService.delay(:retry => false).destroy_doc(@document.id.to_s, old_content)
        flash_success 'Document destroyed'
        redirect_to dashboard_path
      end
    rescue Mongoid::Errors::DocumentNotFound
      flash_error 'Document not found'
      redirect_to dashboard_path
    end
  end


  private
  def doc_params
    params.require(:document).permit(:content)
  end

  def document_belongs_to_user?(document)
    document.user == current_user
  end
end
