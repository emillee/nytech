module UsersHelper
  
  def add_placeholder_if_nil(attr)
    if current_user && current_user.public_send(attr)
      return current_user.public_send(attr)
    end
    
    case attr
    when 'biography'
      return '<h3>Biography</h3>
              <p>Tell us about you!</p>'
    when 'intro'
      return "<h3>Introduction</h3>
              <p>Provide brief intro here!</p>
              <p>Example: I'm an [title] at [company]</p>
              <p>Example: I'm working on [brief description]</p>
              <p>For fun I... (Or insert a random fact about yourself)</p>"
    end
  end
  
end