class CustomerController < ApplicationController
  # GET /master/customer
  def show
    search_param[:per_page] ||= 9
    @data = Customer.by_perusahaan(@current_perusahaan.id)
    @data = @data.where("nama_customer LIKE :q OR email LIKE :q OR no_telp LIKE :q", { q: "%#{search_param[:q]}%" }) if search_param[:q].present?

    total = @data.count
    @pagination = paginate(total)
    @data = @data.order(nama_customer: :asc).limit(@pagination[:per_page]).offset(@pagination[:skip])

    render inertia: "master/customer/show", props: {
      pagination: @pagination,
      data: @data.as_json
    }
  end

  # GET /master/customer/new
  def new
    render inertia: "master/customer/new", props: {}
  end

  # GET /master/customer/edit/:id
  def edit
    @data = Customer.by_perusahaan(@current_perusahaan.id).find_by!(id: params[:id])
    render inertia: "master/customer/edit", props: {
      data: @data.as_json
    }
  end

  # POST /master/customer
  def create
    ApplicationRecord.transaction do
      @data = Customer.new
      @data.assign_attributes(customer_params)
      @data.perusahaan_id = @current_perusahaan.id
      @data.created_by = @current_user.email
      @data.save!
    end

    flash[:success] = "Customer created successfully"
    redirect_to action: :show
  end

  # PUT /master/customer/:id
  def update
    ApplicationRecord.transaction do
      @data = Customer.by_perusahaan(@current_perusahaan.id).find_by!(id: params[:id])
      @data.assign_attributes(customer_params)
      @data.updated_by = @current_user.email
      @data.save!
    end

    flash[:success] = "Customer updated successfully"
    redirect_to action: :show
  end

  # DELETE /master/customer/:id
  def destroy
    @data = Customer.by_perusahaan(@current_perusahaan.id).find_by!(id: params[:id])
    @data.destroy!

    flash[:success] = "Customer deleted successfully"
    redirect_to search_param.merge(action: :show)
  end

  private

  def search_param
    params.permit(:q, :page, :per_page)
  end

  def customer_params
    params.permit(:nama_customer, :email, :no_telp, :alamat)
  end
end
