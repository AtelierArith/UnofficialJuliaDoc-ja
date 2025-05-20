```
IOContext(io::IO, KV::Pair...)
```

指定されたストリームをラップし、そのストリームのプロパティに指定された `key=>value` ペアを追加する `IOContext` を作成します（`io` 自体が `IOContext` であることもあります）。

  * `(key => value) in io` を使用して、この特定の組み合わせがプロパティセットに含まれているかどうかを確認します。
  * `get(io, key, default)` を使用して、特定のキーに対する最新の値を取得します。

以下のプロパティは一般的に使用されます：

  * `:compact`: 値がよりコンパクトに印刷されるべきかどうかを指定するブール値。例えば、数字が少ない桁数で印刷されるべきことを示します。これは配列要素を印刷する際に設定されます。`:compact` 出力には改行が含まれてはいけません。
  * `:limit`: コンテナが切り捨てられるべきかどうかを指定するブール値。例えば、ほとんどの要素の代わりに `…` を表示します。
  * `:displaysize`: テキスト出力に使用する行と列のサイズを与える `Tuple{Int,Int}`。これは呼び出された関数の表示サイズをオーバーライドするために使用できますが、画面のサイズを取得するには `displaysize` 関数を使用します。
  * `:typeinfo`: 表示されるオブジェクトの型に関してすでに印刷された情報を特徴づける `Type`。これは主に同じ型のオブジェクトのコレクションを表示する際に便利で、冗長な型情報を避けることができます（例えば、`[Float16(0)]` は "Float16[0.0]" として表示され、"Float16[Float16(0.0)]" とは表示されません：配列の要素を表示する際に、`:typeinfo` プロパティは `Float16` に設定されます）。
  * `:color`: ANSI カラー/エスケープコードがサポートされているか、期待されているかを指定するブール値。デフォルトでは、`io` が互換性のある端末であるかどうかと、`julia` が起動されたときの `--color` コマンドラインフラグによって決まります。

# 例

```jldoctest
julia> io = IOBuffer();

julia> printstyled(IOContext(io, :color => true), "string", color=:red)

julia> String(take!(io))
"\e[31mstring\e[39m"

julia> printstyled(io, "string", color=:red)

julia> String(take!(io))
"string"
```

```jldoctest
julia> print(IOContext(stdout, :compact => false), 1.12341234)
1.12341234
julia> print(IOContext(stdout, :compact => true), 1.12341234)
1.12341
```

```jldoctest
julia> function f(io::IO)
           if get(io, :short, false)
               print(io, "short")
           else
               print(io, "loooooong")
           end
       end
f (generic function with 1 method)

julia> f(stdout)
loooooong
julia> f(IOContext(stdout, :short => true))
short
```
