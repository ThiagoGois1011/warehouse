require 'rails_helper'

describe 'Usuário vê seus próprios pedidos' do
  it 'e deve estar autenticado' do
    #Arrange 
    #Act
    visit root_path
    click_on 'Meus Pedidos'
    #Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'e não vê outros pedidos' do
    #Arrange
    sergio = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
    joao = User.create!(name: 'João', email: 'joao@email.com', password: '12345678')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Avenida do Aeroporto, 1000', CEP: '15000-000',
                                  description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', restration_number: '79458216100152',
                    full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendas@spark.com.br')
    
    order1 = Order.create!(user: sergio, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    order2 = Order.create!(user: joao, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    order3 = Order.create!(user: sergio, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
                                    
    #Act

    login_as(sergio)
    visit root_path
    click_on 'Meus Pedidos'

    #Assert

    expect(page).to have_content order1.code
    expect(page).not_to have_content order2.code
    expect(page).to have_content order3.code
  end
end