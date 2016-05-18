describe 'Product search page', type: :feature do
  fixtures :users
  fixtures :products
  fixtures :orders

  before do
    @product = products(:number_board)
  end

  context 'adding a product to cart' do
    it 'takes the user to the cart summary' do
      visit products_path
      expect(page).to have_content @product.name
      expect(page).to have_content @product.price
      find("#add-product-#{@product.id}").click
      expect(page).to have_content 'Your Cart'
      expect(page).to have_css('h5', text: @product.name)
      # check we can't add it again, instead show the right message
      visit products_path @product
      expect(page).not_to have_css "#add-product-#{@product.id}"
      expect(page).to have_content 'Already in your cart'
    end
  end

  context 'search' do
    context 'price range' do
      it 'persists the setting and shows the correct results', js: true do
        visit products_path
        page.execute_script("$('#price-range').val('11;33');")
        find("#search-button").click
        expect(page).to have_css('.irs-from', text: '$11')
        expect(page).to have_css('.irs-to', text: '$33')
        expect(page).to have_content 'Number Board'.upcase
        expect(page).to have_content 'Animal Cards'.upcase
        # do not include the product with price $10
        expect(page).not_to have_content 'Number Cards'.upcase
      end
    end
    context 'search by topics' do
      before do
        @no_presentation = products(:flamingo)
      end
      it 'shows all products without search options' do
        visit products_path
        expect(page).to have_content @no_presentation.name
        click_link Topic.first.name
        # the product with no presentation is not shown
        expect(page).not_to have_content @no_presentation.name
      end
    end
  end

  context 'recently viewed' do
    it 'lists the recently viewed products' do
      # make sure the visited product is listed, but only once
      visit products_path
      expect(page).to have_content 'None yet :('
      visit product_path @product
      click_link 'Back to search'
      within('#recently-viewed') do
        expect(page).to have_content @product.name
      end
    end
  end
end
