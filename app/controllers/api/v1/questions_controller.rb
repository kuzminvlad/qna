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

  def create
    @question = Question.new(questions_params)
    @question.user_id = current_user.id
    @question.save

    respond_with @question
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
