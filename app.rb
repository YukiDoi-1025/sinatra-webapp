# frozen_string_literal: true

require 'json'
require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'sanitize'
require_relative 'lib/memo'
require 'pg'

before do
  @conn ||= PG.connect(dbname: 'memo_app')
end

after do
  @conn&.close
end

def initialize_db
  @conn ||= PG.connect(dbname: 'memo_app')
  result = @conn.exec("SELECT * FROM information_schema.tables WHERE table_name = 'memos'")
  @conn.exec('CREATE TABLE memos (id serial, title varchar(255), content text)') if result.values.empty?
end

def read_memos
  @conn.exec('SELECT * FROM memos').each_with_object({}) do |(memo), memos|
    memo_symbol = memo.transform_keys(&:to_sym)
    memos[memo_symbol[:id]] = Memo.new(memo_symbol)
  end
end

def read_memo(id)
  Memo.new(@conn.exec_params('SELECT * FROM memos WHERE id = $1;', [id])[0].transform_keys(&:to_sym))
end

def create_memo(title, content)
  @conn.exec_params('INSERT INTO memos(title, content) VALUES ($1, $2);', [title, content])
end

def edit_memo(title, content, id)
  @conn.exec_params('UPDATE memos SET title = $1, content = $2 WHERE id = $3;', [title, content, id])
end

def delete_memo(id)
  @conn.exec_params('DELETE FROM memos WHERE id = $1;', [id])
end

initialize_db

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
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
  @memo = read_memo(@id)
  erb :show
end

get '/memos/:id/edit' do
  @id = params[:id].to_i
  @memo = read_memo(@id)
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
