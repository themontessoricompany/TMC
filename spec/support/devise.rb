RSpec.configure do |config|
  config.include(Devise::TestHelpers, type: :controller)
  config.include(Devise::TestHelpers, type: :view)
  config.include(Devise::TestHelpers, type: :helper)
end
