describe 'General routing', type: :request do
  context 'no matching route' do
    it 'redirects to not found page' do
      get '/made-up-path'
      expect(response).to render_template 'charts/not_found'
    end
  end
end
