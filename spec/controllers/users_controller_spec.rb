describe UsersController, type: :controller do
  fixtures :users

  describe '#update' do
    before do
      @user = users(:michelle)
    end
    context 'signed in user' do
      before do
        sign_in @user
      end
      context 'changing password' do
        context 'passwords match' do
          it 'updates the user' do
            old_password = @user.encrypted_password
            patch :update, id: @user, user: {
              password: 'abc123456', password_confirmation: 'abc123456'
            }
            expect(@user.reload.encrypted_password).not_to eq old_password
          end
        end
        context 'passwords do not match' do
          it 'does not update the user' do
            old_password = @user.encrypted_password
            patch :update, id: @user, user: {
              password: 'a', password_confirmation: ''
            }
            expect(@user.reload.encrypted_password).to eq old_password
          end
        end
      end
      context 'changing email address' do
        it 'updates the user' do
          patch :update, id: @user, user: { email: 'bill@murray.com' }
          expect(@user.reload.email).to eq 'bill@murray.com'
          expect(ActionMailer::Base.deliveries.count).to eq 0
        end
      end
    end
    context 'guest' do
      it 'does not allow the update' do
        old_email = @user.email
        patch :update, id: @user, user: { email: 'bill@murray.com' }
        expect(@user.reload.email).to eq old_email
        expect(response.status).to eq 302
      end
    end
  end
end