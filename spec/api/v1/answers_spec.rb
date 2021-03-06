require 'rails_helper'

describe 'Answers API' do
  let(:access_token) { create(:access_token) }
  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  let!(:comment) { create(:comment, commentable: answer) }
  let!(:attachment) { create(:attachment, attachmentable: answer) }

  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question) }

      before do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token }
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns question answers list' do
        expect(response.body).to have_json_size(1)
      end

      %w[id body created_at updated_at user_id].each do |attr|
        it "answer contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json)
            .at_path("0/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      before do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", params: { format: :json, access_token: access_token.token }
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns answer' do
        expect(response.body).to have_json_size(8)
      end

      %w[id body created_at updated_at user_id].each do |attr|
        it "answer contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path(attr.to_s)
        end
      end

      context 'comments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("comments")
        end

        %w[id body created_at updated_at user_id].each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("attachments")
        end

        it 'contains url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("attachments/0/url")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers/#{answer.id}", params: { format: :json }.merge(options)
    end
  end
end
