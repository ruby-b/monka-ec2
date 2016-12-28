# README

Setup

```
$ bundle install
$ rails db:migrate
$ rails db:seed
$ RAILS_ENV=test rails db:migrate
$ RAILS_ENV=test rails db:seed
```

### ranks gem 追加
##### Gemfileに追加
 - ranksを追加

[参考サイト](https://github.com/activerecord-hackery/ransack/wiki/Basic-Searching　"Git")

```
gem 'ransack'
```
 - 適用

`bundle install`

### オーダー管理画面に検索項目を追加
##### app/views/orders_management/index.html.erbを編集
 - 検索項目を追加編集 
```
<% if notice %>
  <div class="alert alert-success alert-dismissible" role="alert">
    <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
  <p id="notice"><%= notice %></p>
  </div>
<% end %>

<h2 class="sub-header">Orders</h2>

<div class="panel panel-default">
  <div class="panel-heading">
    <div class="panel-title">検索</div>
  </div>
  <div class="panel-body">
    <%= search_form_for @order, url: orders_management_index_path do |f| %>
      <div class="row">
        <div class="col-sm-12">
          <div class="form-group">
            <%= f.label :user_id %>
            <%= f.search_field :user_name_cont, class: "form-control" %>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-sm-12">
          <div class="form-group">
            <%= f.label :status %>
            <div class="form-group">
              <% Order.statuses.each do |key, val| %>
                <label>
                  <%= f.check_box :status_in, { multiple: true }, checked_value = val, unchecked_value = "-1" %>
                  <%= I18n.t key, scope: 'activerecord.enum.order.status' %>
                </label>
              <% end %>
            </div>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-sm-12">
          <%= f.submit '検索', class: "btn btn-primary" %>
        </div>
      </div>
    <% end %>
  </div>
</div>

<div class="table-responsive">
  <table class="table table-striped">
    <thead>
      <tr>
        <th>購入者</th>
        <th>送付先</th>
        <th>金額</th>
        <th>状態</th>
        <th colspan="3"></th>
      </tr>
    </thead>
    <tbody>
      <% @orders.each do |order| %>
        <tr>
          <td><%= order.user.name %></td>
          <td><%= order.shipping_address %></td>
          <td><%= order.order_detail.product.price %></td>
          <td><%= I18n.t order.status, scope: 'activerecord.enum.order.status' %></td>
          <td><%= link_to '編集', edit_orders_management_path(order) %></td>
        </tr>
      <% end %>
    </tbody>
  </table>
</div>
```

##### app/controllers/orders_management_controller.rbを編集
 - 編集 
```
  def index
    conditions = params[:q] || { status_in: Order.statuses.values }
    @order     = Order.ransack(conditions)
    @orders    = @order.result.includes(:user).to_a.uniq
  end
```


### TOP画面に検索項目を追加
##### app/models/product.rb.rbを編集
 - 検索後に本・音楽商品を切り分ける為にscope追加編集 
```
class Product < ApplicationRecord
  has_many :order_details
  has_many :line_items

  scope :books,  ->(){ where(type: "Book") }
  scope :musics, ->(){ where(type: "Music") }
  scope :visible, ->(){ where(showing: true) }
end
```

##### app/views/products/index.html.erbを編集
 - 検索項目を追加編集 
```
<% if notice %>
  <div class="alert alert-success alert-dismissible" role="alert">
    <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
    <p id="notice"><%= notice %></p>
  </div>
<% end %>

<div class="jumbotron">
  <h1>F-B Shop</h1>
  <p class="lead">This site is the test shop of my favorite books.</p>
  <p class="lead">Enjoy and select your favorite books!</p>
</div>


<div class="panel panel-default">
  <div class="panel-heading">
    <div class="panel-title">検索</div>
  </div>
  <div class="panel-body">
    <%= search_form_for @product, url: products_index_path do |f| %>
      <div class="row">
        <div class="col-sm-12">
          <div class="form-group">
            <%= f.label :title %>
            <%= f.search_field :title_cont, class: "form-control" %>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-sm-12">
          <div class="form-group">
            <%= f.label :author %>
            <%= f.search_field :author_cont, class: "form-control" %>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-sm-12">
          <div class="form-group">
            <%= f.label :price %>
            <div class="row">
              <div class="col-sm-5">
                <%= f.number_field :price_gteq, class: "form-control" %>
              </div>
              <%= f.label :while, class: "col-sm-2 text-center" %>
              <div class="col-sm-5">
                <%= f.number_field :price_lteq, class: "form-control" %>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-sm-12">
          <%= f.submit '検索', class: "btn btn-primary" %>
        </div>
      </div>
    <% end %>
  </div>
</div>

<div class="row marketing">
  <h2>BOOK</h2>
  <div class="col-lg-12">
    <% @books.each do |book| %>
      <h3><%= book.title %></h3>
      <p><%= book.author %></p>
      <p><%= book.published_on %></p>
      <p><%= number_to_currency(book.try(:price), precision: 0, unit: "円") %><%= link_to 'カートに入れる', line_items_path(product_id: book.id), method: :post, class: 'btn btn-default' %></p>
    <% end %>
  </div>
</div>

<div class="row marketing">
  <h2>MUSIC</h2>
  <div class="col-lg-12">
    <% @musics.each do |music| %>
      <h3><%= music.title %></h3>
      <p><%= music.author %></p>
      <p><%= music.published_on %></p>
      <p><%= music.play_time %> 分</p>
      <p><%= number_to_currency(music.try(:price), precision: 0, unit: "円") %><%= link_to 'カートに入れる', line_items_path(product_id: music.id), method: :post, class: 'btn btn-default' %></p>
    <% end %>
  </div>
</div>
```

##### config/locales/models.ja.ymlを編集
```
ja:
  admin: '管理者'
  general: '一般'
  activerecord:
    attributes:
      user:
        name: 名前
        email: メールアドレス
        role: 役割
        password: パスワード
        password_confirmation: パスワード（確認用）
      product:
        title: タイトル
        showing: 発売
        price: 価格
        author: 著者
        while: ～
      book:
        author: 著者
        published_on: 出版日
      music:
        author: アーティスト
        published_on: 発売日
        play_time: 再生時間
      order:
        shipping_address: 配送先
        status: 状況
        user_id: ユーザ名
      tag:
        name: タグ名
      tagging:
        book_id: 本
        tag_id: タグ
    enum:
      order:
        status:
          order_accepted: 注文受付
          paid: 入金済み
          delivered: 配送済み
```
