# README

Setup

```
$ bundle install
$ rails db:migrate
$ rails db:seed
$ RAILS_ENV=test rails db:migrate
$ RAILS_ENV=test rails db:seed
```

### セッション格納用のCartモデルを作成
`rails generate scaffold Cart`
```
  invoke  active_record
  create    db/migrate/20161227043247_create_carts.rb
  create    app/models/cart.rb
  invoke    rspec
  create      spec/models/cart_spec.rb
  invoke  resource_route
   route    resources :carts
  invoke  scaffold_controller
  create    app/controllers/carts_controller.rb
  invoke    erb
  create      app/views/carts
  create      app/views/carts/index.html.erb
  create      app/views/carts/edit.html.erb
  create      app/views/carts/show.html.erb
  create      app/views/carts/new.html.erb
  create      app/views/carts/_form.html.erb
  invoke    rspec
  create      spec/controllers/carts_controller_spec.rb
  create      spec/views/carts/edit.html.erb_spec.rb
  create      spec/views/carts/index.html.erb_spec.rb
  create      spec/views/carts/new.html.erb_spec.rb
  create      spec/views/carts/show.html.erb_spec.rb
  create      spec/routing/carts_routing_spec.rb
  invoke      rspec
  create        spec/requests/carts_spec.rb
  invoke    helper
  create      app/helpers/carts_helper.rb
  invoke      rspec
  create        spec/helpers/carts_helper_spec.rb
  invoke    jbuilder
  create      app/views/carts/index.json.jbuilder
  create      app/views/carts/show.json.jbuilder
  create      app/views/carts/_cart.json.jbuilder
  invoke  assets
  invoke    coffee
  create      app/assets/javascripts/carts.coffee
  invoke    scss
  create      app/assets/stylesheets/carts.scss
  invoke  scss
identical    app/assets/stylesheets/scaffolds.scss
```
### マイグレーション実行
`rails db:migrate`

### カートの作成機能を追加
#### セッション情報を取得する、無ければ新たに作成するメソッド実装
##### app/controller/application_controller.rbに追加
```
private

  def current_cart 
    Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    cart = Cart.create
    session[:cart_id] = cart.id
    cart
  end
```

### ショッピングカート用の商品明細モデルを作成
`rails generate scaffold LineItem product:references cart:references quantity:integer`

```
  invoke  active_record
  create    db/migrate/20161227044258_create_line_items.rb
  create    app/models/line_item.rb
  invoke    rspec
  create      spec/models/line_item_spec.rb
  invoke  resource_route
   route    resources :line_items
  invoke  scaffold_controller
  create    app/controllers/line_items_controller.rb
  invoke    erb
  create      app/views/line_items
  create      app/views/line_items/index.html.erb
  create      app/views/line_items/edit.html.erb
  create      app/views/line_items/show.html.erb
  create      app/views/line_items/new.html.erb
  create      app/views/line_items/_form.html.erb
  invoke    rspec
  create      spec/controllers/line_items_controller_spec.rb
  create      spec/views/line_items/edit.html.erb_spec.rb
  create      spec/views/line_items/index.html.erb_spec.rb
  create      spec/views/line_items/new.html.erb_spec.rb
  create      spec/views/line_items/show.html.erb_spec.rb
  create      spec/routing/line_items_routing_spec.rb
  invoke      rspec
  create        spec/requests/line_items_spec.rb
  invoke    helper
  create      app/helpers/line_items_helper.rb
  invoke      rspec
  create        spec/helpers/line_items_helper_spec.rb
  invoke    jbuilder
  create      app/views/line_items/index.json.jbuilder
  create      app/views/line_items/show.json.jbuilder
  create      app/views/line_items/_line_item.json.jbuilder
  invoke  assets
  invoke    coffee
  create      app/assets/javascripts/line_items.coffee
  invoke    scss
  create      app/assets/stylesheets/line_items.scss
  invoke  scss
identical    app/assets/stylesheets/scaffolds.scss
```

##### db/migrate/20161227044258_create_line_items.rbを編集
 - 個数について初期値を追加の編集対応
```
class CreateLineItems < ActiveRecord::Migration[5.0]
  def change
    create_table :line_items do |t|
      t.references :product, foreign_key: true
      t.references :cart, foreign_key: true
      # 初期値を追加設定
      t.integer :quantity, default:1

      t.timestamps
    end
  end
end
```

### マイグレーション実行
`rails db:migrate`

### modelの関連付けを行う
##### app/models/cart.rbを編集
 - 商品明細の紐づけの編集を行う（1:N）
 - カート削除時は、明細も合わせて削除を行う
```
class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy
end
```

##### app/models/product.rbを編集
 - 商品明細の紐づけの編集を行う（1:N）
```
class Product < ApplicationRecord
  has_many :line_items
end
```

### カート登録機能を新規登録
##### app/models/cart.rbを編集
 - カート登録機能追加の編集を行う
 - カート合計金額集計機能追加の編集を行う
 - カート合計個数集計機能追加の編集を行う
```
  def add_product(product_id)
    current_item = line_items.find_by_product_id(product_id)
    if current_item
      current_item.quantity += 1
    else
      current_item = line_items.build(:product_id => product_id)
    end
    current_item
  end

  def total_price
    line_items.to_a.sum { |item| item.total_price }
  end

  def total_number
    line_items.to_a.sum { |item| item.quantity }
  end
```

##### app/models/line_item.rbを編集
 - カート明細小計計金額集計機能追加の編集を行う
```
  def total_price
    product.price * quantity
  end
```

##### app/controllers/line_items_controller.rbを編集
 - セッション情報に商品情報をセットする機能追加の編集を行う
```
  # POST /line_items
  # POST /line_items.json
  def create
    @cart = current_cart
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product.id)
    @line_item.product = product

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to(@line_item.cart) }
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end
```

##### app/controllers/carts_controller.rbを編集
 - リダイレクト先のcarts/showの表示制御の編集を行う
```
  # GET /carts/1
  # GET /carts/1.json
  def show
    begin
      @cart = Cart.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to carts_url, :notice => 'Invalid cart'
    else
      render layout: 'front'
    end
  end
```

##### app/views/carts/show.html.erbを編集
 - リダイレクト先のcarts/showの画面の編集を行う
```
<% if notice %>
<p id="notice"><%= notice %></p>
<% end %>
 
<h2 class="sub-header">カート</h2>
<table class="table-striped table">
  <% @cart.line_items.each do |item| %>
    <tr>
      <td><%= item.product.title %></td>
      <td>&times;<%= item.quantity %></td>
      <td class="item_price"><%= number_to_currency(item.total_price) %></td>
    </tr>
  <% end %>
 
  <tr>
    <td colspan="2">合計</td>
    <td class="total_cell"><%= number_to_currency(@cart.total_price) %></td>
  </tr>
</table>

<%= link_to '購入を続ける', products_index_path, class: 'btn btn-default' %>
```

##### app/views/products/index.html.erbを編集
 - TOP画面の購入ボタンをカート追加ボタンに変更
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

<div class="row marketing">
  <h2>BOOK</h2>
  <div class="col-lg-12">
    <% @books.each do |book| %>
      <h3><%= book.title %></h3>
      <p><%= book.author %></p>
      <p><%= book.published_on %></p>
      <p><%= number_to_currency(book.try(:price), precision: 0, unit: "円") %><%= link_to '購入', new_order_path(product_id: book.id), class: 'btn btn-default' %></p>
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
      <p><%= number_to_currency(music.try(:price), precision: 0, unit: "円") %><%= link_to '購入', new_order_path(product_id: music.id), class: 'btn btn-default' %></p>
    <% end %>
  </div>
</div>
```

### カート空にする機能を追加登録
##### app/controllers/carts_controller.rbを編集
 - カート削除機能の編集を行う
```
  # DELETE /carts/1
  # DELETE /carts/1.json
  def destroy
    @cart = current_cart
    @cart.destroy
    session[:cart_id] = nil
 
    respond_to do |format|
      format.html { redirect_to products_index_url, notice: 'Cart was successfully destroyed.' }
      format.xml  { head :no_content }
    end
  end
```

##### app/views/carts/show.html.erbを編集
 - カートを空にするボタン追加編集を行う
```
<% if notice %>
<p id="notice"><%= notice %></p>
<% end %>
 
<h2 class="sub-header">カート</h2>
<table class="table-striped table">
  <% @cart.line_items.each do |item| %>
    <tr>
      <td><%= item.product.title %></td>
      <td>&times;<%= item.quantity %></td>
      <td class="item_price"><%= number_to_currency(item.total_price) %></td>
    </tr>
  <% end %>
 
  <tr>
    <td colspan="2">合計</td>
    <td class="total_cell"><%= number_to_currency(@cart.total_price) %></td>
  </tr>
</table>

<%= link_to '購入を続ける', products_index_path, class: 'btn btn-default' %>
<%= link_to 'カートを空にする', cart_path(id: @cart.id), method: :delete, class: 'btn btn-default' %>
```

### カートからの購入機能を変更登録
##### app/models/order.rbを編集を編集
 - カートから複数明細の登録を行うように編集を行う
```
class Order < ApplicationRecord
  include AASM
  
  enum status: { order_accepted: 0, paid: 1, delivered: 2 }
  
  aasm column: :status do
    state :order_accepted, initial: true
    state :paid
    state :delivered
    
    event :confirm_payment do
      transitions from: :order_accepted, to: :paid
    end
    
    event :deliver do
      transitions from: :paid, to: :delivered
    end
  end
  
  belongs_to :user
  has_one :order_detail
  after_commit :send_order_mail, on: :create
  
  def checkout(cart)
    cart.line_items.each do |line_item|
      line_item.quantity.times do |_i| 
        build_order_detail(product_id: line_item.product_id)
      end
    end
    save!
  end
  
private

  def send_order_mail
    OrderMailer.completed_mail(self).deliver
  end
  
end
```

##### app/views/carts/show.html.erbを編集
 - 購入するボタン追加編集を行う
```
<% if notice %>
<p id="notice"><%= notice %></p>
<% end %>
 
<h2 class="sub-header">カート</h2>
<table class="table-striped table">
  <% @cart.line_items.each do |item| %>
    <tr>
      <td><%= item.product.title %></td>
      <td>&times;<%= item.quantity %></td>
      <td class="item_price"><%= number_to_currency(item.total_price) %></td>
    </tr>
  <% end %>
 
  <tr>
    <td colspan="2">合計</td>
    <td class="total_cell"><%= number_to_currency(@cart.total_price) %></td>
  </tr>
</table>

<%= link_to '購入を続ける', products_index_path, class: 'btn btn-default' %>
<%= link_to '購入する', new_order_path, class: 'btn btn-default' %>
<%= link_to 'カートを空にする', cart_path(id: @cart.id), method: :delete, class: 'btn btn-default' %>
```

##### app/controllers/orders_controller.rbを編集
 - カートから複数明細の登録を行うように編集を行う
```
  # GET /orders/new
  def new
    @cart = current_cart
    if @cart.line_items.empty?
      redirect_to products_index_url
      return
    end
    @order = Order.new
    render layout: 'front'
  end
  
  # POST /orders
  # POST /orders.json
  def create
    @cart = current_cart
    @order = Order.new(user_id: order_params[:user_id], shipping_address: order_params[:shipping_address])
    @order.checkout(@cart)
    
    respond_to do |format|
      Cart.destroy(session[:cart_id])
      session[:cart_id] = nil
      format.html { redirect_to products_index_url, notice: 'Order was successfully created.' }
      format.json { render :show, status: :created, location: @order }
    end
  rescue
    respond_to do |format|
      format.html { render :new }
      format.json { render json: @order.errors, status: :unprocessable_entity }
    end
  end
```

##### app/views/orders/new.html.erbを編集
 - 複数明細表示できるように編集を行う
```
<h1>商品購入</h1>

<%= render 'form', order: @order, cart: @cart %>

<br>

<%= link_to '戻る', cart_path(id: session[:cart_id]), class: 'btn btn-default'  %>
```

##### app/views/orders/_form.html.erbを編集
 - 複数明細表示できるように編集を行う
```
<%= form_for(order) do |f| %>
  <% if order.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(order.errors.count, "error") %> prohibited this order from being saved:</h2>

      <ul>
      <% order.errors.full_messages.each do |message| %>
        <li><%= message %></li>
      <% end %>
      </ul>
    </div>
  <% end %>

  <h2 class="sub-header">商品</h2>
  <ul class="list-group">
    <% cart.line_items.each do |line_item| %> 
      <li class="list-group-item">
        <p>
          <strong>タイトル：</strong> 
          <%= line_item.product.title %>
        </p>
        <p>
          <strong>個数：</strong>
           <%= number_to_currency(line_item.quantity, precision: 0, unit: "個") %>
        </p>
        <p>
          <strong>小計金額：</strong>
           <%= number_to_currency(line_item.total_price, precision: 0, unit: "円") %>
        </p>
      </li>
    <% end %> 
    <li class="list-group-item">
      <p>
        <strong>合計金額：</strong>
        <%= number_to_currency(cart.total_price, precision: 0, unit: "円") %>
      </p>
    </li>
  </ul>
  

  <h2 class="sub-header">お客様情報</h2>
  <ul class="list-group">
    <li class="list-group-item">
      <p>
        <strong>氏名：</strong>
        <%= current_user.name %>
      </p>
    </li>
      
    <li class="list-group-item">
      <p>
        <strong>メールアドレス：</strong>
        <%= current_user.email %>
      </p>
    </li>
  </ul>
  
  <div class="form-group">
    <%= f.label :shipping_address %>
    <%= f.text_field :shipping_address, class: "form-control" %>
  </div>

  <%= f.hidden_field :user_id, value: current_user.id %>

  <div class="actions">
    <%= f.submit '購入確定', class: "btn btn-default", data: { confirm: 'この内容で購入してもよろしいですか？' } %>
  </div>
<% end %>
```
