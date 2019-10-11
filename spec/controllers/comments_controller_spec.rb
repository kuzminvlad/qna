require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  sign_in_user
  let!(:question) { create(:question, user: @user) }
  let!(:answer) { create(:answer, user: @user, question: question) }

  describe 'POST #create' do
    context 'with valid information' do
      it 'assigns question to @commentable' do
        post :create, params: { commentable: 'questions', question_id: question, comment: attributes_for(:comment), format: :js }
        expect(assigns(:commentable)).to eq question
      end

      it 'saves the question comment in database' do
        expect do
          post :create,
               params: { commentable: 'questions', question_id: question, comment: attributes_for(:comment), format: :js }
        end
          .to change(question.comments, :count).by(1) && change(@user.comments, :count).by(1)
      end

      # it 'assigns answer to @commentable' do
      #   post :create, params: { commentable: 'answers', answer_id: answer, comment: attributes_for(:comment), format: :js }
      #   expect(assigns(:commentable)).to eq answer
      # end

      # it 'saves the answer comment in database' do
      #   expect { post :create,
      #     params: { commentable: 'answers', answer_id: answer, comment: attributes_for(:comment), format: :js } }
      #     .to change(answer.comments, :count).by(1) && change(@user.comments, :count).by(1)
      # end
    end

    context 'with invalid information' do
      it 'does not save the answer' do
        expect { post :create, params: { commentable: 'questions', question_id: question, comment: attributes_for(:invalid_comment), format: :json } }
          .to_not change(Comment, :count)
      end
    end
  end
end
