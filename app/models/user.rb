class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  has_many :answers, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  def self.find_for_oauth(auth)
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user if authorization

    email = auth.info[:email]
    return User.new unless email

    user = User.find_by(email: email)

    unless user
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
    end
    user.create_authorization(auth)
    user
  end

  def self.send_daily_digest
    questions = Question.where(created_at: Time.zone.now.yesterday.all_day).to_a

    return if questions.blank?

    find_each.each do |user|
      DailyMailer.digest(user, questions).deliver_later
    end
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def subscribed?(question_id)
    subscriptions.find_by(question_id: question_id)
  end

  def subscribe!(question_id)
    subscriptions.create!(question_id: question_id) unless subscribed?(question_id)
  end

  def unsubscribe!(question_id)
    subscriptions.find_by(question_id: question_id).destroy! if subscribed?(question_id)
  end
end
