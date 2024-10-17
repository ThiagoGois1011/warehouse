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
end
