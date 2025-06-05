require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
 db = SQLite3::Database.new 'barbershop.db'
 db.results_as_hash = true 
 return db
end

configure do 
db = get_db
db.execute 'CREATE TABLE IF NOT EXISTS "Users" (
	"ID" INTEGER,
	"Name" TEXT,
	"Phone" TEXT,
	"DateStamp" TEXT,
	"Barber" TEXT,
	"Color" TEXT,
	PRIMARY KEY("ID" AUTOINCREMENT))'

	db.execute 'CREATE TABLE IF NOT EXISTS "Barbers" (
	"ID" INTEGER,
	"Name" TEXT,
	PRIMARY KEY("ID" AUTOINCREMENT))'
end

db = get_db	
db.execute	'insert into Barbers (Name) values (?)',['Walter White']

#def validation 
#	@error = hh.select {|k,v| params[k] == ""}.values.join(", ")
#end (Почему-то не работает)

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do  
	erb :about
end 

get '/visit' do  
	erb :visit
end 
get '/contacts' do  
	erb :contacts
end 

post '/visit' do 
	@user_name = params[:username]
	@phone = params[:phone]
	@date_time = params[:datetime]
	@barber = params[:barber]
	@color = params[:color]

	hh ={:username => 'Введите имя', :phone => 'Введите телефон', :datetime => 'Введите дату и время'}

	# удобный метот перебора пустых ключей	
	@error = hh.select {|k,v| params[k] == ""}.values.join(", ")

# можно так , но всё будет показываться по отдельности
	#hh.each do |key, value|
	#	if params[key] == ''
	#		@error = hh[key]
	#	end
	#end 	

	db = get_db	
	db.execute	'insert into Users (Name,Phone,DateStamp,Barber,Color) 
	values (?,?,?,?,?)',[@user_name, @phone, @date_time, @barber, @color]

	erb :visit
end	 

post '/contacts' do 
	@email = params[:email]
	@message = params[:message]

	hh1 = {:email => "Введите вашу почту", :message => "Введите сообщение"}
	@error = hh1.select {|k,v| params[k] == ""}.values.join(", ")
	f1 = File.open('./public/contacts.txt', 'a' )
	f1.write("Email:#{@email}, Message:#{@message}")
	f1.close

	erb :contacts
end	

get '/showusers' do

def user_order  
  		db = get_db
  		arr = []
  		db.execute 'select * from Users order by id desc --' do |row| 
  		arr[row]
  		puts arr 
  		end
end
	@users = user_order
	erb :showusers		
end