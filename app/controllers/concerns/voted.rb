module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: %i[vote_up vote_down delete_vote]
  end

  def vote_up
    authorize! :vote_up, @votable
    @votable.vote_up(current_user)

    respond_to do |format|
      format.json { render json: { model: model_class.to_s, votable_id: @votable.id, score: @votable.total_score, voted: true } }
    end
  end

  def vote_down
    authorize! :vote_down, @votable
    @votable.vote_down(current_user)

    respond_to do |format|
      format.json { render json: { model: model_class.to_s, votable_id: @votable.id, score: @votable.total_score, voted: true } }
    end
  end

  def delete_vote
    authorize! :delete_vote, @votable
    @votable.delete_vote(current_user)

    respond_to do |format|
      format.json { render json: { model: model_class.to_s, votable_id: @votable.id, score: @votable.total_score, voted: false } }
    end
  end

  private

  def model_class
    controller_name.classify.constantize
  end

  def find_votable
    @votable = model_class.find(params[:id])
  end
end
