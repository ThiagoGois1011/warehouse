require 'rails_helper'

describe 'Usuário edita um pedido' do
  it 'e não é o dono' do
    #Arrange
    joao = User.create!(name: 'João', email: 'joao@email.com', password: '12345678')
    andre = User.create!(name: 'Andre', email: 'andre@email.com', password: '12345678')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Avenida do Aeroporto, 1000', CEP: '15000-000',
                                  description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', restration_number: '79458216100152',
                    full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendas@spark.com.br')

    order1 = Order.create!(user: joao, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)

    #Act
    login_as(andre)
    patch(order_path(order1.id), params: {order: {supplier_id: 3}})

    #Assert
    expect(response).to redirect_to(root_path)
  end

end