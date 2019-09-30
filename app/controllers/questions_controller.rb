class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :load_owner, only: [:destroy]


  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
  end

  def new
    @question = Question.new
    @question.user_id = current_user.id
    @question.attachments.build
  end

  def edit
  end

  def create
    @question = Question.new(questions_params)
    @question.user_id = current_user.id

    if @question.save
      flash[:notice] = 'Your question sucessfully created.'
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if @question.update(questions_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def load_owner
    return redirect_to @question if @question.user != current_user
  end

  def questions_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
