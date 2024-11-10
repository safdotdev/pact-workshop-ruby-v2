# frozen_string_literal: true

require 'sbmt/pact/rspec'
require './lib/provider'

RSpec.describe 'Sbmt::Pact::Consumers::Http', :pact do
  http_pact_provider 'Our Provider'
  # puts pact_config.inspect
  pact_config.instance_variable_set(:@app, Provider)
  pact_config.instance_variable_set(:@http_port, 9292)

  pact_config.instance_variable_set(:@pact_dir,
                                    File.expand_path('../../../../consumer/spec/internal/pacts', __dir__))

  provider_state 'data count is > 0' do
    set_up do
      ProviderData.data_count = 1000
    end
  end

  provider_state 'data count is == 0' do
    set_up do
      ProviderData.data_count = 0
    end
  end
end
