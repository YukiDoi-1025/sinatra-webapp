# frozen_string_literal: true

require 'json'
require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'sanitize'

def read_memos
  File.open('./memos.json') do |file|
    JSON.parse(file.read)
  end
end

def edit_memo(title, content, id = nil)
  memo = read_memos

  id = (memo.max_by { |key, _| key.to_i }[0].to_i + 1).to_s if id.nil?
  memo[id] = { 'title' => title, 'content' => content }

  File.open('./memos.json', 'w') do |file|
    file.write(JSON.pretty_generate(memo))
  end
end

def delete_memo(id)
  memo = read_memos

  memo.delete(id)

  File.open('./memos.json', 'w') do |file|
    file.write(JSON.pretty_generate(memo))
  end
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memo_all = read_memos
  erb :index
end

get '/new' do
  erb :new
end

post '/memos' do
  edit_memo(Sanitize.fragment(params[:title]), Sanitize.fragment(params[:content]))
  redirect '/memos'
end

get '/memos/:id' do
  @id = params[:id]
  @memo = read_memos[params[:id]]
  erb :show
end

get '/memos/:id/edit' do
  @id = params[:id]
  @memo = read_memos[params[:id]]
  erb :edit
end

patch '/memos/:id' do
  edit_memo(Sanitize.fragment(params[:title]), Sanitize.fragment(params[:content]), params[:id])
  redirect "memos/#{params[:id]}"
end

delete '/memos/:id/destroy' do
  delete_memo(params[:id])
  redirect '/memos'
end
