```
joinpath(parts::AbstractString...) -> String
joinpath(parts::Vector{AbstractString}) -> String
joinpath(parts::Tuple{AbstractString}) -> String
```

パスコンポーネントを結合して完全なパスを作成します。引数のいくつかが絶対パスである場合、または（Windowsの場合）ドライブ仕様が前のパスの結合で計算されたドライブと一致しない場合、以前のコンポーネントは削除されます。

Windowsでは、各ドライブに現在のディレクトリがあるため、`joinpath("c:", "foo")`はドライブ "c:" の現在のディレクトリに対する相対パスを表すため、これは "c:foo" と等しく、"c:\foo" ではありません。さらに、`joinpath` はこれを非絶対パスとして扱い、ドライブレターの大文字小文字を無視します。したがって、`joinpath("C:\A","c:b") = "C:\A\b"` となります。

# 例

```jldoctest
julia> joinpath("/home/myuser", "example.jl")
"/home/myuser/example.jl"
```

```jldoctest
julia> joinpath(["/home/myuser", "example.jl"])
"/home/myuser/example.jl"
```
