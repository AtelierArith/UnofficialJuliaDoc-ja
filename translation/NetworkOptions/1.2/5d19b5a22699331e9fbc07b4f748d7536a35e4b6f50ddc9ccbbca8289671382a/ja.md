```
verify_host(url::AbstractString, [transport::AbstractString]) :: Bool
```

`verify_host` 関数は、TLS や SSH のような安全なトランスポートを介して通信する際に、ホストのアイデンティティを検証すべきかどうかを呼び出し元に伝えます。`url` 引数は次のいずれかです：

1. `proto://` で始まる適切な URL
2. `ssh` スタイルのベアホスト名または `user@` で接頭辞が付けられたホスト名
3. 上記の `scp` スタイルのホストの後に `:` とパスの位置が続く

いずれの場合も、ホスト名部分が解析され、検証するかどうかの決定は入力 URL の他の要素に基づかず、ホスト名のみに基づいて行われます。特に、URL のプロトコルは重要ではありません（詳細は以下）。

`transport` 引数は、クエリがどの種類のトランスポートに関するものであるかを示します。現在知られている値は `SSL`/`ssl`（エイリアス `TLS`/`tls`）と `SSH`/`ssh` です。トランスポートが省略された場合、ホスト名がトランスポートに関係なく検証されるべきでない場合にのみ、クエリは `true` を返します。

ホスト名は、`transport` が提供されているかどうか、またその値に応じて、関連する環境変数のホストパターンに対して照合されます：

  * `JULIA_NO_VERIFY_HOSTS` — どのトランスポートに対しても検証されるべきでないホスト
  * `JULIA_SSL_NO_VERIFY_HOSTS` — SSL/TLS に対して検証されるべきでないホスト
  * `JULIA_SSH_NO_VERIFY_HOSTS` — SSH に対して検証されるべきでないホスト
  * `JULIA_ALWAYS_VERIFY_HOSTS` — 常に検証されるべきホスト

これらの変数の各値は、次の構文を持つホスト名パターンのカンマ区切りリストです — 各パターンは `.` で分割され、各部分は次のいずれかでなければなりません：

1. 1 つ以上の ASCII 文字、数字、ハイフン、またはアンダースコアからなるリテラルドメイン名コンポーネント（技術的には合法的なホスト名の一部ではありませんが、時々使用されます）。リテラルドメイン名コンポーネントは自分自身にのみ一致します。
2. `**` は、ゼロまたはそれ以上のドメイン名コンポーネントに一致します。
3. `*` は、任意の 1 つのドメイン名コンポーネントに一致します。

これらの変数のいずれかのパターンリストに対してホスト名を照合する際、ホスト名は `.` で分割され、コンポーネントに分けられ、その単語のシーケンスがパターンに対して照合されます：リテラルパターンはその値を持つホスト名コンポーネントに正確に一致し、`*` パターンは任意の値を持つホスト名コンポーネントに正確に一致し、`**` パターンは任意の数のホスト名コンポーネントに一致します。例えば：

  * `**` は任意のホスト名に一致します
  * `**.org` は `.org` トップレベルドメイン内の任意のホスト名に一致します
  * `example.com` は正確にホスト名 `example.com` のみに一致します
  * `*.example.com` は `api.example.com` に一致しますが、`example.com` や `v1.api.example.com` には一致しません
  * `**.example.com` は `example.com` 自体、`api.example.com`、および `v1.api.example.com` を含む `example.com` の下の任意のドメインに一致します
