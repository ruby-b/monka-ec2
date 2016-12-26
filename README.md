# README

### Product���f���̍쐬

`rails g model product type:string title:string author:string published_on:date showing:boolean price:integer`

    invoke  active_record
    create    db/migrate/20161221002055_create_products.rb
    create    app/models/product.rb
    invoke    rspec
    create    spec/models/product_spec.rb

### books��products�ւ̃f�[�^�ڍs����

20161221002055_create_products.rb�Ƀf�[�^�ڍs�������L�q

    books = Book.all
    books.each do |book|
      product = Product.new(book.attributes)
      product.type = 'Book'
      product.save
    end

### books�e�[�u���폜

`rails g migration drop_table_books`

    invoke  active_record
    create  db/migrate/20161221002132_drop_table_books.rb

20161221002132_drop_table_books.rb�Ƀe�[�u���폜�������L�q

    def change
      drop_table :books
    end

��change���\�b�h�ɋL�q�����ꍇ�Arollback����ƃG���[�ɂȂ�Bup/down�ɕ����ċL�ڂ���H

### �}�C�O���[�V�������s
`rails db:migrate`

### Book���f���̌p������Product���f���ɕύX
`class Book < ApplicationRecord`
��
`class Book < Product`
�ɕύX�B

### Rspec�̎��s�i���������ɉe�����o�Ă��Ȃ����Ƃ̊m�F�j
�������_�ł�Rspec�����Ȃ�

### Music���f���̍쐬
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

��musics�e�[�u���͍쐬���Ȃ��̂ŁA`20161221002316_create_musics.rb`�͍폜

### products�e�[�u����music�p�J�����ǉ�
`rails g migration AddPlayTimeToProducts play_time:integer`

```
invoke  active_record
create  db/migrate/20161221003321_add_play_time_to_products.rb
```

`rails db:migrate`

### musics�p�̊Ǘ���ʍ쐬

#### musics_controller.rb�̕ύX
 - `before_action :authenticate_user!`�̒ǉ�
 - `music_params`���\�b�h�̕ύX

```
def music_params
  params.require(:music).permit(:title, :author, :published_on, :showing, :price, :play_time)
end
```

#### music.rb�̕ύX
 - �p������`ApplicationRecord`����`Product`�ɕύX
 - `scope :visible, ->(){ where(showing: true) }`�̒ǉ�
 - �^�O����͕ۗ�

#### view�̕ύX(index, _form, edit, new, show)
 - books�����Q�l��
 - author��published_on�͂��̂܂܎g���H
 - �^�O����͕ۗ�

#### models.ja.yml�̕ύX
author��published_on�����̂܂܎g���O��ŁB

    music:
      title: �^�C�g��
      author: �A�[�e�B�X�g
      published_on: ������
      showing: ����
      price: ���i
      play_time: �Đ�����

### ����pTOP�y�[�W��Music��\��
#### products_controller.rb�̕ύX
`index`���\�b�h��`@musics = Music.visible.all`��ǉ�

#### products/index.html.erb�̕ύX
 - book�Ɠ����悤��music��\������
 - book��music�̕\���J�n�ʒu�ɂ��ꂼ��A`BOOK`,`MUSIC`��\������

### �T�C�h���j���[��Musics�ǉ�
`layouts/application.html.erb`�̕ύX

```
<li class="<%= active_class('musics') %>"><%= link_to 'Musics', musics_path %></li>
```

### music�p��spec�쐬
book�����Q�l�ɏC��

