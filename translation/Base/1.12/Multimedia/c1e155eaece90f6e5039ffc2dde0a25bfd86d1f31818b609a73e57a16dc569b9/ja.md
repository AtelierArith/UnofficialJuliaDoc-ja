```julia
show(io::IO, mime, x)
```

[`display`](@ref) 関数は最終的に `show` を呼び出して、オブジェクト `x` を指定された `mime` タイプで指定された I/O ストリーム `io`（通常はメモリバッファ）に書き込みます。ユーザー定義型 `T` のリッチなマルチメディア表現を提供するためには、`T` のために新しい `show` メソッドを定義するだけで済みます。具体的には、`show(io, ::MIME"mime", x::T) = ...` のように定義します。ここで `mime` は MIME タイプの文字列で、関数本体は [`write`](@ref)（または類似のもの）を呼び出して `x` のその表現を `io` に書き込みます。（`MIME""` 表記はリテラル文字列のみをサポートすることに注意してください。より柔軟に `MIME` タイプを構築するには `MIME{Symbol("")}` を使用します。）

例えば、`MyImage` 型を定義し、それを PNG ファイルに書き込む方法を知っている場合、`show(io, ::MIME"image/png", x::MyImage) = ...` という関数を定義して、あなたの画像が PNG 対応の任意の `AbstractDisplay`（IJulia など）で表示されるようにすることができます。通常通り、組み込みの Julia 関数 `show` に新しいメソッドを追加するために `import Base.show` を忘れないでください。

技術的には、`MIME"mime"` マクロは指定された `mime` 文字列のためのシングルトン型を定義し、これにより任意の型のオブジェクトを表示する方法を決定する際に Julia のディスパッチメカニズムを利用することができます。

デフォルトの MIME タイプは `MIME"text/plain"` です。`text/plain` 出力のためのフォールバック定義があり、2 引数で `show` を呼び出すため、その場合にメソッドを追加する必要は常にありません。ただし、型がカスタムの人間可読出力から利益を得る場合、`show(::IO, ::MIME"text/plain", ::T)` を定義するべきです。例えば、`Day` 型は `text/plain` MIME タイプの出力として `1 day` を使用し、2 引数の `show` の出力として `Day(1)` を使用します。

# 例

```jldoctest
julia> struct Day
           n::Int
       end

julia> Base.show(io::IO, ::MIME"text/plain", d::Day) = print(io, d.n, " day")

julia> Day(1)
1 day
```

コンテナ型は一般的に、要素 `x` に対して `show(io, MIME"text/plain"(), x)` を呼び出すことで 3 引数の `show` を実装し、最初の引数として渡される [`IOContext`](@ref) で `:compact => true` を設定します。
