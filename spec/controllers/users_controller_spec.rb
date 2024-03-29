describe UsersController, type: :controller do
  fixtures :users
  fixtures :interests
  fixtures :certifications

  include_context 'before_after_mailer'

  before do
    @user = users(:michelle)
  end

  describe '#show' do
    context 'signed in user' do
      before { sign_in @user }
      it 'redirects to user materials' do
        get :show, id: @user.id
        expect(response).to redirect_to user_materials_path(@user)
      end
    end
    context 'guest' do
      it 'redirects to safety' do
        get :show, id: @user.id
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#update' do
    context 'signed in user' do
      before { sign_in @user }
      context 'changing password' do
        context 'passwords match' do
          it 'updates the user' do
            old_password = @user.encrypted_password
            patch :update, id: @user, user: {
              password: 'abc123456', password_confirmation: 'abc123456'
            }, commit: 'Save'
            expect(@user.reload.encrypted_password).not_to eq old_password
            expect(ActionMailer::Base.deliveries.count).to eq 0
          end
        end
        context 'passwords do not match' do
          it 'does not update the user' do
            old_password = @user.encrypted_password
            patch :update, id: @user, user: {
              password: 'a', password_confirmation: ''
            }, commit: 'save'
            expect(@user.reload.encrypted_password).to eq old_password
          end
        end
      end
      context 'changing email address' do
        it 'updates the user' do
          patch :update, id: @user, user: { email: 'bill@murray.com' },
            commit: 'Save'
          expect(@user.reload.email).to eq 'bill@murray.com'
          expect(ActionMailer::Base.deliveries.count).to eq 0
        end
      end
      context 'signing up for bambini pilot' do
        it 'sends the user to mailchimp' do
          request.env["HTTP_REFERER"] = root_path
          expect(MailchimpSubscriberWorker)
            .to receive(:perform_async).with('bill@murray.com', 'c94cda6346')
          patch :update, id: @user, user: { email: 'bill@murray.com' },
            commit: 'Join Pilot'
        end
      end
      context 'with interests' do
        before do
          @interest = interests(:peace)
        end
        context 'public' do
          it 'updates a user with the interest' do
            patch :update, id: @user, user: {
              email: 'bill@murray.com',
              interests: ['Peace']
            }, commit: 'Save'
            expect(@user.reload.interests.pluck(:name).include?('Peace'))
              .to eq true
          end
        end
        context 'private' do
          before do
            @interest.update(public: false)
          end
          it 'creates the private interest' do
            patch :update, id: @user, user: {
              email: 'bill@murray.com',
              interests: ['Peace']
            }, commit: 'Save'
            expect(@user.reload.interests.pluck(:name).include?('Peace'))
              .to eq true
            expect(Interest.find_by(name: 'Peace').public).to eq false
          end
        end
        context 'no interests' do
          it 'does not add the interest to user interest list' do
            patch :update, id: @user, user: {
              email: 'bill@murray.com',
              interests: []
            }, commit: 'Save'
            expect(@user.reload.interests.blank?).to eq true
          end
        end
      end
      context 'with certifications' do
        before do
          @certification = certifications(:ami)
        end
        context 'public' do
          it 'updates a user with the certification' do
            patch :update, id: @user, user: {
              email: 'bill@murray.com',
              certifications: ['AMI']
            }, commit: 'Save'
            expect(@user.reload.certifications.pluck(:name).include?('AMI'))
              .to eq true
          end
        end
        context 'private' do
          before do
            @certification.update(public: false)
          end
          it 'creates the private certification' do
            patch :update, id: @user, user: {
              email: 'bill@murray.com',
              certifications: ['AMI']
            }, commit: 'Save'
            expect(@user.reload.certifications.pluck(:name).include?('AMI'))
              .to eq true
            expect(Certification.find_by(name: 'AMI').public).to eq false
          end
        end
        context 'no certifications' do
          it 'does not add the certification to user certification list' do
            patch :update, id: @user, user: {
              email: 'bill@murray.com',
              certifications: []
            }, commit: 'Save'
            expect(@user.reload.certifications.blank?).to eq true
          end
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
