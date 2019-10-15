require "rails_helper"

RSpec.describe NotifyMailer, type: :mailer do
  describe "added_answer" do
    let(:user) { create(:user) }
    let(:answer) { create(:answer) }
    let(:mail) { NotifyMailer.added_answer(user, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("Added answer")
      expect(mail.to).to match_array(user.email)
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(answer.body)
    end
  end
end
