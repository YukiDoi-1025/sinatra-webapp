# frozen_string_literal: true

require 'json'
require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'sanitize'
require_relative 'lib/memo'

def read_memos
  File.open('./memos.json') do |file|
    JSON.parse(file.read, { symbolize_names: true }).map do |key, value|
      Memo.new(key, value)
    end
  end
end

def create_memo(title, content)
  memos = read_memos

  id = (memos.max_by { |memo| memo.id.to_s.to_i }.id.to_s.to_i + 1).to_s.to_sym
  memos.push(Memo.new(id, { title: title, content: content }))

  File.open('./memos.json', 'w') do |file|
    file.write(JSON.pretty_generate(memos.map(&:output_details).to_h))
  end
end

def edit_memo(title, content, id)
  memos = read_memos
  memo_index = memos.find_index { |memo| memo.id == id }

  memos[memo_index].title = title
  memos[memo_index].content = content

  File.open('./memos.json', 'w') do |file|
    file.write(JSON.pretty_generate(memos.map(&:output_details).to_h))
  end
end

def delete_memo(id)
  memos = read_memos
  memo_index = memos.find_index { |memo| memo.id == id }

  memos.delete_at(memo_index)

  File.open('./memos.json', 'w') do |file|
    file.write(JSON.pretty_generate(memos.map(&:output_details).to_h))
  end
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = read_memos
  erb :index
end

get '/new' do
  erb :new
end

post '/memos' do
  create_memo(Sanitize.fragment(params[:title]), Sanitize.fragment(params[:content]))
  redirect '/memos'
end

get '/memos/:id' do
  @id = params[:id].to_sym
  memos = read_memos
  @memo = read_memos[memos.find_index { |memo| memo.id == @id }]
  erb :show
end

get '/memos/:id/edit' do
  @id = params[:id].to_sym
  memos = read_memos
  @memo = read_memos[memos.find_index { |memo| memo.id == @id }]
  erb :edit
end

patch '/memos/:id' do
  edit_memo(Sanitize.fragment(params[:title]), Sanitize.fragment(params[:content]), params[:id].to_sym)
  redirect "memos/#{params[:id]}"
end

delete '/memos/:id/destroy' do
  delete_memo(params[:id].to_sym)
  redirect '/memos'
end
