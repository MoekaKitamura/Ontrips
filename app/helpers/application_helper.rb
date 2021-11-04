module ApplicationHelper

  def unread_messages
    talks = Talk.where(receiver_id:current_user.id).or Talk.where(sender_id:current_user.id)
    unread_messages = 0
    talks.each do |talk|
      unread_messages += talk.messages.where.not(user_id:current_user.id).where(read:false).count
    end
    unread_messages
  end

  def city?(name)
    name.place.ancestry&.include?('/')
  end
  
end