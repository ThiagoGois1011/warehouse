require 'rails_helper'

RSpec.describe StockProduct, type: :model do

  describe 'gera um número de série' do
    it 'ao criar um StockProduct' do
      #Assert
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                    address: 'Avenida do Aeroporto, 1000', CEP: '15000-000',
                                      description: 'Galpão destinado para cargas internacionais')
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', restration_number: '43447216000102',
                                  full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')

      order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now, status: :delivered)
      product = ProductModel.create!(supplier: supplier, name: 'Cadeira Gamer', weight: 5,
                                   height: 100, width: 70, depth: 75, sku: 'CAD-GAMER-1234')
      #Act
      stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product )  
      #Assert  
      expect(stock_product.serial_number.length).to eq  20                           
    end

    it 'e não é modificado' do
      #Assert
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                    address: 'Avenida do Aeroporto, 1000', CEP: '15000-000',
                                      description: 'Galpão destinado para cargas internacionais')
      other_warehouse = Warehouse.create!(name: 'SP - BA', code: 'CAR', city: 'Várzea Nova', area: 200_000,
                                    address: 'Avenida do Calçadão, 100', CEP: '30000-000',
                                      description: 'Galpão BA')
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', restration_number: '43447216000102',
                                  full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')

      order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now, status: :delivered)
      product = ProductModel.create!(supplier: supplier, name: 'Cadeira Gamer', weight: 5,
                                   height: 100, width: 70, depth: 75, sku: 'CAD-GAMER-1234')
      stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product )  
      original_serial_number = stock_product.serial_number
      #Act
      stock_product.update(warehouse: other_warehouse)
      #Assert  
      expect(stock_product.serial_number).to eq original_serial_number                           
    end
  end
end
