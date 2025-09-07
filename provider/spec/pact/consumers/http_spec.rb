# frozen_string_literal: true

require 'sbmt/pact/rspec'
require './lib/provider'

RSpec.describe 'Sbmt::Pact::Consumers::Http', :pact_v2 do
  http_pact_provider 'Our Provider', opts: {
    app: Provider,
    http_port: 9292,
    pact_dir: File.expand_path('../../../../consumer/spec/pacts', __dir__)
  }

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
