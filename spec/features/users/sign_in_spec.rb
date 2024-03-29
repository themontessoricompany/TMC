describe 'Sign in', :devise do
  fixtures :users
  fixtures :orders

  let(:michelle)         { users(:michelle) }
  let(:unassigned_order) { orders(:unassigned_order) }

  it 'user cannot sign in if not registered' do
    signin('nobody@tmc.com', 'qawsedrf')
    expect(page).to have_content(I18n.t('devise.failure.not_found_in_database',
                                        authentication_keys: 'email')
                                )
  end

  it 'user can sign in with valid credentials' do
    signin(michelle.email, 'qawsedrf')
    expect(page).to have_content(I18n.t('devise.sessions.signed_in'))
    expect(page).to have_current_path(root_path)
  end

  it 'redirect user to order page if user came from order page' do
    visit order_path(unassigned_order)
    click_on('Log in')

    fill_sign_in_form(michelle.email, 'qawsedrf')
    click_button('Log in')

    expect(page).to have_content(I18n.t('devise.sessions.signed_in'))
    expect(page).to have_current_path '/'
  end
end
