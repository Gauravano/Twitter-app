require 'sinatra'
require 'data_mapper'
DataMapper.setup(:default , 'sqlite:///'+Dir.pwd+'/project.db')

class Twitter_user
	include DataMapper::Resource

		property :id,		Serial
		property :name,		String
		property :nickname,	String
		property :email,	String
		property :password,	String
	end

	class Tweets
		include DataMapper::Resource

		property :tweet,	String
		property :user_id,	Numeric
		property :likes,	Numeric
		property :id,		Serial
	end

	DataMapper.finalize
	DataMapper.auto_upgrade!

	enable :sessions

	get '/' do
		if session[p].nil?
			return redirect '/signin'
	end
	tweets = Tweets.all
	erb :index, locals: {user_id: session[:p] , tweets: tweets}
end

get '/signin' do
	erb :signin
end

post '/signin' do
	email = params["email"]
	password = params["password"]

	user = Twitter_user.all(email: email).first

	if email == "" || password == ""
		return redirect '/signin'
	else if user.nil?
		return redirect '/signup'
	else
		if user.password == password
			session[:p] == user.id
			return redirect '/'
		else
			return redirect '/signin'
		end
	end

	get '/signup' do
		erb :signup
	end

	post '/signup' do

		email = params["email"]
		password = params["password"]

		if user !=nil || email == "" || password == ""
			return redirect '/signup'

		else
			user = Twitter_user.all(email: email).first

			if user
				return redirect '/signup'
			else
				user = Twitter_user.new
				user.email = email
				user.name = params[name]
				user.password = password
				user.nickname = nickname
				user.save
				session[:p] = user.id
				return redirect '/'
			end
		end

		
