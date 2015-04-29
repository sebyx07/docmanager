class Dashboard::DocumentsController < DashboardController

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(doc_params)
    @document.user = current_user

    if @document.save
      flash_success 'Document created'
      DocumentProcessor.instance.build_doc(@document)
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
      old_doc = Document.new(@document.attributes)

      if @document.user == current_user && @document.update(doc_params)
        DocumentProcessor.instance.update_doc(old_doc, @document.content)
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
      if @document.destroy
        DocumentProcessor.instance.destroy_doc(@document)
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
end
