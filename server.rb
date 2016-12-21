require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'active_record'
require 'sinatra/activerecord'
require 'json'
require_relative 'models/company'
require_relative 'models/developer'
require_relative 'models/companies_developer'

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
    # redirect to the code snippet page
    redirect to('/company/code/' + @company.id.to_s)
  else
    erb :error
  end
end

# Company account page
# need to secure this page
get '/company/:id' do
    @company = Company.find(@params['id'])
    erb :company_account
end

# Company render edit form


# Company update form


# Company login page


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

# Developer Account page
# need to secure this page
get '/developer/:id' do
    @developer = Developer.find(@params['id'])
    erb :developer_account
end


# Developer render edit form
get "/developer/edit/:id" do
  begin
    # find is a activerecord method
    @developer = Developer.find(@params['id'])
    erb :edit_user
  rescue
    "There was no user with the id #{params['id']}"
  end
end


# Developer update form
post "/edit/:id" do
  begin
    @developer = Developer.find(@params['id'])
    @developer.name = @params['name']
    @developer.email = @params['email']
    @developer.code = @params['code']
    if @developer.save
      erb :developer_account
    else
      "You didn't provide all the required fields"
    end
  rescue
    "There was no user with the id #{@params['id']}"
  end
end

# Developer login page


# Developer matches page





not_found do
  "Error"
end
