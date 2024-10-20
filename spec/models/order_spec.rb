require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#description' do
    it 'exibe nome e email' do
      #Arrange
      u = User.new(name: 'Julia Almeida', email:'julia@yahoo.com')
      #Act
      result = u.description
      #Assert
      expect(result).to eq 'Julia Almeida - julia@yahoo.com'
    end
  end

  describe '#valid?' do
    it 'deve ter um código' do
       #Arrange
       user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
       warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                     address: 'Avenida do Aeroporto, 1000', CEP: '15000-000',
                                       description: 'Galpão destinado para cargas internacionais')
       supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', restration_number: '43447216000102',
                                   full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')
 
       order = Order.new(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
 
       #Act
       result = order.valid?

       #Assert
       expect(result).to be true
    end

    it 'data estimada de entraga deve ser obrigatória' do
      #Arrange
      order = Order.new(estimated_delivery_date: '')

      #Act
      order.valid?
      result = order.errors.include?(:estimated_delivery_date)
      #Assert
      expect(result).to be true
    end

    it 'data estimada de entraga não deve ser passada' do
      #Arrange
      order = Order.new(estimated_delivery_date: 1.day.ago)

      #Act
      order.valid?
      result = order.errors.include?(:estimated_delivery_date)
      #Assert
      expect(result).to be true
      expect(order.errors[:estimated_delivery_date]).to include(' deve ser futura.')
    end

    it 'data estimada de entraga não deve ser igual a hoje' do
      #Arrange
      order = Order.new(estimated_delivery_date: Date.today)

      #Act
      order.valid?
      result = order.errors.include?(:estimated_delivery_date)
      #Assert
      expect(result).to be true
      expect(order.errors[:estimated_delivery_date]).to include(' deve ser futura.')
    end

    it 'data estimada de entraga deve ser igual ou maior que amanhã' do
      #Arrange
      order = Order.new(estimated_delivery_date: 1.day.from_now)

      #Act
      order.valid?
      result = order.errors.include?(:estimated_delivery_date)
      #Assert
      expect(result).to be false
    end
  end

  describe 'gera um código aleatório' do
    it 'ao criar um novo pedido' do
      #Arrange
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                    address: 'Avenida do Aeroporto, 1000', CEP: '15000-000',
                                      description: 'Galpão destinado para cargas internacionais')
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', restration_number: '43447216000102',
                                  full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')

      order = Order.new(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)

      #Act

      order.save!
      result = order.code

      #Assert

      expect(result).not_to be_empty
      expect(result.length).to eq 8
    
    end

    it 'e o código é único' do
      #Arrange
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                    address: 'Avenida do Aeroporto, 1000', CEP: '15000-000',
                                      description: 'Galpão destinado para cargas internacionais')
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', restration_number: '43447216000102',
                                  full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')

      first_order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
      second_order = Order.new(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)

      #Act
      second_order.save!
      #Assert
      expect(second_order.code).not_to eq first_order.code
    
    end

    it 'e não deve ser modificado' do
      #Arrange
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                    address: 'Avenida do Aeroporto, 1000', CEP: '15000-000',
                                      description: 'Galpão destinado para cargas internacionais')
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', restration_number: '43447216000102',
                                  full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')

      order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
      original_code = order.code
      #Act
      order.update(estimated_delivery_date: 1.month.from_now)
      #Assert
      expect(order.code).to eq original_code
    end

  end
end
