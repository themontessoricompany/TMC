describe "products/show" do
  fixtures :products
  fixtures :orders

  let(:number_cards) { products(:number_cards) }
  let(:cards_order)    { orders(:cards_order) }

  context 'product show page' do
    before do
      assign(:order, Order.find(cards_order.id))
      assign(:product, Product.find(number_cards.id))
      assign(:results, Product.all)
      render
    end

    it "displays product's name correctly" do
      expect(rendered).to match number_cards.name
      expect(rendered).to match(/card's/)
    end
  end
end
