class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: %i[new create destroy]
  before_action :load_answer, only: %i[update set_best]

  after_action :publish_question, only: [:create]

  authorize_resource

  respond_to :js
  respond_to :json, only: :create

  include Voted

  def new
    respond_with(@answer = @question.answers.new)
  end

  def create
    @answer = @question.answers.create(answers_params)
    @answer.user_id = current_user.id
    @answer.save
    respond_with @answer
  end

  def update
    @answer.update(answers_params)
    respond_with @answer
  end

  def destroy
    @answer.destroy
  end

  def set_best
    @answer.set_best! if @question.user == current_user
  end

  def publish_question
    return if @answer.errors.any?

    ActionCable.server.broadcast('answers', locals: { answer: @answer.to_json })
  end

  private

  def load_question
    @question = Question.find_by(id: params[:question_id])
  end

  def load_answer
    @answer = Answer.find_by(id: params[:id])
    @question = @answer.question
  end

  def answers_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end
end
