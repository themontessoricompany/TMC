require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  fixtures :products

  let(:number_cards)  { products(:number_cards) }

  describe '#show' do
    before            { get :show, id: number_cards.id }

    it { expect(response).to render_template('products/show') }
  end

end
