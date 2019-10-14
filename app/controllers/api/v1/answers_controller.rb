class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question, only: %i[index create]
  before_action :load_answer, only: [:show]

  authorize_resource :answer

  def index
    @answers = @question.answers
    respond_with @answers, each_serializer: AnswerArraySerializer
  end

  def show
    respond_with @answer
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_resource_owner
    @answer.save
    respond_with(@answer)
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
