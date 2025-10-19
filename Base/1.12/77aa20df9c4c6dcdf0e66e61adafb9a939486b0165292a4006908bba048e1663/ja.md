```julia
replace([io::IO], s::AbstractString, pat=>r, [pat2=>r2, ...]; [count::Integer])
```

与えられたパターン `pat` を `s` の中で検索し、各出現を `r` で置き換えます。`count` が指定されている場合、最大で `count` 回の出現を置き換えます。`pat` は単一の文字、ベクターまたは文字の集合、文字列、または正規表現である可能性があります。`r` が関数である場合、各出現は `r(s)` で置き換えられ、ここで `s` は一致した部分文字列（`pat` が `AbstractPattern` または `AbstractString` の場合）または文字（`pat` が `AbstractChar` または `AbstractChar` のコレクションの場合）です。`pat` が正規表現であり、`r` が [`SubstitutionString`](@ref) の場合、`r` 内のキャプチャグループ参照は対応する一致したテキストで置き換えられます。文字列から `pat` のインスタンスを削除するには、`r` を空の `String` (`""`) に設定します。

返り値は、置き換え後の新しい文字列です。`io::IO` 引数が提供されている場合、変換された文字列は `io` に書き込まれ（`io` を返します）、そのため、事前に割り当てられたバッファ配列をそのまま再利用するために [`IOBuffer`](@ref) と組み合わせて使用できます。

複数のパターンを指定することができ、これらは左から右に同時に適用されるため、任意の文字には1つのパターンのみが適用され、パターンは置き換えではなく入力テキストにのみ適用されます。

!!! compat "Julia 1.7"
    複数のパターンのサポートにはバージョン 1.7 が必要です。


!!! compat "Julia 1.10"
    `io::IO` 引数にはバージョン 1.10 が必要です。


# 例

```jldoctest
julia> replace("Python is a programming language.", "Python" => "Julia")
"Julia is a programming language."

julia> replace("The quick foxes run quickly.", "quick" => "slow", count=1)
"The slow foxes run quickly."

julia> replace("The quick foxes run quickly.", "quick" => "", count=1)
"The  foxes run quickly."

julia> replace("The quick foxes run quickly.", r"fox(es)?" => s"bus\1")
"The quick buses run quickly."

julia> replace("abcabc", "a" => "b", "b" => "c", r".+" => "a")
"bca"
```
