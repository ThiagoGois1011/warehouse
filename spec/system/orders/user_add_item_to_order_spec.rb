require 'rails_helper'

describe 'Usuário adiciona itens ao pedido' do
  it 'com sucesso' do
    #Arrange
    user = User.create!(name: 'João', email: 'joao@email.com', password: '12345678')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Avenida do Aeroporto, 1000', CEP: '15000-000',
                                  description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', restration_number: '79458216100152',
                    full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendas@spark.com.br')
    
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    product_a = ProductModel.create!(name: 'Produto A', weight: 15, width: 10, height: 20,
                                     depth: 30, supplier: supplier, sku: 'PRODUTO-A')
    product_b = ProductModel.create!(name: 'Produto B', weight: 15, width: 10, height: 20,
                                     depth: 30, supplier: supplier, sku: 'PRODUTO-B')
    #Act
    login_as user
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Adicionar Item'

    select 'Produto A', from: 'Produto'
    fill_in 'Quantidade', with: '8'
    click_on 'Gravar'

    #Assert
    expect(current_path).to eq order_path(order.id)
    expect(page).to have_content 'Item adicionado com sucesso'
    expect(page).to have_content '8 x Produto A'
  end

  it 'e não vê produtos de outro fornecedor' do
    #Arrange
    user = User.create!(name: 'João', email: 'joao@email.com', password: '12345678')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Avenida do Aeroporto, 1000', CEP: '15000-000',
                                  description: 'Galpão destinado para cargas internacionais')
    supplier_a = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', restration_number: '79458216100152',
                    full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendas@spark.com.br')
    supplier_b = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', restration_number: '79455326100152',
                    full_address: 'Torre da Fabrica, 1', city: 'Vh', state: 'PI', email: 'contato@acme.com.br')

    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier_a, estimated_delivery_date: 1.day.from_now)
    product_a = ProductModel.create!(name: 'Produto A', weight: 15, width: 10, height: 20,
                                    depth: 30, supplier: supplier_a, sku: 'PRODUTO-A')
    product_b = ProductModel.create!(name: 'Produto B', weight: 15, width: 10, height: 20,
                                 depth: 30, supplier: supplier_b, sku: 'PRODUTO-B')
    #Act
    login_as user
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Adicionar Item'
    #Assert

    expect(page).to have_content 'Produto A'
    expect(page).not_to have_content 'Produto B'
    end


end