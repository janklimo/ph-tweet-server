describe 'Welcome page', type: :feature do
  before do
    @entry_1 = create(:entry, date: (Date.today - 2))
    @post_1 = create(:post, entry: @entry_1, rank: 1, name: 'New MacBook Air',
                   votes: 1000)
    @post_2 = create(:post, entry: @entry_1, rank: 2, name: 'Something Cool',
                   votes: 999)
    @entry_2 = create(:entry)
    @post_3 = create(:post, entry: @entry_2, rank: 1, name: 'Tesla S',
                     votes: 400)
    @post_4 = create(:post, entry: @entry_2, rank: 2, name: 'Soylent',
                     votes: 350)
  end
  it 'shows the stats table' do
    visit root_path
    expect(page).to have_content 'Top Products'
    expect(page).to have_content 'New MacBook Air, Something Cool'
    expect(page).to have_content '1999'
    expect(page).to have_link('View', href: chart_path(@entry_1.date.to_s))

    expect(page).to have_content 'Tesla S, Soylent'
    expect(page).to have_content '750'
    expect(page).to have_link('View', href: chart_path(@entry_2.date.to_s))
  end
  it 'sorts the date desc and has working links' do
    visit root_path
    within '.table-hover' do
      first(:link, 'View').click
    end
    expect(page).to have_content '#1 Tesla S (400 votes)'
  end
end
