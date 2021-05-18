json.extract! user, :id, :email, :first_name, :last_name
json.avatar_url user.gravitar_url
json.roles user.roles
