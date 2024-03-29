describe 'Product search page', type: :feature do
  fixtures :users
  fixtures :products
  fixtures :orders
  fixtures :topics
  fixtures :downloadables
  fixtures :line_items
  fixtures :images
  fixtures :visual_explorations
  fixtures :explorable_locations

  before do
    @product = products(:number_board)
    Product.reindex
  end

  context 'topics list' do
    before do
      @topic_1 = topics(:birds)
      @topic_2 = topics(:memory_game)
      @child_topic_1 = topics(:memory_quiz)
      @child_topic_2 = topics(:memory_puzzle)
    end

    it 'shows results indicator' do
      visit products_path
      link = "• #{@topic_1.name}"
      expect(page).to have_link link
      first(:link, link).click
      within '.status' do
        expect(page).to have_content '1 result'
        expect(page).not_to have_content 'results'
      end
    end
    it 'shows product presence indicator next to Topic names' do
      visit products_path
      expect(page).to have_link "• #{@topic_2.name}"
    end
    xit 'opens the tree node for active topic and highlights it', js: true do
      visit products_path
      expect(page).not_to have_content @child_topic_2.name
      click_link @topic_2.name
      expect(page).to have_content @child_topic_2.name.upcase
      expect(page).to have_selector('a.active', text: @topic_2.name.upcase)
    end
    context 'the topic has a description' do
      before { @topic_2.update(description: 'This is my topic') }
      it 'shows the topic description when clicked' do
        visit products_path
        expect(page).not_to have_content @topic_2.description
        first('a', text: @topic_2.name).click
        expect(page).to have_content @topic_2.description
      end
    end

    context 'the topic has a visual exploration' do
      before do
        @visual_exploration = visual_explorations(:room)
        @explorable_location = explorable_locations(:flamingo_in_room)
        @explorable_location2 = explorable_locations(:topic_in_room)
        @room_product = @explorable_location.explorable
        @topic_2.update(visual_exploration: @visual_exploration)
      end
      it 'shows the exploration when clicked' do
        visit products_path
        expect(page).not_to have_link('1', href: product_path(@room_product))
        first('a', text: @topic_2.name).click
        expect(page).to have_link('1', href: product_path(@room_product))
      end
    end
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

    context 'product is not sold by TMC' do
      before do
        @product.update(recommended_vendor_url: 'test.product.com')
      end
      it 'takes the user to the show page' do
        visit products_path
        expect(page).to have_content @product.name
        expect(page).to have_content @product.price
        expect(page).not_to have_css "#add-product-#{@product.id}"
        click_link "Shop Now"
        expect(page).to have_content 'Until we can offer'
      end
    end

    context 'product is an external resource' do
      before do
        @product.update(
          external_resource_url: 'test.external.com',
          list_cta_text: 'Heyro', show_cta_text: 'works'
        )
      end
      it 'takes the user to the show page' do
        visit products_path
        expect(page).to have_content @product.name
        expect(page).to have_content @product.price
        expect(page).not_to have_css "#add-product-#{@product.id}"
        click_link "Heyro"
        expect(page).to have_content 'works'
      end
    end
  end

  context 'search' do
    it 'does not show products that are not live' do
      visit products_path
      expect(page).not_to have_content 'Number Cards'
    end
    xcontext 'price range' do
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
    it 'can filter products' do
      visit products_path
      expect(page).to have_content 'Animal Cards'
      expect(page).to have_content 'Number Board'
      fill_in :q, with: 'animal'
      click_button 'Search'
      expect(page).to have_content 'Animal Cards'
      expect(page).not_to have_content 'Number Board'
    end
    context 'search by topics' do
      before do
        @no_presentation = products(:flamingo)
      end
      it 'shows all products without search options' do
        visit products_path
        expect(page).to have_content @no_presentation.name
        first(:link, Topic.first.name).click
        # the product with no presentation is not shown
        expect(page).not_to have_content @no_presentation.name
      end
      context 'other options are set' do
        before do
          @birds = topics(:birds)
          @ostrich = products(:ostrich)
          @memory = products(:memory_puzzle_card)
          @cards = products(:number_cards)
        end
        it 'persists topic selection when other options are set' do
          visit products_path
          first(:link, @birds.name).click
          expect(page).to have_content @ostrich.name
          select('Price: lowest first', :from => 'sort')
          expect(page).to have_content @ostrich.name
          # topic stays narrowed down to Birds
          expect(page).not_to have_content @cards.name
        end
        it 'clears the query with a new topic', :js do
          visit products_path
          expect(page).to have_content @ostrich.name.upcase
          expect(page).to have_content @memory.name.upcase
          fill_in :q, with: @memory.name.upcase
          click_button 'Search'
          expect(page).to have_content @memory.name.upcase
          expect(page).not_to have_content @ostrich.name.upcase

          all('.product-categories a')[1].click
          expect(page).to have_content @ostrich.name.upcase
          expect(page).not_to have_content @memory.name.upcase
        end
        it 'clears topic when new query' do
          visit products_path
          expect(page).to have_content @ostrich.name
          expect(page).to have_content @memory.name
          first(:link, @ostrich.topics.first.name).click
          expect(page).not_to have_content @memory.name
          fill_in :q, with: @memory.name
          click_button 'Search'
          expect(page).to have_content @memory.name
        end
      end
    end
    context 'free products' do
      before do
        allow_any_instance_of(Downloadable).to receive(:download_url)
          .and_return('my_downloadable_file.pdf')
      end
      context 'guest' do
        it 'is prompted to sign in' do
          visit products_path
          expect(page).to have_content 'Please sign in or register'
          expect(page).not_to have_link('Download',
                                        href: /my_downloadable_file/)
        end
      end
      context 'signed in user' do
        before do
          @user = users(:michelle)
          signin(@user.email, 'qawsedrf')
        end
        it 'shows download button' do
          visit products_path
          expect(page).not_to have_content 'Please sign in or register'
          expect(page).to have_link('Download', href: /my_downloadable_file/)
        end
      end
    end
  end

  context 'recently viewed' do
    it 'lists the recently viewed products' do
      # make sure the visited product is listed, but only once
      visit products_path
      expect(page).to have_content 'None yet.'
      visit product_path @product
      visit products_path
      within('#recently-viewed') do
        expect(page).to have_content @product.name
      end
    end

    context 'the recently viewed product no longer exists' do
      before do
        @tractor = products(:tractor)
      end
      it 'only lists the existing recently viewed' do
        visit products_path
        expect(page).to have_content 'None yet.'
        visit product_path @tractor
        @tractor.destroy
        visit product_path @product
        visit products_path
        within('#recently-viewed') do
          expect(page).to have_content @product.name
        end
      end
    end
  end
end
