class ChatController < WebsocketRails::BaseController

  def make_chatroom_private
    if message[:room_id]
      WebsocketRails[message[:room_id]].make_private
      trigger_success 'successfully made chatroom private'
    else
      trigger_failure 'nope - didnt make chatroom private'
    end
  end

  def authorize_channel
    placeholder_for_test = true
    channel = WebsocketRails[message[:channel]]

    if placeholder_for_test
      accept_channel
    else
      deny_channel({message: 'authorization failed'})
    end
  end

  def client_connected
    p 'inside client connected'
    p "#{request.url}"
  end

  def client_disconnected
    p 'inside client disconnected'
    p "#{request.url}"
  end  

end




