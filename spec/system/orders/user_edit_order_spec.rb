require 'rails_helper'

describe 'Usuário edita pedido' do
  it 'e deve estar autenticado' do
    #Arrange
    joao = User.create!(name: 'João', email: 'joao@email.com', password: '12345678')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Avenida do Aeroporto, 1000', CEP: '15000-000',
                                  description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', restration_number: '79458216100152',
                    full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendas@spark.com.br')
    
    order1 = Order.create!(user: joao, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    
    #Act
    visit edit_order_path(order1.id)

    #Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
    #Arrange
    joao = User.create!(name: 'João', email: 'joao@email.com', password: '12345678')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Avenida do Aeroporto, 1000', CEP: '15000-000',
                                  description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', restration_number: '79458216100152',
                    full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendas@spark.com.br')
    Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', restration_number: '79458216100152',
                    full_address: 'Torre da Fabrica, 20', city: 'Teresina', state: 'PI', email: 'contato@acme.com.br')

    order1 = Order.create!(user: joao, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)

    #Act
    login_as(joao)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order1.code
    click_on 'Editar'
    fill_in 'Data Prevista de Entrega', with: 1.day.from_now.to_date
    select 'Spark Industries Brasil LTDA', from: 'Fornecedor'
    click_on 'Gravar'

    #Assert
    expect(page).to have_content 'Pedido atualizado com sucesso.'
    expect(page).to have_content 'Fornecedor: Spark Industries Brasil LTDA'
    expect(page).to have_content 'Data Prevista de Entrega: ' + I18n.localize(1.day.from_now.to_date)
  end

  it 'caso seja o responsável' do
    #Arrange
    joao = User.create!(name: 'João', email: 'joao@email.com', password: '12345678')
    andre = User.create!(name: 'andre', email: 'andre@email.com', password: '12345678')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Avenida do Aeroporto, 1000', CEP: '15000-000',
                                  description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', restration_number: '79458216100152',
                    full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendas@spark.com.br')
    
    order1 = Order.create!(user: joao, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    
    #Act
    login_as(andre)
    visit edit_order_path(order1.id)

    #Assert
    expect(current_path).to eq root_path
  end
end