describe DirectoryController, type: :request do

  describe '#index' do
    before do
      @user = create(:user, opted_in_to_public_directory: true)
    end
    it 'returns users in requested format' do
      get '/directory.json'
      profile = response_json['profiles'][0]
      expect(profile['first_name']).to eq 'Jane'
      expect(profile['email']).to be_nil
    end
  end
end
