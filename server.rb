require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'byebug'
require 'active_record'
require 'sinatra/activerecord'
require 'json'
require_relative 'models/company'
require_relative 'models/developer'
require_relative 'models/companies_developer'

enable :sessions

helpers do
  def logged_in?
    !!current_developer or !!current_company
  end

  def current_developer
    Developer.find_by(id: session[:developer_id])
  end

  def current_company
    Company.find_by(id: session[:company_id])
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

delete '/developer/logout' do
  session[:developer_id] = nil
  redirect to '/developer'
end

post '/company/login' do
  company = Company.find_by(email: @params[:email])
  if company && company.authenticate(params[:password])
    session[:company_id] = company.id
    redirect to("/company/#{company.id}")
  else
    erb :company_home
  end
end

delete '/company/logout' do
  session[:company_id] = nil
  redirect to '/company'
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
    company = Company.find_by(email: @params[:email])
    session[:company_id] = company.id
    # redirect to the company account
    redirect to("/company/#{@company.id}")
  else
    erb :error
  end
end

# Company account page
get '/company/:id' do
  if current_company.id.to_s == @params['id']
    @company = Company.find(@params['id'])
    erb :company_account
  else
    erb :error
  end
end

# Company render edit form
get "/company/:id/edit" do
  if current_company.id.to_s == @params['id']
    @company = Company.find(@params['id'])
    erb :company_edit
  else
    erb :error
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
  if current_company.id.to_s == @params['id']
    query = "SELECT * FROM developers WHERE id NOT IN (SELECT developer_id FROM companies_developers WHERE company_id = #{params['id']})"
    @developer = Developer.find_by_sql(query).sample
    if @developer.code
      erb :view_code
    else
      erb :view_no_code
    end
  else
    erb :error
  end
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
    developer = Developer.find_by(email: @params[:email])
    session[:developer_id] = developer.id
    # redirect to the matches page
    redirect to('/developer/' + @developer.id.to_s)
  else
    erb :error
  end
end

# Developer Account page
get '/developer/:id' do
  if current_developer.id.to_s == @params['id']
    @developer = Developer.find(@params['id'])
    erb :developer_account
  else
    erb :error
  end
end

# Developer render edit form
get "/developer/:id/edit" do
  if current_developer.id.to_s == @params['id']
    @developer = Developer.find(@params['id'])
    erb :developer_edit
  else
    erb :error
  end
end

# Developer update form
put "/developer/:id" do
  @developer = Developer.find_by(id: @params['id'])
  if @developer
    @developer.name = @params['name']
    @developer.email = @params['email']
    @developer.code = @params['code']
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
  if current_developer.id.to_s == @params['id']
  query = "SELECT * FROM companies WHERE id IN (SELECT company_id FROM companies_developers WHERE developer_id = #{params['id']} AND accepted = true);"
  @companies = Company.find_by_sql(query)
    if @companies.count > 0
      erb :view_matches
    else
      erb :view_no_matches
    end
  else
    erb :error
  end
end

not_found do
  erb :error
end
