require 'pact/provider/rspec'

Pact.configure do |config|
  # config.rust_log_level = 5
  # config.logger.level = Logger::DEBUG
  # config.logger = Logger.new($stdout)
end

Pact.service_provider "Our Provider" do

  honours_pact_with 'Our Consumer' do
    pact_uri '../consumer/spec/pacts/Our Consumer-Our Provider.json'
  end

end

Pact.provider_states_for "Our Consumer" do

  provider_state "data count is > 0" do
    set_up do
      ProviderData.data_count = 1000
    end
  end

  provider_state "data count is == 0" do
    set_up do
      ProviderData.data_count = 0
    end
  end

end
