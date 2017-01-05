# README

Setup

```
$ bundle install
$ rails db:migrate
$ rails db:seed
$ RAILS_ENV=test rails db:migrate
$ RAILS_ENV=test rails db:seed
```

### 購入登録のAJAX対応
##### app\assets\javascripts\line_items.coffee
 - coffee scriptで新規追加
```
@add_cart_item = (id) ->
  $.post '/line_items/' + id + '/add_cart_item'
  false
```

##### config\initializers\assets.rb
 - coffee scriptで初期読込用に新規追加
```
Rails.application.config.assets.precompile += %w( line_items.js )
```

##### config\routes.rb
 - ajax用に新規追加
```
  resources :line_items, only: [:create] do
    member do
      post :add_cart_item
    end
  end
```

##### app\controllers\line_items_controller.rb
 - ajax用の新規追加
```
  def add_cart_item
    @cart              = current_cart
    product            = Product.find(params[:id])
    @line_item         = @cart.add_product(product.id)
    @line_item.product = product
    @line_item.save
  end
```

##### app\views\line_items\add_cart_item.js.erb
 - ajax用の新規追加
```
$("#cart_total_price").html('<%= cart_status_link(@cart) %>');
```

##### app\controllers\products_controller.rb
 - ajax用の新規追加
```
class ProductsController < ApplicationController
  
  def index
    @cart = current_cart
    @product  = Product.ransack(params[:q])
    products  = @product.result.visible
    @books    = products.books
    @musics   = products.musics
    render layout: 'front'
  end

  def about
    render layout: 'front'
  end

end
```

##### app\helpers\application_helper.rb
 - 非同期制御のリンクヘルパー追加
```
module ApplicationHelper
  def active_class(path_name)
    request.original_fullpath.include?(path_name) ? 'active' : ""
  end
  
  def cart_status_link(cart = nil)
    return if cart.blank?
    count = number_to_currency(cart.try(:total_number), precision: 0, unit: "個")
    price = number_to_currency(cart.try(:total_price), precision: 0, unit: "円")
    link_name = "カート(%s %s)" % [count, price]
    link_to(link_name, cart_path(cart))
  end
end
```
##### app\views\layouts\front.html.erb
 - 非同期制御のリンク追加
```
<html>
    <title>Monka</title>
    <%= csrf_meta_tags %>

    <%= stylesheet_link_tag    'front', media: 'all', 'data-turbolinks-track': 'reload' %>
    <%= javascript_include_tag 'front', 'data-turbolinks-track': 'reload' %>
  </head>

  <body>

    <div class="container">

      <div class="header clearfix">
        <nav>
          <ul class="nav nav-pills pull-right">
            <li id="cart_total_price"><%== cart_status_link(@cart) %></li>
            <li role="presentation" class="<%= (request.original_fullpath == '/') ? 'active' : active_class('products') %>"><%= link_to 'Home', root_path %></li>
            <li role="presentation" class="<%= active_class('about') %>"><%= link_to 'About', about_path %></li>
          </ul>
        </nav>
        <h3 class="text-muted">Monka</h3><!-- todo:githubのprj名の公表okでしょうか？ -->
      </div>

      <%= yield %>

      <footer class="footer">
        <p>&copy; 2016 文科省IT人材育成プロジェクト</p><!-- todo:prj名公表okでしょうか？ -->
        <p>code: </p><!-- todo:公開するrailsのコードの場所を書いておきたいです。 -->
      </footer>

    </div> <!-- /container -->

  </body>
</html>
```

##### app\views\products\index.html.erb
 - 非同期制御のボタンに変更対応
```
% if notice %>
  <div class="alert alert-success alert-dismissible" role="alert">
    <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
    <p id="notice"><%= notice %></p>
  </div>
<% end %>

<%= javascript_include_tag "line_items" %>
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
      <p>
        <%= number_to_currency(book.try(:price), precision: 0, unit: "円") %>
        <%= link_to "カート追加", "#",
          class:   "btn btn-default",
          onclick: "return add_cart_item(#{book.id});"%>
      </p>
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
      <p>
        <%= number_to_currency(music.try(:price), precision: 0, unit: "円") %>
        <%= link_to "カート追加", "#",
          class:   "btn btn-default",
          onclick: "return add_cart_item(#{music.id});"%>
      </p>
    <% end %>
  </div>
</div>
```



### 注文状況変更のAJAX対応
##### app\assets\javascripts\orders_management.coffee
 - coffee scriptで新規追加
```
@async_confirm_payment = (elm, id) ->
  $(elm).addClass('disabled').html '処理中です...'
  $.post '/orders_management/' + id + '/async_confirm_payment'
  false

@async_deliver = (elm, id) ->
  $(elm).addClass('disabled').html '処理中です...'
  $.post '/orders_management/' + id + '/async_deliver'
  false
```

##### config\initializers\assets.rb
 - coffee scriptで初期読込用に新規追加
```
Rails.application.config.assets.precompile += %w( orders_management.js )
```

##### config\routes.rb
 - ajax用に新規追加
```
  resources :orders_management, only: [:index, :edit] do
    put :confirm_payment
    put :deliver
    member do
      post :async_confirm_payment
      post :async_deliver
    end
  end
```

##### app\controllers\line_items_controller.rb
 - ajax用の新規追加
```
  before_action :set_order, only: [:edit, :confirm_payment, :deliver, :async_confirm_payment, :async_deliver]

  def async_confirm_payment
    @order.confirm_payment!
    
    render template: "orders_management/async_process"
  end
  
  def async_deliver
    @order.deliver!

    render template: "orders_management/async_process"
  end
```

##### app\views\orders_management\async_process.js.erb
 - ajax用の新規追加
```
var targetStatus = $("#order_table tbody tr#" + "<%= @order.id %>" + " td.status");
var targetLink   = $("#order_table tbody tr#" + "<%= @order.id %>" + " td.link");
var link;

$(targetStatus).html("<%= I18n.t @order.status, scope: 'activerecord.enum.order.status' %>");

<% if @order.order_accepted? %>
  link = '<%= link_to "入金確認", async_confirm_payment_orders_management_path(@order), remote: true, method: :post, class: "btn btn-default" %>';
<% elsif @order.paid? %>
  link = '<%= link_to "配送", async_deliver_orders_management_path(@order), remote: true, method: :post, class: "btn btn-default" %>';
<% else %>
  link = '';
<% end %>

$(targetLink).html(link);
```

##### app\views\orders_management\index.html.erb
 - 一覧テーブルに非同期制御のボタン追加
```
<%= javascript_include_tag "orders_management" %>

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
  <table id="order_table" class="table table-striped">
    <thead>
      <tr>
        <th>購入者</th>
        <th>送付先</th>
        <th>金額</th>
        <th>状態</th>
        <th></th>
        <th colspan="2"></th>
      </tr>
    </thead>
    <tbody>
      <% @orders.each do |order| %>
        <tr id="<%= order.id %>">
          <td><%= order.user.name %></td>
          <td><%= order.shipping_address %></td>
          <td><%= order.order_detail.product.price %></td>
          <td class="status">
            <%= I18n.t order.status, scope: 'activerecord.enum.order.status' %>
          </td>
          <td class="link">
            <% if order.order_accepted? %>
              <%= link_to '入金確認', "#",
                onclick: "return async_confirm_payment(this, #{order.id});",
                class:   'btn btn-default' %>
            <% elsif order.paid? %>
              <%= link_to '配送', "#",
                onclick: "return async_deliver(this, #{order.id});",
                class:   'btn btn-default' %>
            <% end %>
          </td>
          <td><%= link_to '編集', edit_orders_management_path(order) %></td>
        </tr>
      <% end %>
    </tbody>
  </table>
</div>
```

