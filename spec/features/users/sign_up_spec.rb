describe 'Sign up', :feature do
  include_context 'before_after_mailer'

  before { Sidekiq::Testing.inline!  }

  context 'registration', js: true do
    it 'sends the welcome email and logs in the user' do
      visit new_user_registration_path
      fill_in 'user[email]', with: 'my@email.com'
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
      click_button 'Sign up'
      expect(page).to have_content 'Welcome! You have signed up'
      expect(ActionMailer::Base.deliveries.count).to eq 1
      email = ActionMailer::Base.deliveries.first
      expect(email.subject).to eq 'Welcome to The Montessori Company'
      visit root_path
      expect(page).to have_link 'Logout'
    end
  end
end
