require 'sinatra/base'
require './lib/student'

# Why is it a good idea to wrap our App class in a module?
module StudentSite
  class App < Sinatra::Base

    # get '/hello-world' do
    #   @random_numbers = (1..20).to_a
    #   erb :hello
    # end

    get '/students' do
      @students = Student.all
      erb :'students/index'
    end

    get '/students/:id' do
      @student = Student.find(params[:id])
      "Hello #{@student.name}"
    end
  
  end
end