require "yaml"

require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'

before do
  @users = YAML.load_file("users.yaml")
  @total_interests = total_interests
end


helpers do
  def others(user)
    others = @users.keys.reject {|name| name == user.to_sym}
    others.push :home
  end

  def interests(user)
    interest_list = @users[user.to_sym][:interests]
    interest_list[0...-1].join(', ') + ' and ' + interest_list.last
  end

  def total_interests
    total = @users.each_with_object([]) do |user, count| 
      count << user[1][:interests]
    end
    total.flatten.count
  end
end

get "/" do
  redirect "/home"
end

get "/home" do
  erb :index
end

get "/:user" do
  @user = params[:user]
  @email = @users[@user.to_sym][:email]
  @other_users = others(@user)
  @interests = interests(@user)
  erb :user_page
end

not_found do 
  redirect "/home"
end
