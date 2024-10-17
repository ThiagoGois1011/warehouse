require 'rails_helper'

RSpec.describe Warehouse, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when name is empty' do
        #Arrange
        warehouse = Warehouse.new(name: '', code: 'RID', address: 'Endereço',
                                  CEP: '25000-000', city: 'Rio', area: 1000,
                                  description: 'Alguma descrição')
        #Act
        # resultado = warehouse.valid?
        #Assert
        expect(warehouse).not_to be_valid
      end
  
      it 'false when code is empty' do
        #Arrange
        warehouse = Warehouse.new(name: 'Rio', code: '', address: 'Endereço',
                                  CEP: '25000-000', city: 'Rio', area: 1000,
                                  description: 'Alguma descrição')
        #Act
        resultado = warehouse.valid?
        #Assert
        expect(resultado).to eq false
      end
  
      it 'false when address is empty' do
        #Arrange
        warehouse = Warehouse.new(name: 'Rio', code: 'RID', address: '',
                                  CEP: '25000-000', city: 'Rio', area: 1000,
                                  description: 'Alguma descrição')
        #Act
        resultado = warehouse.valid?
        #Assert
        expect(resultado).to eq false
      end
    end

    it 'false when code is already in use' do
      #Arrange
      first_warehouse = Warehouse.create(name: 'Rio', code: 'RID', address: 'Endereço',
                                        CEP: '25000-000', city: 'Rio', area: 1000,
                                        description: 'Alguma descrição')
      second_warehouse = Warehouse.new(name: 'Niteroi', code: 'RID', address: 'Avenida',
                                        CEP: '35000-000', city: 'Niteroi', area: 1500,
                                        description: 'Outra descrição')
      #Act
      result = second_warehouse.valid?
      #Assert
      expect(result).to eq false
    end
  end

  describe '#full_description' do
    it 'exibe o nome e o código' do
      #Arrange
      w = Warehouse.new(name: 'Galpão Cuiabá', code: 'CBA')
      #Act
      result = w.full_description
      #Assert
      expect(result).to eq 'CBA - Galpão Cuiabá'
    end
  end
end
