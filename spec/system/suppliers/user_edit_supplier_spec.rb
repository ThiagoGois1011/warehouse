require 'rails_helper'

describe 'Usuário edita um fornecedor' do
  it 'a partir da página de detalhes' do
    #Arrange
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', restration_number: '43447216000102',
                                 full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')
    #Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'ACME'
    click_on 'Editar'
    #Assert

    expect(page).to have_field('Nome Fantasia' , with: 'ACME LTDA')
    expect(page).to have_field('Razão Social', with: 'ACME')
    expect(page).to have_field('CNPJ', with: '43447216000102')
    expect(page).to have_field('Endereço', with: 'Av das Palmas, 100')
    expect(page).to have_field('Cidade', with: 'Bauru')
    expect(page).to have_field('Estado', with: 'SP')
    expect(page).to have_field('E-mail', with: 'contato@acme.com')
  end

  it 'com sucesso' do
    #Arrange
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', restration_number: '43447216000102',
                                 full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')
    #Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'ACME'
    click_on 'Editar'
    fill_in 'Nome Fantasia', with: 'SERASA LTDA'
    fill_in 'Razão Social', with: 'SERASA'
    fill_in 'CNPJ', with: '95445216660122'
    fill_in 'Endereço', with: 'Avenida dos Galpôes, 500'
    fill_in 'Cidade', with: 'Várzea Nova'
    fill_in 'Estado', with: 'BH'
    fill_in 'E-mail', with: 'contato@serasa.com'
    click_on 'Enviar'
    #Assert
    expect(page).to have_content 'Fornecedor atualizado com sucesso.'
    expect(page).to have_content 'SERASA'
    expect(page).to have_content 'Nome Fantasia: SERASA LTDA'
    expect(page).to have_content 'Endereço: Avenida dos Galpôes, 500 - Várzea Nova - BH'
    expect(page).to have_content 'Documento: 95445216660122'
    expect(page).to have_content 'E-mail: contato@serasa.com'
    
  end

  it 'e mantém os campos obrigatórios' do
    #Arrange
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', restration_number: '43447216000102',
                                 full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')
    #Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'ACME'
    click_on 'Editar'
    fill_in 'Nome Fantasia', with: ''
    fill_in 'Razão Social', with: ''
    fill_in 'Endereço', with: ''
    click_on 'Enviar'
    #Assert
    expect(page).to have_content 'Não foi possível atualizar o fornecedor.'
  end
end