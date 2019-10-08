class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_commentable, only: [:create]

  respond_to :js, :json

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.answer_id = params[:answer_id] if @comment.commentable_type == 'Answer'

    if @comment.save
      render nothing: true
    else
      render json: { errors: @comment.errors.full_messages }
    end
  end

  private

  def model_class
    commentable_name.classify.constantize
  end

  def commentable_name
    params[:commentable].singularize
  end

  def find_commentable
    @commentable = model_class.find(params["#{commentable_name}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end