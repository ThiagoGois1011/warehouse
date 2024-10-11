class WarehousesController < ApplicationController
  def show
    @warehouse = Warehouse.find(params[:id])
  end

  def new
  end

  def create
    warehouse_params = params.require(:warehouse).permit(:name, :code, :city, :description, :address,
                                                         :CEP, :area)
    w = Warehouse.new(warehouse_params)
    w.save()
    # flash[:notice] = 'Galpão cadastrado com sucesso.'
    redirect_to root_path, notice: 'Galpão cadastrado com sucesso.'
  end
end