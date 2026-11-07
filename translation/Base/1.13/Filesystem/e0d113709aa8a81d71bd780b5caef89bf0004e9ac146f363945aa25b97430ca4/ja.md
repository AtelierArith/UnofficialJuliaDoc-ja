```julia
joinpath(parts::AbstractString...)::String
joinpath(parts::Vector{AbstractString})::String
joinpath(parts::Tuple{AbstractString})::String
```

パスの各要素を結合して、完全なパスを作成します。引数のいずれかが絶対パスである場合、または（Windows で）先行するパスを結合して得られるドライブと異なるドライブ指定を持つ場合、それより前の要素は破棄されます。

Windows ではドライブごとにカレントディレクトリがあるため、`joinpath("c:", "foo")`はドライブ「c:」のカレントディレクトリからの相対パスを表します。したがって、これは「c:\foo」ではなく「c:foo」と同じです。さらに、`joinpath`はこれを絶対パスではないものとして扱い、ドライブ文字の大文字・小文字を区別しないため、`joinpath("C:\\A","c:b") = "C:\\A\\b"`となります。

# Examples

```jldoctest
julia> joinpath("/home/myuser", "example.jl")
"/home/myuser/example.jl"
```

```jldoctest
julia> joinpath(["/home/myuser", "example.jl"])
"/home/myuser/example.jl"
```
