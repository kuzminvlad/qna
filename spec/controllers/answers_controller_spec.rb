require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'GET #new' do
    before do
      sign_in(user)
      get :new, params: { question_id: question.id }
    end

    it 'assigns a new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { sign_in(user) }

    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect {
          post :create,
            params: { question_id: question.id, answer: attributes_for(:answer), format: :js }
        }.to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        post :create,
          params: { question_id: question.id, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect {
          post :create,
            params: { question_id: question.id, answer: attributes_for(:invalid_answer), format: :js }
        }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create,
          params: { question_id: question.id, answer: attributes_for(:invalid_answer), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Logged user' do
      before { sign_in(user) }
      before { answer }

      it 'delete answer' do
        expect { delete :destroy,
          params: { id: answer, question_id: question, format: :js } }.to change(Answer, :count).by(-1)
      end

      it 'redirect to index' do
        delete :destroy,
          params: { id: answer, question_id: question, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'Not logged user' do
      before { answer }

      it 'tries to delete answer' do
        expect { delete :destroy,
          params: { id: answer, question_id: question } }.to change(Answer, :count).by(0)
      end

      it 'redirect to index' do
        delete :destroy,
          params: { id: answer, question_id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    before { sign_in(user) }

    it 'assigns the requested answer to @answer' do
      patch :update, params: { id: answer, question_id: question,
        answer: attributes_for(:answer), format: :js }
      expect(assigns(:answer)).to eq answer
    end

    it 'assigns the question' do
      patch :update, params: { id: answer, question_id: question,
        answer: attributes_for(:answer), format: :js }
      expect(assigns(:question)).to eq question
    end

    it 'changes answer attributes' do
      patch :update, params: { id: answer, question_id: question,
        answer: { body: 'new body' }, format: :js }
      answer.reload
      expect(answer.body).to eq 'new body'
    end

    it 'render update template' do
      patch :update, params: { id: answer, question_id: question,
        answer: attributes_for(:answer), format: :js }
      expect(response).to render_template :update
    end

  end
end
