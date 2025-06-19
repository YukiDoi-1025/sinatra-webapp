# Sinatraを用いたWebアプリ

## 初期設定
1. リポジトリをForkし、Forkしたリポジトリを自分のローカル環境にクローンする。<br>`git clone https://github.com/自分のID/sinatra-webapp.git`
1. クローンしたフォルダに移動し、アプリケーション実行に必要なGemをインストールするため<br>`bundle install`を実行。

## DBの設定
PostgreSQLに管理者権限でログインし、`memo_app`データベース作成・権限付与を実施
`sudo -u postgres psql`
`CREATE DATABASE memo_app;`
`CREATE USER PCユーザー名 WITH PASSWORD 'your_password';`
`ALTER DATABASE memo_app OWNER TO your_username;`

## アプリケーションの実行
1. `bundle exec ruby app.rb`を実行。
1. ブラウザで`http://localhost:4567`にアクセス
