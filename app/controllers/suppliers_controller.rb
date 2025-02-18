class SuppliersController < ApplicationController
  before_action :set_supplier, only: [:show, :edit, :update]
  def index
    @suppliers = Supplier.all
  end

  def new
    @supplier = Supplier.new
  end

  def create
    @supplier = Supplier.new(supplier_params)

    if @supplier.save
      redirect_to @supplier, notice: 'Fornecedor cadastrado com sucesso'
    else
      flash[:notice] = 'Fornecedor não cadastrado'
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @supplier.update(supplier_params)
      redirect_to @supplier, notice: 'Fornecedor atualizado com sucesso.'
    else
      flash[:notice] = 'Não foi possível atualizar o fornecedor.'
      render 'edit'
    end
  end

  private

  def set_supplier
    @supplier = Supplier.find(params[:id])
  end

  def supplier_params
    params.require(:supplier).permit(:corporate_name, :brand_name, :city, :state, :full_address, :restration_number, :email)
  end
end