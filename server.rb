require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'active_record'
require 'sinatra/activerecord'
require 'json'
require_relative 'models/company'
require_relative 'models/developer'

#Landing page
get '/' do
  erb :index
end

#Company sign up / login page
get '/company' do
  erb :company_home
end

#Company sign up form
get '/company/signup' do
  erb :company_signup
end

#Company - sign up form - makes account
post '/company/signup' do
  @company = Company.new(@params)
  if @company.save
    redirect to('/company/' + @company.id.to_s)
    # redirect to the swiping page
  else
    erb :error
  end
end

# Company account page
get '/company/:id' do
    @company = Company.find(@params['id'])
    erb :company_account
end

# Company render edit form


# Company update form


# Company login page



# ------------------------------------------



# Developer sign up / login page
get '/developer' do
  erb :developer_home
end


# Developer sign up form
get '/developer/signup' do
  erb :developer_signup
end

# Developer - signup form - makes account
post '/developer/signup' do
  @developer = Developer.new(@params)
  if @developer.save
    redirect to('/developer/' + @developer.id.to_s)
    # redirect to the matches page
  else
    erb :error
  end
end

# Developer Account page

get '/developer/:id' do
    @developer = Developer.find(@params['id'])
    erb :developer_account
end


# Developer render edit form


# Developer update form


# Developer login page


# Swipe

get '/swipe/:id' do
  @company = Company.find(@params['id'])

end



not_found do
  "Error"
end
