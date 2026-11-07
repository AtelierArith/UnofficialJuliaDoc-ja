```julia
IOContext(io::IO, KV::Pair...)
```

指定したストリームをラップし、そのストリームのプロパティに指定した`key=>value`のペアを追加する`IOContext`を作成します（`io`自体が`IOContext`である場合もあります）。

  * この組み合わせがプロパティセットに含まれているかどうかを確認するには、`(key => value) in io`を使用します。
  * 特定のキーの最新の値を取得するには、`get(io, key, default)`を使用します。

よく使われるプロパティは次のとおりです。

  * `:compact`: 値をより簡潔に出力する（たとえば、数値の桁数を減らす）ことを指定するBooleanです。配列要素の出力時に設定されます。`:compact`の出力に改行を含めてはいけません。
  * `:limit`: コンテナを省略表示する（たとえば、ほとんどの要素の代わりに`…`を表示する）ことを指定するBooleanです。
  * `:displaysize`: テキスト出力に使用する行数と列数を示す`Tuple{Int,Int}`です。呼び出された関数の表示サイズを上書きするために使用できますが、画面サイズを取得するには`displaysize`関数を使用してください。
  * `:typeinfo`: 表示しようとしているオブジェクトの型について、すでに出力された情報を表す`Type`です。主に、同じ型のオブジェクトのコレクションを表示する際に、型情報の重複を避けるために使います（たとえば、`[Float16(0)]`を「Float16[Float16(0.0)]」ではなく「Float16[0.0]」と表示できます。配列の要素を表示する間、`:typeinfo`プロパティは`Float16`に設定されます）。
  * `:color`: ANSIカラー／エスケープコードがサポートされている、または必要とされているかを指定するBooleanです。デフォルトでは、`io`が互換性のある端末かどうかと、`julia`の起動時に指定された`--color`コマンドラインフラグに基づいて決まります。

# Examples

```jldoctest
julia> io = IOBuffer();

julia> printstyled(IOContext(io, :color => true), "string", color=:red)

julia> takestring!(io)
"\e[31mstring\e[39m"

julia> printstyled(io, "string", color=:red)

julia> takestring!(io)
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
