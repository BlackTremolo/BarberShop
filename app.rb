require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

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
	@hairdresser = params[:hairdresser]
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
	
	f = File.open('./public/users.txt', 'a')
	f.write("User name:#{@user_name}, Phone:#{@phone}, Date and time:#{@date_time}, Hairdresser:#{@hairdresser}, Color:#{@color}\n")
	f.close

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