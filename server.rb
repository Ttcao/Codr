require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'active_record'
require 'sinatra/activerecord'
require 'json'
require_relative 'models/company'
require_relative 'models/developer'
require_relative 'models/companies_developer'

enable :sessions

helpers do
  def logged_in?
    !!current_user
  end

  def current_user
    Developer.find_by(id: session[:developer_id])
  end
end

post '/developer/login' do
  developer = Developer.find_by(email: @params[:email])
  if developer && developer.authenticate(params[:password])
    session[:developer_id] = developer.id
    redirect to("/developer/#{developer.id}")
  else
    erb :developer_home
  end
end

delete '/developer/login' do
  session[:developer_id] = nil
  redirect to '/developer'
end


# ------------------------------------------


#Landing page
get '/' do
  erb :index
end


# ------------------------------------------



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
    # redirect to the code snippet page
    redirect to("/company/#{@company.id}/code")
  else
    erb :error
  end
end

# Company login page





# Company account page
# need to secure this page
get '/company/:id' do
    @company = Company.find(@params['id'])
    erb :company_account
end

# Company render edit form
get "/company/:id/edit" do
  begin
    @company = Company.find(@params['id'])
    erb :company_edit
  rescue
    "There was no user with the id #{params['id']}"
  end
end

# Company update form
put "/company/:id" do
  @company = Company.find_by(id: @params['id'])
  if @company
    @company.name = @params['name']
    @company.email = @params['email']
    @company.description = @params['description']
    if @company.save
      redirect to("/company/#{@company.id}")
    else
      "You didn't provide all the required fields"
    end
  else
    "This company is not available"
  end
end

# Company delete form
post '/company/:id/delete' do
  begin
    @company = Company.find(@params['id'])
    @company.destroy
    redirect to('/')
  rescue
    "This company isn't available"
  end
end

# Company view code snippet
get '/company/:id/code' do
  query = "SELECT * FROM developers WHERE id NOT IN (SELECT developer_id FROM companies_developers WHERE company_id = #{params['id']})"
  @developer = Developer.find_by_sql(query).first
  erb :view_code
end

# Code snippet is saved to companies_developers table
post '/company/code/viewed' do
  if @params['accepted'] == "true"
    @companies_developer = CompaniesDeveloper.new
    @companies_developer.accepted = @params['accepted']
    @companies_developer.developer_id = @params['developer_id']
    @companies_developer.company_id = @params['company_id']
    if @companies_developer.save
    @company = @params['company_id']
    redirect to('/company/' + @company.to_s + '/code')
    end
  elsif @params['accepted'] == "false"
    @companies_developer = CompaniesDeveloper.new
    @companies_developer.accepted = @params['accepted']
    @companies_developer.developer_id = @params['developer_id']
    @companies_developer.company_id = @params['company_id']
    if @companies_developer.save
    @company = @params['company_id']
    redirect to('/company/' + @company.to_s + '/code')
    end
  end
end


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

# Developer login page





# Developer Account page
# need to secure this page
get '/developer/:id' do
  begin
    @developer = Developer.find(@params['id'])
    erb :developer_account
  rescue
    "There was no user with the id #{params['id']}"
  end
end

# Developer render edit form
get "/developer/:id/edit" do
  begin
    @developer = Developer.find(@params['id'])
    erb :developer_edit
  rescue
    "There was no user with the id #{params['id']}"
  end
end

# Developer update form
put "/developer/:id" do
  @developer = Developer.find_by(id: @params['id'])
  if @developer
    @developer.name = @params['name']
    @developer.email = @params['email']
    @developer.code = @params['code']
    binding.pry
    if @developer.save
      redirect to("/developer/#{@developer.id}")
    else
      "You didn't provide all the required fields"
    end
  else
    "This developer is not available"
  end
end

# Developer delete form
post '/developer/:id/delete' do
  begin
    @developer = Developer.find(@params['id'])
    @developer.destroy
    redirect to('/')
  rescue
    "This developer isn't available"
  end
end

# Developer matches page
get '/developer/:id/matches' do
  query = "SELECT * FROM companies WHERE id IN (SELECT company_id FROM companies_developers WHERE developer_id = #{params['id']} AND accepted = true);"
  @companies = Company.find_by_sql(query)
  erb :view_matches
end

not_found do
  "Error"
end
