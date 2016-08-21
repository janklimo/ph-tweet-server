describe 'Chart show page', type: :feature do
  before do
    @entry = create(:entry)
    @no_1 = create(:post, entry: @entry, rank: 1, name: 'Winning Product',
                   votes: 1000)
    @no_1.users << create(:user_maker, image_url: 'extra_maker.png')
    @no_2 = create(:post, entry: @entry, rank: 2, name: 'Runner Up',
                   votes: 999)
    @no_2.users << create(:user_maker, image_url: 'extra_maker2.png')
  end
  context 'no rank specified' do
    it 'shows the stats for #1 post' do
      visit chart_path(id: @entry.date)
      expect(page).to have_content 'Most Upvoted Products'
      expect(page).to have_content '#1'
      expect(page).to have_content 'Winning Product'
      expect(page).to have_content '1000'
      expect(page.find('#hunter-thumb')['src']).to have_content(/image_hunter/)
      expect(page.find('#maker-1-thumb')['src']).to have_content(/image_maker/)
      expect(page.find('#maker-2-thumb')['src']).to have_content(/extra_maker/)
    end
  end
  context 'rank is given' do
    it 'shows the stats for the given post' do
      visit chart_path(id: @entry.date, rank: 2)
      expect(page).to have_content 'Most Upvoted Products'
      expect(page).to have_content '#2'
      expect(page).to have_content 'Runner Up'
      expect(page).to have_content '999'
      expect(page.find('#hunter-thumb')['src']).to have_content(/image_hunter/)
      expect(page.find('#maker-1-thumb')['src']).to have_content(/image_maker/)
      expect(page.find('#maker-2-thumb')['src'])
        .to have_content('extra_maker2.png')
    end
  end
end
