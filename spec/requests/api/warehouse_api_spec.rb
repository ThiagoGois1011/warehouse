require 'rails_helper'

describe 'Warehouse API' do
  context 'GET /api/v1/warehouses/1' do
    it 'success' do
      #Arrange
      warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                    address: 'Avenida do Aeroporto, 1000', CEP: '15000-000',
                                    description: 'Galpão destinado para cargas internacionais')
      #Act
      get "/api/v1/warehouses/#{warehouse.id}"
  
      #Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response["name"]).to include('Aeroporto SP')
      expect(json_response["code"]).to include('GRU')
      expect(json_response.keys).not_to include('created_at')
      expect(json_response.keys).not_to include('updated_at')
    end

    it 'fail if warehouse not found' do
      #Arrange

      #Act
      get "/api/v1/warehouses/99999"
      #Assert
      expect(response.status).to eq 404
    end
  end

  context 'GET /api/v1/warehouses' do
    it 'list all warehouses ordered by name' do
      #Arrange
      Warehouse.create!(name: 'Rio', code: 'RID', address: 'Endereço',
                                CEP: '25000-000', city: 'Rio', area: 1000,
                                description: 'Alguma descrição')
      Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                    address: 'Avenida do Aeroporto, 1000', CEP: '15000-000',
                                    description: 'Galpão destinado para cargas internacionais')
      #Act
      get "/api/v1/warehouses"

      #Arrange

      expect(response.status).to eq 200
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response.length).to eq 2 
      expect(json_response[0]["name"]).to eq 'Aeroporto SP'
      expect(json_response[1]["name"]).to eq 'Rio'
    end

    it 'return empty if there is no warehouse' do
      #Arrange

      #Act
      get "/api/v1/warehouses"

      #Arrange

      expect(response.status).to eq 200
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response).to eq []
    end

    it 'and raise internal error' do
      #Arrage
      allow(Warehouse).to receive(:all).and_raise(ActiveRecord::QueryCanceled)
      #Act
      get "/api/v1/warehouses"
      #Assert
      expect(response).to have_http_status(500)
    end
  end

  context 'POST /api/v1/warehouses' do
    it 'success' do
      #Arrage
      warehouse_params = {warehouse: { name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                          address: 'Avenida do Aeroporto, 1000', CEP: '15000-000',
                          description: 'Galpão destinado para cargas internacionais' }}
      #Act
      post '/api/v1/warehouses', params: warehouse_params
      #Assert
      expect(response).to have_http_status(201)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response["name"]).to eq 'Aeroporto SP'
      expect(json_response["code"]).to eq 'GRU'
      expect(json_response["city"]).to eq 'Guarulhos'
      expect(json_response["area"]).to eq 100_000
      expect(json_response["address"]).to eq 'Avenida do Aeroporto, 1000'
      expect(json_response["CEP"]).to eq '15000-000'
      expect(json_response["description"]).to eq 'Galpão destinado para cargas internacionais'
    end

    it 'fail if parameters are not complete' do
      #Arrange
      warehouse_params = { warehouse: {name: "Aeroporto Curitiba", code: "CWB" } }
      #Act
      post '/api/v1/warehouses', params: warehouse_params
      #Assert
      expect(response).to have_http_status(412)
      expect(response.body).not_to include('Nome não pode ficar em branco')
      expect(response.body).not_to include('Código não pode ficar em branco')
      expect(response.body).to include('Cidade não pode ficar em branco')
      expect(response.body).to include('Endereço não pode ficar em branco')
    end

    it 'fail if theres an internal error' do
      #Arrage
      allow(Warehouse).to receive(:new).and_raise(ActiveRecord::ActiveRecordError)

      warehouse_params = {warehouse: { name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                          address: 'Avenida do Aeroporto, 1000', CEP: '15000-000',
                          description: 'Galpão destinado para cargas internacionais' }}
      #Act
      post '/api/v1/warehouses', params: warehouse_params
      #Assert
      expect(response).to have_http_status(500)
    end
  end
end