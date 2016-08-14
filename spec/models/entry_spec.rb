describe Entry, type: :model do
  describe 'validations' do
    context 'date' do
      it 'is invalid without it' do
        expect(build(:entry, date: nil)).to be_invalid
      end
      it 'is valid when date is given' do
        expect(build(:entry)).to be_valid
      end
    end
  end
end
