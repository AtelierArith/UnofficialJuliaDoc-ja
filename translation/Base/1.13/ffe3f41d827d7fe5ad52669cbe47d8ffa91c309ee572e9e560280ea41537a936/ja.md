```julia
length(s::AbstractString)::Int
length(s::AbstractString, i::Integer, j::Integer)::Int
```

文字列`s`の、インデックス`i`から`j`までの文字数を返します。

これは、`i`から`j`までのコードユニットインデックスのうち、有効な文字インデックスであるものの数として計算されます。文字列引数が1つだけの場合、文字列全体の文字数を計算します。`i`と`j`を引数に指定すると、文字列`s`内で有効なインデックスのうち、`i`から`j`まで（両端を含む）の数を計算します。範囲内の値に加えて、`i`には範囲外の値`ncodeunits(s) + 1`を、`j`には範囲外の値`0`を指定できます。

!!! note
    一般に、この操作の時間計算量は線形です。値をその場で数えるため、文字列内のバイト数または文字数に比例した時間がかかります。配列に対するメソッドが定数時間で実行されるのとは対照的です。


関連項目：[`isvalid`](@ref)、[`ncodeunits`](@ref)、[`lastindex`](@ref)、[`thisind`](@ref)、[`nextind`](@ref)、[`prevind`](@ref)。

# Examples

```jldoctest
julia> length("jμΛIα")
5
```
