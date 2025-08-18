class CategoryController < ApplicationController
  # GET /master/category
  def show
    @data = Category.by_perusahaan(@current_perusahaan.id)
    @data = @data.where("nama_category LIKE ?", "%#{search_param[:q]}%") if search_param[:q].present?

    total = @data.count
    @pagination = paginate(total)
    @data = @data.order(nama_category: :asc).limit(@pagination[:per_page]).offset(@pagination[:skip])

    render inertia: "master/category/show", props: {
      pagination: @pagination,
      data: @data
    }
  end

  # GET /master/category/new
  def new
    render inertia: "master/category/new"
  end

  # GET /master/category/edit/:id
  def edit
    @data = Category.by_perusahaan(@current_perusahaan.id).find_by!(id: params[:id])
    render inertia: "master/category/edit", props: {
      data: @data
    }
  end

  # POST /master/category
  def create
    @data = Category.new
    @data.assign_attributes(category_params)
    @data.perusahaan = @current_perusahaan
    @data.created_by = @current_user.email
    @data.save!

    flash[:success] = "Category created successfully."
    redirect_to action: :show
  end

  # PUT /master/category/:id
  def update
    @data = Category.by_perusahaan(@current_perusahaan).find_by!(id: params[:id])
    @data.assign_attributes(category_params)
    @data.updated_by = @current_user.email
    @data.save!

    flash[:success] = "Category updated successfully."
    redirect_to action: :show
  end

  # DELETE /master/category/:id
  def destroy
    @data = Category.by_perusahaan(@current_perusahaan).find_by!(id: params[:id])
    @data.destroy!

    flash[:success] = "Category deleted successfully."
    redirect_to search_param.merge(action: :show)
  end

  private
  def search_param
    params.permit(:q, :page, :per_page)
  end

  def category_params
    params.permit(:nama_category, :keterangan)
  end
end
