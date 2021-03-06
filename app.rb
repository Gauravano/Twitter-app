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

		property :tweet,	Text
		property :user_id,	Numeric
		property :likes,	Numeric
		property :id,		Serial
	end

	class Liker
		include DataMapper::Resource

			property :tweet, 	Text
			property :email,	String
	#		property :isitlike,Boolean

		end

	DataMapper.finalize
	DataMapper.auto_upgrade!

	enable :sessions

	get '/' do
		if session[:p].nil?
			return redirect '/signin'
		end

	users = Twitter_user.all
	tweets = Tweets.all
	erb :index, locals: {user_id: session[:p] , tweets: tweets,user: users}
end

get '/signin' do
	erb :signin
end

post '/signin' do
	email = params["email"]
	password = params["password"]

	user = Twitter_user.all(email: email).first

	if email == nil || password == nil
		return redirect '/signin'
	elsif user.nil?
		return redirect '/signup'
	else
		if user.password == password
			session[:p] == user.id
			return redirect '/'
		else
			return redirect '/signin'
		end
	end
	redirect '/signin'
end

	get '/signup' do
		erb :signup
	end

	post '/signup' do

		email = params["email"]
		password = params["password"]
		name = params["name"]
		nickname = params["nickname"]

		user = Twitter_user.all(email: email).first

		if user !=nil || email == nil || password == nil
			return redirect '/signup'
		else

			if user
				return redirect '/signup'
			else
				user = Twitter_user.new
				user.email = email
				user.name = name
				user.password = password
				user.nickname = nickname
				user.save
				session[:p] = user.id
				return redirect '/'
			end
		end
	end

	post '/like' do
		user_mail = params["email"]
		tweet = params["twee.tweet"]

	p =	Liker.all(email: user_mail)

	if p.!nil?
		p.each do |k|
			if k.tweet == tweet
				return redirect '/index'
			end
		end
			like = Liker.new
			like.email = user_mail
			like.tweet = tweet
			like.save
			m = Tweets.get(user_mail)
			m.likes = m.likes + 1
			m.save
			return redirect '/index'
		end
	end

		post '/tweet' do
			tweet = params["tweet"]
			tweet_inf = Tweets.new
			tweet_inf.tweet = tweet
			tweet_inf.user_id = session[:p]

			if tweet_inf.tweet != "" 
				tweet_inf.save
			end

			return redirect '/'
		end

		get '/signout' do
			session[:p] = nil
			return redirect '/'
		end

