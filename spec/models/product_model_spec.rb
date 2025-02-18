require 'rails_helper'

RSpec.describe ProductModel, type: :model do
  describe '#valid?' do
    it 'name is mandatory' do
    supplier = Supplier.create!(brand_name: 'Samsung', corporate_name: 'Samsung Eletronicos LTDA',
                                restration_number: '07317108000151', 
                                full_address: 'Av Nacoes Unidas, 1000', 
                                city: 'São Paulo' , state: 'SP', email: 'sac@samsung.combr')
    pm = ProductModel.new(name: '', weight: 8000, width: 70, height: 45, depth: 10,
                         sku: 'TV32-SANSU-XPTO90', supplier: supplier)

    result = pm.valid?

    expect(result).to eq false
    end

    it 'sku is mandatory' do
    supplier = Supplier.create!(brand_name: 'Samsung', corporate_name: 'Samsung Eletronicos LTDA',
                                restration_number: '07317108000151', 
                                full_address: 'Av Nacoes Unidas, 1000', 
                                city: 'São Paulo' , state: 'SP', email: 'sac@samsung.combr')
    pm = ProductModel.new(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10,
                         sku: '', supplier: supplier)

    result = pm.valid?

    expect(result).to eq false
    end
  end
end
