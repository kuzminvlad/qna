require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before do
        get '/api/v1/questions', params: { format: :json, access_token: access_token.token }
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2)
      end

      %w[id title body created_at updated_at].each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json)
            .at_path("0/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json)
          .at_path('0/short_title')
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("0/answers")
        end

        %w[id body created_at updated_at].each do |attr|
          it "containss #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json)
              .at_path("0/answers/0/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question) }
      let!(:comment) { create(:comment, commentable: question) }
      let!(:attachment) { create(:attachment, attachmentable: question) }

      before do
        get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token }
      end

      it 'returns 200 status code' do
        expect(response).to be_successful
      end

      it 'returns question' do
        expect(response.body).to have_json_size(7)
      end

      %w[id title body created_at updated_at].each do |attr|
        it "question contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path(attr.to_s)
        end
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("comments")
        end

        %w[id body created_at updated_at user_id].each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("attachments")
        end

        it 'contains url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("attachments/0/url")
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/questions/1', params: { format: :json }.merge(options)
    end
  end
end
