require 'rails_helper'
require 'stripe_mock'

RSpec.describe ChargesController, type: :controller do
  fixtures :users
  fixtures :orders
  fixtures :products
  fixtures :line_items
  fixtures :charges

  let(:michelle)         { users(:michelle) }
  let(:cards_order)      { orders(:cards_order) }
  let(:cards_charge)     { charges(:cards_charge) }

  describe '#show' do
    before do
      get :show, order_id: cards_order.id, id: cards_charge.id
    end

    it { expect(response).to render_template('charges/show') }
  end

  describe '#new' do
    before do
      get :new, order_id: cards_order.id
    end

    it {expect(response).to render_template('charges/new') }
  end

  describe '#create' do
    include_context 'before_after_mailer'

    let(:stripe_helper) { StripeMock.create_test_helper }

    let(:stripeParams)  { { stripeEmail: michelle.email,
                            stripeToken: stripe_helper.generate_card_token
                          }
                        }

    before { StripeMock.start }
    after { StripeMock.stop }

    it 'completed order' do
      expect{
        post :create, order_id: cards_order.id, params: stripeParams
      }.to change{ Order.first.state }.from('active').to('paid')
    end

    context 'sending confimed_order email' do
      before { post :create, order_id: cards_order.id, params: stripeParams }

      it 'email was delivered' do
        expect(ActionMailer::Base.deliveries.count).to eq(1)
      end
    end
  end
end
