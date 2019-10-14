shared_examples_for 'voted' do
  describe 'PATCH #vote_up #vote_down' do
    it 'assigns votable to @votable' do
      patch :vote_up, params: { id: votable, format: :json }
      expect(assigns(:votable)).to eq votable
    end

    it 'votes up for votable' do
      expect { patch :vote_up, params: { id: votable, format: :json } }.to change(votable.votes, :count).by(1)
    end

    it 'dont votes up for votable' do
      expect { patch :vote_up, params: { id: own_votable, format: :json } }.to_not change(Vote, :count)
    end

    it 'votes down for votable' do
      expect { patch :vote_down, params: { id: votable, format: :json } }.to change(votable.votes, :count).by(1)
    end

    it 'dont votes down for votable' do
      expect { patch :vote_down, params: { id: own_votable, format: :json } }.to_not change(Vote, :count)
    end
  end

  describe 'DELETE #delete_vote' do
    it 'assigns votable to @votable' do
      patch :delete_vote, params: { id: votable, format: :json }
      expect(assigns(:votable)).to eq votable
    end

    it 'deletes existed vote for votable' do
      patch :vote_up, params: { id: votable, format: :json }
      expect { patch :delete_vote, params: { id: votable, format: :json } }.to change(votable.votes, :count).by(-1)
    end
  end
end
