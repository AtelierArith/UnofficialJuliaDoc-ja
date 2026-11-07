```julia
replace([io::IO], s::AbstractString, pat=>r, [pat2=>r2, ...]; [count::Integer])
```

`s` 内で指定されたパターン `pat` を検索し、一致する各箇所を `r` に置き換えます。`count` が指定されている場合、置換する箇所は最大 `count` 個です。`pat` には、単一の文字、文字のベクトルまたは集合、文字列、正規表現を指定できます。`r` が関数の場合、一致する各箇所は `r(s)` に置き換えられます。ここで `s` は、`pat` が `AbstractPattern` または `AbstractString` の場合は一致した部分文字列、`pat` が `AbstractChar` または `AbstractChar` のコレクションの場合は一致した文字です。`pat` が正規表現で、`r` が [`SubstitutionString`](@ref) の場合、`r` 内のキャプチャグループへの参照は、対応する一致テキストに置き換えられます。`string` から `pat` に一致する箇所を削除するには、`r` に空の `String`（`""`）を設定します。

戻り値は、置換後の新しい文字列です。`io::IO` 引数が指定されている場合は、代わりに変換後の文字列を `io` に書き込み、`io` を返します。（たとえば、[`IOBuffer`](@ref) と組み合わせることで、事前に確保したバッファ配列をその場で再利用できます。）

複数のパターンを指定できます。入力文字列は先頭（左）から末尾（右）まで一度だけ走査され、各部分文字列には最初に一致した置換が適用されます。入力文字列の同じ位置から始まる部分文字列に複数のパターンが一致する場合は、指定された引数の順に置換が適用されます。したがって、各文字に適用されるパターンは1つだけであり、パターンは入力テキストにのみ適用され、置換後のテキストには適用されません。

!!! compat "Julia 1.7"
    複数のパターンを使用するには、バージョン1.7以降が必要です。


!!! compat "Julia 1.10"
    `io::IO` 引数を使用するには、バージョン1.10以降が必要です。


# Examples

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
