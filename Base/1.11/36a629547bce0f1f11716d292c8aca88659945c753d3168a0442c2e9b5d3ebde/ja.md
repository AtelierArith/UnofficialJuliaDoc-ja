```
print([io::IO], xs...)
```

`io` に書き込みます（`io` が指定されていない場合はデフォルトの出力ストリーム [`stdout`](@ref) に書き込みます）。`print` で使用される表現は、最小限のフォーマットを含み、Julia 特有の詳細を避けるようにします。

`print` は `show` を呼び出すことにフォールバックするため、ほとんどの型は単に `show` を定義すればよいです。あなたの型に別の「プレーン」表現がある場合は `print` を定義してください。たとえば、`show` は文字列を引用符付きで表示し、`print` は引用符なしで文字列を表示します。

[`println`](@ref)、[`string`](@ref)、[`printstyled`](@ref) も参照してください。

# 例

```jldoctest
julia> print("Hello World!")
Hello World!
julia> io = IOBuffer();

julia> print(io, "Hello", ' ', :World!)

julia> String(take!(io))
"Hello World!"
```
