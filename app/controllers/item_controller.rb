class ItemController < ApplicationController
  # GET /master/item
  def show
    p = search_param
    p[:per_page] ||= 12

    @categories = Category.by_perusahaan(@current_perusahaan.id)
    @data = Item.includes(:category, :image_attachment).by_perusahaan(@current_perusahaan.id)
    @data = @data.where("kode_item LIKE :q OR nama_item LIKE :q", { q: "%#{p[:q]}%" }) if p[:q].present?
    if p[:c].present? && p[:c].is_a?(Array)
      @ids = @data.joins(:category).where(category: { id: p[:c] }).pluck(:id)
      @data = @data.where(id: @ids)
    end

    total = @data.count
    @pagination = paginate(total, p: p)
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
    @data = Item
      .includes(:category, :image_attachment, :item_category, item_variation: [ :item_variation_value ])
      .by_perusahaan(@current_perusahaan.id)
      .find_by!(id: params[:id])

    render inertia: "master/item/edit", props: {
      categories: @categories,
      data: @data.as_json(include: [ :category, :item_category, item_variation: [ :item_variation_value ] ])
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

      # item categories
      @data.assign_attributes(item_category_params)
      @data.save!

      # item variations
      @data.assign_attributes(item_variation_params)
      @data.save!

      # item image
      if image_params[:image].present?
        @data.image.attach(
          key: "items/images/#{@data.id}/#{SecureRandom.uuid}",
          io: image_params[:image].tempfile,
          filename: image_params[:image].original_filename
        )
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
      @data.assign_attributes(item_params.merge(item_category_params.merge(item_variation_params)))
      @data.updated_by = @current_user.email
      @data.save!

      # delete image
      if image_params[:delete_image].present? && image_params[:delete_image] == "1"
        @data.image.purge
      end

      # attach image
      if image_params[:image].present?
        @data.image.attach(
          key: "items/images/#{@data.id}/#{SecureRandom.uuid}",
          io: image_params[:image].tempfile,
          filename: image_params[:image].original_filename
        )
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
    redirect_to search_param.merge(action: :show)
  end

  private
  def search_param
    params.permit(:q, :page, :per_page, c: [])
  end

  def item_params
    params.permit(:kode_item, :nama_item, :keterangan)
  end

  def image_params
    params.permit(:image, :delete_image)
  end

  def item_category_params
    params.permit(item_category_attributes: [ :id, :category_id, :_destroy ])
  end

  def item_variation_params
    params.permit(
      item_variation_attributes: [
        :id,
        :variation_name,
        item_variation_value_attributes: [
          :id,
          :variation_value,
          :additional_price
        ]
      ]
    )
  end
end
