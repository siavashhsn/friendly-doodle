class Admin::FabricsController < Admin::UploaderController
  before_action :set_admin_fabric, only: [:show, :edit, :update, :archive]

  # GET /admin/fabrics
  # GET /admin/fabrics.json
  def index
    @admin_fabrics = Admin::Fabric.with_deleted.paginate(page: params[:page])
  end

  # GET /admin/fabrics/1
  # GET /admin/fabrics/1.json
  def show
  end

  # GET /admin/fabrics/new
  def new
    @admin_fabric = Admin::Fabric.new
    consider_parital_view
  end

  # GET /admin/fabrics/1/edit
  def edit
    consider_parital_view
  end

  # POST /admin/fabrics
  # POST /admin/fabrics.json
  def create
    @admin_fabric = Admin::Fabric.new(admin_fabric_params)

    respond_to do |format|
      if @admin_fabric.save
        # update the uploaded image and re-save the model
        # the model need to be created at first then the update happen
        update_uploaded_images @admin_fabric, :admin_fabric, auto_save: true
        format.html { redirect_to admin_fabrics_path, notice: "طرح «<b>#{@admin_fabric.id}</b>» با موفقیت ایجاد شد." }
        format.json { render json: @admin_fabric, status: :created, location: admin_fabrics_path }
      else
        format.html { render :new }
        format.json { render json: @admin_fabric.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/fabrics/1
  # PATCH/PUT /admin/fabrics/1.json
  def update
    prevent_browser_caching
    # update the uploaded images
    update_uploaded_images @admin_fabric, :admin_fabric
    respond_to do |format|
      if @admin_fabric.update(admin_fabric_params)
        format.html { redirect_to admin_fabrics_path, notice: "طرح «<b>#{@admin_fabric.id}</b>» با موفقیت ویرایش شد." }
        format.json { render json: @admin_fabric, status: :ok, location: admin_fabrics_path }
      else
        format.html { render :edit }
        format.json { render json: @admin_fabric.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/fabrics/1
  # DELETE /admin/fabrics/1.json
  def destroy
    @admin_fabric = Admin::Fabric.with_deleted.find(params[:id])
    # remove the images
    @admin_fabric.remove_images!
    # delete the record
    @admin_fabric.destroy_fully!
    respond_to do |format|
      format.html { redirect_to admin_fabrics_path, notice: "طرح «<b>#{@admin_fabric.id}</b>» با موفقیت حذف شد." }
      format.json { head :no_content }
    end
  end
  
  def archive
    # archive current type
    @admin_fabric.destroy
    # make an undo link to un-acrhiving
    undo_url = view_context.link_to view_context.raw('<span class="fa fa-recycle"></span> بازیافت'), recover_admin_fabric_path, :method => :patch
    # respond to format
    respond_to do |format|
      format.html { redirect_to admin_fabrics_path, notice: "طرح «<b>#{@admin_fabric.id}</b>» با موفقیت آرشیو شد. [ #{undo_url} ] " }
      format.json { head :no_content }
    end
  end
  
  def recover no_redirect: false
    # un-archive the fabric type
    @admin_fabric = Admin::Fabric.only_deleted.where("id = ?", params[:id]).first
    @admin_fabric.recover
    # make an undo link to un-acrhiving
    undo_url = view_context.link_to view_context.raw('<span class="fa fa-archive"></span> آرشیو') , archive_admin_fabric_path, :method => :delete
    # return if this is an internal call
    return if no_redirect
    # respond to format
    respond_to do |format|
      format.html { redirect_to admin_fabrics_path, notice: "طرح «<b>##{@admin_fabric.id}</b>» با موفقیت از آرشیو خارج شد. [ #{undo_url} ] " }
      format.json { head :no_content }
    end
  end

  def list_images
    ls_images Admin::Fabric.with_deleted.find(params[:id])
  end

  private
  
    def consider_parital_view
      return if not params[:pv]
      id = params[:pv].to_i
      partials = [
        '01_general',
        '02_images_detail'
      ]
      if partials[id]
        render partial: "admin/fabrics/forms/#{partials[id]}"
      end
    end
  
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_fabric
      @admin_fabric = Admin::Fabric.find(params[:id])
      @admin_fabric.images_detail ||= []
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_fabric_params
      params.require(:admin_fabric).permit(:admin_fabric_type_id, :admin_fabric_brand_id, :comment, { images_detail: [] })
    end
end
