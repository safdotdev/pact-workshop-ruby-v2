# frozen_string_literal: true

require 'pact/v2/rspec'
require './lib/provider'

describe Provider, :pact do
  http_pact_provider 'Our Provider', opts: {
    app: Provider,
    http_port: 9292,
    pact_dir: File.expand_path('../../../../consumer/pacts', __dir__)
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
