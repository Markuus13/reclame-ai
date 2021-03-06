require 'rails_helper'

RSpec.describe 'Complaints API', type: :request do
  describe 'GET /' do
    before { get '/' }

    it 'returns a successful response' do
      expect(response).to be_successful
    end

    it 'returns a page with a title header "Reclame aí"' do
      expect(response.body).to include('<h1>Reclame aí</h1>')
    end
  end

  describe 'GET /complaints' do
    it 'returns a sussceful response' do
      get '/complaints'
      expect(response).to be_successful
    end
  end

  describe 'POST /complaints' do
    before do
    stub_request(:get, "http://checkip.amazonaws.com/").
      to_return(body: "189.27.26.198")
    end

    context 'with valid params' do
      let(:valid_attributes) {
        {
          complaint: {
            name: 'Uriel Silva',
            email: 'uriel@foo.bar',
            phone_number: '61912345678',
            order_number: '123',
            delivery_cep: '70364400',
            description: 'My product is not working :('
          }
        }
      }

      before do
        create(:sale, order_number: '123')
      end

      xit 'creates a new complaint' do
        expect { post '/complaints', params: valid_attributes }
          .to change { Complaint.count }.by(1)
      end

      xit 'redirects to home page' do
        post '/complaints', params: valid_attributes
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) {
        {
          complaint: {
            name: 'Uriel Silva',
            email: 'uriel@foo.bar',
            phone_number: '61912345678',
            order_number: 'inexistent_order_number',
            delivery_cep: '70364400',
            description: 'My product is not working :('
          }
        }
      }

      it 'does not create a new complaint' do
        expect { post '/complaints', params: invalid_attributes }
          .to_not change { Complaint.count }
      end

      it 'returns a sucessful response' do
        post '/complaints', params: invalid_attributes
        expect(response).to be_successful
      end
    end
  end
end