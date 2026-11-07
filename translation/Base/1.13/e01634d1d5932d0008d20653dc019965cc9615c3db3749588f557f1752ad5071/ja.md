```julia
replace([io::IO], s::AbstractString, pat=>r, [pat2=>r2, ...]; [count::Integer])
```

`pat`で指定したパターンを`s`内で検索し、一致する箇所をそれぞれ`r`に置き換えます。`count`が指定されている場合、置換は最大`count`回まで行われます。`pat`には、単一の文字、文字のベクトルまたは集合、文字列、あるいは正規表現を指定できます。`r`が関数の場合、一致箇所はそれぞれ`r(s)`に置き換えられます。ここで`s`は、一致した部分文字列（`pat`が`AbstractPattern`または`AbstractString`の場合）、または一致した文字（`pat`が`AbstractChar`または`AbstractChar`のコレクションの場合）です。`pat`が正規表現で、`r`が[`SubstitutionString`](@ref)の場合、`r`内のキャプチャグループ参照は、対応する一致テキストに置き換えられます。`string`から`pat`を削除するには、`r`に空の`String`（`""`）を指定します。

戻り値は、置換後の新しい文字列です。`io::IO`引数を指定すると、変換後の文字列は代わりに`io`に書き込まれ、`io`が返されます。（たとえば、[`IOBuffer`](@ref)と組み合わせることで、事前に確保したバッファ配列をその場で再利用できます。）

複数のパターンを指定できます。入力文字列は先頭（左）から末尾（右）へ一度だけ走査され、各部分文字列には最初に一致した置換が適用されます。同じ入力位置から始まる部分文字列に一致する場合、置換は引数に指定した順に適用されます。したがって、各文字に適用されるパターンは1つだけであり、パターンは入力テキストにのみ適用され、置換後の文字列には適用されません。

!!! compat "Julia 1.7"
    複数パターンのサポートにはバージョン1.7が必要です。


!!! compat "Julia 1.10"
    `io::IO`引数にはバージョン1.10が必要です。


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
