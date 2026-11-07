```julia
show(io::IO, mime, x)
```

最終的に、[`display`](@ref) 関数は `show` を呼び出し、可能であれば、オブジェクト `x` を指定された `mime` 型として、指定された I/O ストリーム `io`（通常はメモリバッファ）に書き込みます。ユーザー定義型 `T` の豊かなマルチメディア表現を提供するには、`T` に対する新しい `show` メソッドを、次のように定義するだけで十分です。`show(io, ::MIME"mime", x::T) = ...`。ここで、`mime` は MIME タイプを表す文字列であり、関数本体では [`write`](@ref)（または同様の関数）を呼び出して、その表現の `x` を `io` に書き込みます。（なお、`MIME""` 記法で指定できるのはリテラル文字列のみです。より柔軟に `MIME` 型を構築するには、`MIME{Symbol("")}` を使用してください。）

たとえば、`MyImage` 型を定義し、それを PNG ファイルに書き込む方法がわかっている場合、関数 `show(io, ::MIME"image/png", x::MyImage) = ...` を定義すれば、PNG に対応した任意の `AbstractDisplay`（IJulia など）で画像を表示できるようになります。Julia 組み込み関数 `show` に新しいメソッドを追加するには、通常どおり `import Base.show` を忘れずに行ってください。

技術的には、`MIME"mime"` マクロは、指定された `mime` 文字列に対するシングルトン型を定義します。これにより、Julia のディスパッチ機構を利用して、任意の型のオブジェクトをどのように表示するかを決定できます。

デフォルトの MIME タイプは `MIME"text/plain"` です。`text/plain` 出力にはフォールバック定義があり、これは2引数の `show` を呼び出すため、このケースでは必ずしもメソッドを追加する必要はありません。ただし、型に人間が読みやすい独自の出力が適している場合は、`show(::IO, ::MIME"text/plain", ::T)` を定義してください。たとえば、`Day` 型では、`text/plain` MIME タイプの出力に `1 day` を使用し、2引数の `show` の出力には `Day(1)` を使用します。

# Examples

```jldoctest
julia> struct Day
           n::Int
       end

julia> Base.show(io::IO, ::MIME"text/plain", d::Day) = print(io, d.n, " day")

julia> Day(1)
1 day
```

コンテナ型では通常、3引数の `show` を実装する際、要素 `x` に対して `show(io, MIME"text/plain"(), x)` を呼び出します。その際、最初の引数として渡す [`IOContext`](@ref) では、`:compact => true` を設定します。
