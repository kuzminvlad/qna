class NotifyMailer < ApplicationMailer
  def added_answer(user, answer)
    @user = user
    @answer = answer

    mail to: @user.email, subject: 'Added answer'
  end
end
