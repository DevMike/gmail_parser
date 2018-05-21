shared_examples 'successful request' do
  it { expect(response).to have_http_status(:success) }
end

shared_examples 'unprocessable entity' do
  it { expect(response).to have_http_status(:unprocessable_entity) }
end

shared_examples 'not found request' do
  it { expect(response).to have_http_status(:not_found) }
end

shared_examples 'forbidden request' do
  it { expect(response).to have_http_status(:forbidden) }
end
