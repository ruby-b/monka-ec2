# README

Setup

```
$ bundle install
$ rails db:migrate
$ rails db:seed
$ RAILS_ENV=test rails db:migrate
$ RAILS_ENV=test rails db:seed
```

# README

### Productモデルの作成

`rails g model product type:string title:string author:string published_on:date showing:boolean price:integer`

    invoke  active_record
    create    db/migrate/20161221002055_create_products.rb
    create    app/models/product.rb
    invoke    rspec
    create    spec/models/product_spec.rb

up/downに分けて記載する

### books⇒productsへのデータ移行処理

20161221002055_create_products.rbにデータ移行処理を記述

    books = Book.all
    books.each do |book|
      product = Product.new(book.attributes)
      product.type = 'Book'
      product.save
    end

### booksテーブル削除

`rails g migration drop_table_books`

    invoke  active_record
    create  db/migrate/20161221002132_drop_table_books.rb

20161221002132_drop_table_books.rbにテーブル削除処理を記述

```
def change
  drop_table :books do |t|
    t.string :title
    t.string :author
    t.date :published_on
    t.boolean :showing, default: false
    t.timestamps
  end
end
```

※changeメソッドに記述した場合、rollbackするとエラーになる。up/downに分けて記載する？

### マイグレーション実行
`rails db:migrate`

### Bookモデルの継承元をProductモデルに変更
`class Book < ApplicationRecord`
を
`class Book < Product`
に変更。

`scope :visible, ->(){ where(showing: true) }`をProductモデルへ移動

### Rspecの実行（既存処理に影響が出ていないことの確認）
※TODO(kawabata):現時点ではRspec動かない。テキスト作成時に要確認

### Musicモデルの作成
`rails g scaffold music`

```
invoke  active_record
create   db/migrate/20161221002316_create_musics.rb
create   app/models/music.rb
invoke   rspec
create    spec/models/music_spec.rb
invoke  resource_route
route    resources :musics
invoke  scaffold_controller
create    app/controllers/musics_controller.rb
invoke    erb
create      app/views/musics
create      app/views/musics/index.html.erb
create      app/views/musics/edit.html.erb
create      app/views/musics/show.html.erb
create      app/views/musics/new.html.erb
create      app/views/musics/_form.html.erb
invoke    rspec
create      spec/controllers/musics_controller_spec.rb
create      spec/views/musics/edit.html.erb_spec.rb
create      spec/views/musics/index.html.erb_spec.rb
create      spec/views/musics/new.html.erb_spec.rb
create      spec/views/musics/show.html.erb_spec.rb
create      spec/routing/musics_routing_spec.rb
invoke      rspec
create        spec/requests/musics_spec.rb
invoke    helper
create      app/helpers/musics_helper.rb
invoke      rspec
create        spec/helpers/musics_helper_spec.rb
invoke    jbuilder
create      app/views/musics/index.json.jbuilder
create      app/views/musics/show.json.jbuilder
create      app/views/musics/_music.json.jbuilder
invoke  assets
invoke    coffee
create      app/assets/javascripts/musics.coffee
invoke    scss
create      app/assets/stylesheets/musics.scss
invoke  scss
create    app/assets/stylesheets/scaffolds.scss
```

※musicsテーブルは作成しないので、`20161221002316_create_musics.rb`は削除

### productsテーブルにmusic用カラム追加
`rails g migration AddPlayTimeToProducts play_time:integer`

```
invoke  active_record
create  db/migrate/20161221003321_add_play_time_to_products.rb
```

`rails db:migrate`

### musics用の管理画面作成

#### musics_controller.rbの変更
 - `before_action :authenticate_user!`の追加
 - `music_params`メソッドの変更

```
def music_params
  params.require(:music).permit(:title, :author, :published_on, :showing, :price, :play_time)
end
```

#### music.rbの変更
 - 継承元を`ApplicationRecord`から`Product`に変更
 - タグ周りは保留

#### viewの変更(index, _form, edit, new, show)
 - books側を参考に
 - authorやpublished_onはそのまま使う？
 - タグ周りは保留

#### models.ja.ymlの変更
authorやpublished_onをそのまま使う前提で。

    music:
      title: タイトル
      author: アーティスト
      published_on: 発売日
      showing: 発売
      price: 価格
      play_time: 再生時間

### 会員用TOPページにMusicを表示
#### products_controller.rbの変更
`index`メソッドに`@musics = Music.visible.all`を追加

#### products/index.html.erbの変更
 - bookと同じようにmusicを表示する
 - bookとmusicの表示開始位置にそれぞれ、`BOOK`,`MUSIC`を表示する

### サイドメニューにMusics追加
`layouts/application.html.erb`の変更

```
<li class="<%= active_class('musics') %>"><%= link_to 'Musics', musics_path %></li>
```

### music用のspec作成
book側を参考に修正

