# frozen_string_literal: true

require 'json'
require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'sanitize'
require_relative 'lib/memo'

def read_memos
  File.open('./memos.json') do |file|
    JSON.parse(file.read, { symbolize_names: true }).each_with_object({}) do |(id, memo_json), memos|
      id_sym_to_int = id.to_s.to_i
      memos[id_sym_to_int] = Memo.new(id_sym_to_int, memo_json)
    end
  end
end

def save_memos(file_path, memos)
  File.open(file_path, 'w') do |file|
    file.write(Hash[memos.map { |_key, memo| memo.output_details }].to_json)
  end
end

def create_memo(title, content)
  memos = read_memos
  id = memos.empty? ? 1 : memos.max_by { |_key, memo| memo.id }[1].id + 1
  memos[id] = Memo.new(id, { title: title, content: content })

  save_memos('./memos.json', memos)
end

def edit_memo(title, content, id)
  memos = read_memos
  memos[id].title = title
  memos[id].content = content

  save_memos('./memos.json', memos)
end

def delete_memo(id)
  memos = read_memos
  memos.delete(id)

  save_memos('./memos.json', memos)
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = read_memos
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  create_memo(params[:title], params[:content])
  redirect '/memos'
end

get '/memos/:id' do
  @id = params[:id].to_i
  @memo = read_memos[@id]
  erb :show
end

get '/memos/:id/edit' do
  @id = params[:id].to_i
  @memo = read_memos[@id]
  erb :edit
end

patch '/memos/:id' do
  edit_memo(params[:title], params[:content], params[:id].to_i)
  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id/destroy' do
  delete_memo(params[:id].to_i)
  redirect '/memos'
end
