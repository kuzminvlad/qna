class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :load_owner, only: [:destroy]
  before_action :build_answer, only: :show

  after_action :publish_question, only: [:create]

  respond_to :html

  authorize_resource

  include Voted

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit
    respond_with @question 
  end

  def create
    @question = Question.new(questions_params)
    @question.user_id = current_user.id
    @question.save

    respond_with @question
  end

  def update
    @question.update(questions_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy)
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast('questions', locals: { question: @question.to_json })
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def load_owner
    return redirect_to @question if @question.user != current_user
  end

  def questions_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end

  def build_answer
    @answer = @question.answers.build
    @comment = Comment.new
  end
end
