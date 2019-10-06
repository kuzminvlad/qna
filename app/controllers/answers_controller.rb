class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:new, :create]
  before_action :load_answer, only: [:destroy, :update, :set_best]

  after_action :publish_question, only: [:create]

  include Voted

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answers_params)
    @answer.user_id = current_user.id
    @answer.save
    @comment = Comment.new
  end

  def update
    @answer.update(answers_params)
    @question = @answer.question
    @comment = Comment.new
  end

  def destroy
    @answer.destroy if @answer.user == current_user
  end

  def set_best
    @question = @answer.question
    @answer.set_best! if @question.user == current_user
    @comment = Comment.new
  end

  def publish_question
    return if @answer.errors.any?
    ActionCable.server.broadcast('answers', locals: { answer: @answer.to_json })
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answers_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end
end
