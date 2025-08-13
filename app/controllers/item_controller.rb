class ItemController < ApplicationController
  # GET /master/item
  def show
    params[:per_page] ||= 9
    @categories = Category.by_perusahaan(@current_perusahaan.id)
    @data = Item.includes(:category, :image_attachment).by_perusahaan(@current_perusahaan.id)
    @data = @data.where("kode_item LIKE :q OR nama_item LIKE :q", { q: "%#{params[:q]}%" }) if params[:q].present?
    @data = @data.where(category: { id: params[:c] }) if params[:c].present? && params[:c].is_a?(Array)

    total = @data.count
    @pagination = paginate(total)
    @data = @data.order(kode_item: :asc).limit(@pagination[:per_page]).offset(@pagination[:skip])

    render inertia: "master/item/show", props: {
      categories: @categories,
      pagination: @pagination,
      data: @data.as_json(include: [ :category ])
    }
  end

  # GET /master/item/new
  def new
    @categories = Category.by_perusahaan(@current_perusahaan.id)
    render inertia: "master/item/new", props: {
      categories: @categories
    }
  end

  # GET /master/item/edit/:id
  def edit
    @categories = Category.by_perusahaan(@current_perusahaan.id)
    @data = Item.includes(:category, :image_attachment).by_perusahaan(@current_perusahaan.id).find_by!(id: params[:id])
    render inertia: "master/item/edit", props: {
      categories: @categories,
      data: @data.as_json(include: [ :category ])
    }
  end

  # POST /master/item
  def create
    ApplicationRecord.transaction do
      # create item
      @data = Item.new
      @data.assign_attributes(item_params)
      @data.perusahaan_id = @current_perusahaan.id
      @data.created_by = @current_user.email
      @data.save!

      # create item categories
      if item_category_params[:category].present?
        item_category_params[:category].each_value do |c|
          ItemCategory.create!(item_id: @data.id, category_id: c[:id], created_by: @current_user.email)
        end
      end

      # item image
      if image_params[:image].present?
        @data.image.attach(image_params[:image])
      end
    end

    flash[:success] = "Item created successfully"
    redirect_to action: :show
  end

  # PUT /master/item/:id
  def update
    ApplicationRecord.transaction do
      # update item
      @data = Item.includes(:item_category, :image_attachment).by_perusahaan(@current_perusahaan.id).find_by!(id: params[:id])
      @data.assign_attributes(item_params)
      @data.updated_by = @current_user.email
      @data.save!

      # update category ids
      if item_category_params[:category].present?
        @ids = []
        item_category_params[:category].each_value { |v| @ids << v[:id] }
        @data.item_category.where.not(category_id: @ids).destroy_all

        @ids.each do |id|
          ItemCategory.find_or_create_by!(item_id: @data.id, category_id: id) do |ic|
            ic.created_by = @current_user.email
          end
        end
      end

      # delete image
      if image_params[:delete_image].present? && image_params[:delete_image] == "1"
        @data.image.purge
      end

      # attach image
      if image_params[:image].present?
        @data.image.attach(image_params[:image])
      end
    end

    flash[:success] = "Item updated successfully"
    redirect_to action: :show
  end

  # DELETE /master/item/:id
  def destroy
    @data = Item.by_perusahaan(@current_perusahaan.id).find_by!(id: params[:id])
    @data.destroy!

    flash[:success] = "Item deleted successfully"
    redirect_to action: :show
  end

  private
  def item_params
    params.permit(:kode_item, :nama_item, :keterangan)
  end

  def image_params
    params.permit(:image, :delete_image)
  end

  def item_category_params
    params.permit(category: [ :id ])
  end
end
