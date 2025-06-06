require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
 db = SQLite3::Database.new 'barbershop.db'
 db.results_as_hash = true 
 return db
end

#Проверка наличия барбера в списке
def is_barber_exists? db, name
db.execute('select * from Barbers where Name=?', [name]).length > 0
end 

#добавление нового барбера
def seed_db db, barbers
	barbers.each do |barber|	
		if !is_barber_exists? db, barber
			db.execute 'insert into Barbers (Name) values (?)', [barber]
		end
	end
end

#Переменные из данного блока доступны во всех views
before	do 
db = get_db
@barbers = db.execute 'select * from Barbers' 
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

	seed_db db, ['Jessie Pinkman', 'Walter Whte', 'Gus Fring','Mike Ehrmantraut']
end


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

get '/showusers' do
 	db = get_db
   	
   	@results = db.execute 'select * from Users order by id desc --' 
	
	erb :showusers		
end

get '/admin' do
	erb :admin
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

post '/admin' do 
	db = get_db	

	@add_barber = params[:add_barber]
	
	seed_db db, [@add_barber]

	erb :admin
end 	