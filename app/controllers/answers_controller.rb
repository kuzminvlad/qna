class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:new, :create]
  before_action :load_answer, :load_owner, only: [:destroy, :show]

  def new
    @answer = @question.answers.new
  end

  def show
  end

  def create
    @answer = @question.answers.new(answers_params)
    @answer.user_id = current_user.id
    @answer.save
  end

  def destroy
    question_id = @answer.question_id
    @answer.destroy
    redirect_to "/questions/#{question_id}"
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_owner
    return redirect_to "/questions/#{@answer.question_id}" if @answer.user != current_user
  end

  def answers_params
    params.require(:answer).permit(:body)
  end
end
