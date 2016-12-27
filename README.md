# README

Setup

```
$ bundle install
$ rails db:migrate
$ rails db:seed
$ RAILS_ENV=test rails db:migrate
$ RAILS_ENV=test rails db:seed
```
### Orderモデルの作成
`rails g scaffold order user:belongs_to`

```
invoke  active_record
create    db/migrate/20161221055428_create_orders.rb
create    app/models/order.rb
invoke    rspec
create      spec/models/order_spec.rb
invoke  resource_route
 route    resources :orders
invoke  scaffold_controller
create    app/controllers/orders_controller.rb
invoke    erb
create      app/views/orders
create      app/views/orders/index.html.erb
create      app/views/orders/edit.html.erb
create      app/views/orders/show.html.erb
create      app/views/orders/new.html.erb
create      app/views/orders/_form.html.erb
invoke    rspec
create      spec/controllers/orders_controller_spec.rb
create      spec/views/orders/edit.html.erb_spec.rb
create      spec/views/orders/index.html.erb_spec.rb
create      spec/views/orders/new.html.erb_spec.rb
create      spec/views/orders/show.html.erb_spec.rb
create      spec/routing/orders_routing_spec.rb
invoke      rspec
create        spec/requests/orders_spec.rb
invoke    helper
create      app/helpers/orders_helper.rb
invoke      rspec
create        spec/helpers/orders_helper_spec.rb
invoke    jbuilder
create      app/views/orders/index.json.jbuilder
create      app/views/orders/show.json.jbuilder
create      app/views/orders/_order.json.jbuilder
invoke  assets
invoke    coffee
create      app/assets/javascripts/orders.coffee
invoke    scss
create      app/assets/stylesheets/orders.scss
invoke  scss
```

`20161221055428_create_orders.rb`に`t.string :shipping_address`を追加  
⇒最初にコマンドで指定する
※名前とメールアドレスはどうする？ログイン前提でよいか？

### OrderDetailモデルの作成
`rails g model order_detail order:belongs_to product:belongs_to`

```
invoke  active_record
create    db/migrate/20161221060004_create_order_details.rb
create    app/models/order_detail.rb
invoke    rspec
create      spec/models/order_detail_spec.rb
```

`rails db:migrate`

`order.rb`に`has_one :order_detail`を追加

### 注文画面作成
#### routes.rbの変更
変更前
```
resources :orders
```

変更後
```
resources :orders, only: [:new, :create, :show]
```

#### 一覧に商品詳細ボタンを追加
`products/index.html.erb`

#### 商品詳細画面を追加(購入ボタンを追加)
`products/show.html.erb`

`routes.rb`を変更

変更前
`get 'products/index'`

変更後
`resources :products, only:[:index, :show]`


#### models.ja.ymlの変更
以下を追加。

```
order:
  shipping_address: 配送先
```

#### orders_controller.rbの変更

```
def new
  @order = Order.new
  @product = Product.find(params[:product_id])
  render layout: 'front'
end

def create
  ActiveRecord::Base.transaction do
    @order = Order.create(user_id: order_params[:user_id], shipping_address: order_params[:shipping_address])
    @order_detail = OrderDetail.new(product_id: order_params[:product_id])
    @order_detail.order_id = @order.id
    @order_detail.save
  end

  respond_to do |format|
    format.html { redirect_to order_path(@order), notice: 'Order was successfully created.' }
    format.json { render :show, status: :created, location: @order }
  end
rescue
  respond_to do |format|
    format.html { render :new }
    format.json { render json: @order.errors, status: :unprocessable_entity }
  end
end

def order_params
  params.require(:order).permit(:user_id, :product_id, :shipping_address)
end
```

#### Orderのビュー変更(new, _form, show)

### メール送信機能追加

#### Mailerの作成

`rails g mailer OrderMailer completed_mail`

```
create  app/mailers/order_mailer.rb
invoke  erb
create    app/views/order_mailer
create    app/views/order_mailer/completed_mail.text.erb
create    app/views/order_mailer/completed_mail.html.erb
invoke  rspec
create    spec/mailers/order_mailer_spec.rb
create    spec/fixtures/order_mailer/completed_mail
create    spec/mailers/previews/order_mailer_preview.rb
```

#### メール文章作成
`completed_mail.text.erb`と`completed_mail.html.erb`にメール本文作成

#### メール送信処理作成
`order_mailer.rb`の`completed_mail`に送信処理を作成

#### メール送信設定
TODO(kawabata):SendGridのアカウント取得できたら試す。

```
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  enable_starttls_auto: true,
  address: '<SMTPアドレス>',
  port: '587',
  domain: '<ドメイン>',
  authentication: 'plain',
  user_name: '<ユーザー名>',
  password: '<パスワード>',
}
```

#### Mailerの呼び出し
ordersとorder_detailsの登録後にメールを送信する。
