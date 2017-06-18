require 'sinatra'
require 'data_mapper'
DataMapper.setup(:default , 'sqlite:///'+Dir.pwd+'/project.db')

class Twitter_user
