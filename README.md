# README

Setup

```
$ bundle install
$ rails db:migrate
$ rails db:seed
$ RAILS_ENV=test rails db:migrate
$ RAILS_ENV=test rails db:seed
```

### ordersテーブルに状態管理用のカラム追加

`rails g migration AddStatusToOrders status:integer`

```
invoke  active_record
create    db/migrate/20161222083127_add_status_to_orders.rb
```


`status`のデフォルト値を設定するために`20161222083127_add_status_to_orders.rb`を変更

変更前
```
def change
  add_column :products, :status, :integer
end
```

変更後
```
def change
  add_column :orders, :status, :integer, default: 0
end
```

`rails db:migrate`を実行

`models.ja.yml`にstatusを追加する。

### 注文管理画面の作成
`rails g controller orders_management`

```
create  app/controllers/orders_management_controller.rb
invoke  erb
create    app/views/orders_management
invoke  rspec
create    spec/controllers/orders_management_controller_spec.rb
invoke  helper
create    app/helpers/orders_management_helper.rb
invoke    rspec
create      spec/helpers/orders_management_helper_spec.rb
invoke  assets
invoke    coffee
create      app/assets/javascripts/orders_management.coffee
invoke    scss
create      app/assets/stylesheets/orders_management.scss
```

`routes.rb`に`resources :orders_management, only: [:index, :edit, :update]`を追加する。

### 状態遷移機能の追加
#### aasmのインストール
`Gemfile`に`gem 'aasm'`を追加し、`bundle install`

#### OrderモデルにAASMの設定を追加する
```
include AASM

enum status: { order_accepted: 0, paid: 1, delivered: 2 }

aasm column: :status, enum: true do
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
```


#### 注文一覧画面の作成

`orders_management_controller.rb`に`index`メソッドを追加する。

`index.html.erb`を作成する。

#### OrderモデルにAASMの設定を追加する

`models.ja.yml`に以下を追加する。

```
ja:
  activerecord:
    enum:
      order:
        status:
          order_accepted: 注文受付
          paid: 入金済み
          delivered: 配送済み
```

#### 注文編集画面の作成
`order_management_controller.rb`に`edit`メソッドと`update`メソッドを追加する。

`edit.html.erb`と`_form.html.erb`を作成する。

`routes.rb`に以下を修正する。

変更前
```
resources :orders_management, only: [:index, :edit, :update]
```

変更後
```
resources :orders_management, only: [:index, :edit] do
  put :confirm_payment
  put :deliver
end
```