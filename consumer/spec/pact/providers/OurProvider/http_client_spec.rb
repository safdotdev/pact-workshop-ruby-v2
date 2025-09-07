# frozen_string_literal: true

require 'sbmt/pact/rspec'
require 'client'
URI::Parser.new
RSpec.describe 'Sbmt::Pact::Providers::Test::HttpClient', :pact_v2 do
  has_http_pact_between 'Our Consumer', 'Our Provider'

  let(:json_data) do
    {
      'test' => 'NO',
      'valid_date' => '2013-08-16T15:31:20+10:00',
      'count' => 100
    }
  end
  let(:response) { double('Response', success?: true, body: json_data.to_json) }
  subject { Client.new('localhost:3000') }

  it 'can process the json payload from the provider' do
    allow(HTTParty).to receive(:get).and_return(response)
    expect(subject.process_data(Time.now.httpdate)).to eql([1, Time.parse(json_data['valid_date'])])
  end

  describe 'Pact with our provider' do
    let(:interaction) { new_interaction }

    # subject { Client.new('localhost:3000') }
    let(:date) { Time.now.httpdate }

    describe 'get json data' do
      let(:interaction) do
        super()
          .given('data count is > 0')
          .upon_receiving('a request for json data')
          .with_request(:get, '/provider.json', query: { 'valid_date' => date })
          .will_respond_with(200, body: {
                           'test' => 'NO',
                           'valid_date' => match_regex(
                             /\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\+\d{2}:\d{2}/,
                             '2013-08-16T15:31:20+10:00'
                           ),
                           'count' => match_type_of(100)
                         })
      end

      it 'executes the pact test without errors' do
          interaction.execute do | mock_server |
          subject = Client.new(mock_server.url)
          expect(subject.process_data(date)).to eql([1, Time.parse(json_data['valid_date'])])
        end
      end
    end
    describe 'when there is no data' do
      let(:interaction) do
        super()
          .given('data count is == 0')
          .upon_receiving('a request for json data')
          .with_request(:get, '/provider.json', query: { 'valid_date' => date })
          .will_respond_with(404)
      end
        it 'handles the 404 response' do
          interaction.execute do | mock_server |
          subject = Client.new(mock_server.url)
            expect(subject.process_data(date)).to eql([0, nil])
          end
        end
    end
    describe 'handling invalid responses' do
      # subject { Client.new('localhost:3000') }

      let(:interaction) do
        super()
          .given('data count is > 0')
          .upon_receiving('a request with a missing date parameter')
          .with_request(:get, '/provider.json', query: { 'valid_date' => '' })
          .will_respond_with(400)
                             #  body: 'valid_date is required'.to_json,
                             #  headers: { "contentType": 'application/json' }
      end
      it 'handles a missing date parameter' do
          interaction.execute do | mock_server |
          subject = Client.new(mock_server.url)
            expect(subject.process_data(nil)).to eql([0, nil])
          end
      end
    end
    describe 'handling invalid responses' do
      # subject { Client.new('localhost:3000') }

      let(:interaction) do
        super()
          .given('data count is > 0')
          .upon_receiving('a request with an invalid date parameter')
          .with_request(:get, '/provider.json', query: { 'valid_date' => p('This is not a date') })
          .will_respond_with(400)
                          #  body: "'This is not a date' is not a date",
                          # headers: {"Content-Type": "application/json"},
      end
      it 'handles an invalid date parameter' do
          interaction.execute do | mock_server |
          subject = Client.new(mock_server.url)
            expect(subject.process_data('This is not a date')).to eql([0, nil])
          end
      end
    end
  end
end
