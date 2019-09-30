require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }

  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }

  it { should have_many :attachments }
  it { should accept_nested_attributes_for :attachments }

  describe 'set_best!' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer1) { create(:answer, question: question, user: user) }
    let!(:answer2) { create(:answer, question: question, user: user, best: true) }

    it 'set best answer' do
      answer1.set_best!
      answer1.reload
      answer2.reload

      expect(answer1.best).to be true
      expect(answer2.best).to be false
    end
  end

end
