require 'rails_helper'

describe 'Usuário busca por um pedido' do
  it 'a partir do menu' do
    #Arrange
    user = User.create!(name: 'João', email: 'joao@email.com', password: 'password')
    #Act
    login_as(user)
    visit root_path

    #Assert 
    within('header nav') do
      expect(page).to have_field('Buscar Pedido')
      expect(page).to have_button('Buscar')
    end
  end

  it 'e deve estar autenticado' do
    #Arrange
    
    #Act
    
    visit root_path

    #Assert 
    within('header nav') do
      expect(page).not_to have_field('Buscar Pedido')
      expect(page).not_to have_button('Buscar')
    end
  end

  it 'e encontra um pedido' do
    #Arrange
    user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Avenida do Aeroporto, 1000', CEP: '15000-000',
                                  description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', restration_number: '79458216100152',
                    full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendas@spark.com.br')
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
 
    #Act 
    login_as(user)
    visit root_path
    fill_in 'Buscar Pedido', with: order.code
    click_on 'Buscar'

    #Assert
    expect(page).to have_content "Resultados da Busca por: #{order.code}"
    expect(page).to have_content '1 pedido encontrado'
    expect(page).to have_content "Código: #{order.code}"
    expect(page).to have_content 'Galpão Destino: GRU - Aeroporto SP'
    expect(page).to have_content 'Fornecedor: Spark Industries Brasil LTDA'

  end

  it 'e encontra múltiplos pedidos' do
    #Arrange
    user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
    warehouse1 = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Avenida do Aeroporto, 1000', CEP: '15000-000',
                                  description: 'Galpão destinado para cargas internacionais')
    warehouse2 = Warehouse.create!(name: 'Aeroporto Rio', code: 'SDU', city: 'Guarulhos', area: 100_000,
                                  address: 'Avenida do Porto, 500', CEP: '55000-000',
                                  description: 'Galpão destinado para Rio')
    supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', restration_number: '79458216100152',
                    full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendas@spark.com.br')
    
    allow(SecureRandom).to receive(:alphanumeric).and_return('GRU12345')
    order1 = Order.create!(user: user, warehouse: warehouse1, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    allow(SecureRandom).to receive(:alphanumeric).and_return('GRU98765')
    order2 = Order.create!(user: user, warehouse: warehouse1, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    allow(SecureRandom).to receive(:alphanumeric).and_return('SDU00000')
    order3 = Order.create!(user: user, warehouse: warehouse2, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    #Act 
    login_as(user)
    visit root_path
    fill_in 'Buscar Pedido', with: 'GRU'
    click_on 'Buscar'
    #Assert
    expect(page).to have_content '2 pedidos encontrados'
    expect(page).to have_content 'GRU12345'
    expect(page).to have_content 'GRU98765'
    expect(page).to have_content 'Galpão Destino: GRU - Aeroporto SP'
    expect(page).not_to have_content 'Galpão Destino: SDU - Aeroporto Rio'
    expect(page).not_to have_content 'SDU00000'
    
  end
end