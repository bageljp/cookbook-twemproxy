What's ?
===============
chef で使用する Twemproxy の cookbook です。

Usage
-----
cookbook なので berkshelf で取ってきて使いましょう。

* Berksfile
```ruby
source "https://supermarket.chef.io"

cookbook "twemproxy", git: "https://github.com/bageljp/cookbook-twemproxy.git"
```

```
berks vendor
```

#### Role and Environment attributes

* sample_role.rb
```ruby
override_attributes(
  "twemproxy" => {
    "install_flavor" => "rpm",
    "backend" => {
      "server => "172.31.0.101"
    }
  }
)
```

Recipes
----------

#### twemporxy::default
Twermproxy のインストールと設定。
事前にrpmbuildしてrpmを作成しておく必要がある。

Attributes
----------

主要なやつのみ。

#### twemproxy::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
  </tr>
  <tr>
    <td><tt>['twemproxy']['backend']['server']</tt></td>
    <td>string</td>
    <td>プロキシ先のバックエンドサーバのIPアドレス。</td>
  </tr>
  <tr>
    <td><tt>['twemproxy']['rpm']['url']</tt></td>
    <td>string</td>
    <td>rpmでインストールする場合にrpmが置いてあるURL。rpmbuildしたものをs3とかに置いておくといいかも。</td>
  </tr>
</table>

TODO
----------

* rpmbuildの作業もrecipe化出来るといいかも。
