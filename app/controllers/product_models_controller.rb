class ProductModelsController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
    @product_models = ProductModel.all
  end

  def new
    @product_model = ProductModel.new
    @suppliers = Supplier.all
  end

  def create
    product_model_params = params.require(:product_model).permit(:name, :weight, :width, :height, :depth, :sku, :supplier_id)
    @product_model = ProductModel.new(product_model_params)

    if @product_model.save()
      redirect_to @product_model, notice: 'Modelo de produto cadastrado com sucesso.'
    else
      @suppliers = Supplier.all
      flash[:notice] = 'Não foi possível cadastrar o modelo de produto'
      render 'new'
    end
  end

  def show
    @product_model = ProductModel.find(params[:id])
  end
end