class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :load_question, only: :show

  authorize_resource :question
  
  def index
    @questions = Question.all
    respond_with @questions, each_serializer: QuestionArraySerializer
  end

  def show
    respond_with @question
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end
end
