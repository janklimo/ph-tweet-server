describe ChartsController, type: :controller do
  describe '#show' do
    context 'valid entry' do
      before { @entry = create(:entry) }
      it 'renders show page' do
        get :show, id: @entry.date
        expect(response).to render_template 'charts/show'
      end
    end
    context 'invalid entry' do
      it 'renders the not found page' do
        get :show, id: 'made-up'
        expect(response).to redirect_to not_found_charts_path
      end
    end
  end
end
