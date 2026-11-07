# [Missing Values](@id missing)

Julia は、統計学的な意味での欠損値を表現できます。これは、ある観測値において変数の値が得られていないものの、理論上は有効な値が存在する状況を扱うためのものです。欠損値は [`missing`](@ref) オブジェクトで表されます。これは型 [`Missing`](@ref) の唯一のインスタンスです。`missing` は [`NULL` in SQL](https://en.wikipedia.org/wiki/NULL_(SQL)) および [`NA` in R](https://cran.r-project.org/doc/manuals/r-release/R-lang.html#NA-handling) と同等であり、ほとんどの状況で同様に動作します。

## Propagation of Missing Values

`missing` 値を標準的な数学演算子や関数に渡すと、その値は自動的に *伝播* します。これらの関数では、オペランドの値が不確かであれば、結果も不確かになります。実際には、`missing` 値を含む数学演算は、通常 `missing` を返します。

```jldoctest
julia> missing + 1
missing

julia> "a" * missing
missing

julia> abs(missing)
missing
```

`missing` は通常の Julia オブジェクトであるため、この伝播規則が適用されるのは、この動作を実装するよう明示的に対応した関数に限られます。対応するには、次のいずれかを行います。

  * 型 `Missing` の引数を受け取る専用メソッドを定義する。
  * この型の引数を受け取り、それを伝播に対応した関数（標準的な数学演算子など）に渡す。

パッケージで新しい関数を定義する際は、欠損値を伝播させるのが適切かどうかを検討し、適切であればそれに応じたメソッドを定義してください。型 `Missing` の引数を受け取るメソッドがない関数に `missing` 値を渡すと、ほかの型の場合と同様に [`MethodError`](@ref) がスローされます。

`missing` 値を伝播しない関数も、[Missings.jl](https://github.com/JuliaData/Missings.jl) パッケージが提供する `passmissing` 関数でラップすれば、伝播に対応させることができます。たとえば、`f(x)` は `passmissing(f)(x)` になります。

## Equality and Comparison Operators

標準的な等値演算子や比較演算子にも、前述の伝播規則が適用されます。オペランドのいずれかが `missing` なら、結果は `missing` です。例をいくつか示します。

```jldoctest
julia> missing == 1
missing

julia> missing == missing
missing

julia> missing < 1
missing

julia> 2 >= missing
missing
```

特に、`missing == missing` は `missing` を返すため、値が欠損しているかどうかの判定に `==` は使えません。`x` が `missing` かどうかを調べるには、[`ismissing(x)`](@ref) を使います。

特殊な比較演算子 [`isequal`](@ref) と [`===`](@ref) は、伝播規則の例外です。`missing` 値が含まれていても、常に `Bool` 値を返します。これらの演算子では、`missing` は `missing` と等しく、それ以外の値とは異なるものとして扱われます。そのため、値が `missing` かどうかの判定に使えます。

```jldoctest
julia> missing === 1
false

julia> isequal(missing, 1)
false

julia> missing === missing
true

julia> isequal(missing, missing)
true
```

[`isless`](@ref) 演算子も例外です。この演算子では、`missing` はほかのどの値よりも大きいものとして扱われます。[`sort!`](@ref) はこの演算子を使うため、`missing` 値はほかのすべての値より後に並びます。

```jldoctest
julia> isless(1, missing)
true

julia> isless(missing, Inf)
false

julia> isless(missing, missing)
false
```

## Logical operators

論理（ブール）演算子 [`|`](@ref)、[`&`](@ref)、[`xor`](@ref) も特殊なケースです。これらの演算子は、論理的に必要な場合にのみ `missing` 値を伝播させます。結果が不確かになるかどうかは、演算の種類によって異なります。これは、[*three-valued logic*](https://en.wikipedia.org/wiki/Three-valued_logic) で確立されている規則に従ったもので、たとえば SQL の `NULL` や R の `NA` にも実装されています。この抽象的な定義は比較的自然な動作に対応しており、具体例で説明するのが最も分かりやすいでしょう。

論理和演算子 [`|`](@ref) を例に、この原則を説明します。ブール論理の規則に従うと、オペランドの一方が `true` なら、もう一方の値は結果に影響しません。結果は常に `true` です。

```jldoctest
julia> true | true
true

julia> true | false
true

julia> false | true
true
```

このことから、オペランドの一方が `true` で、もう一方が `missing` の場合、オペランドの一方の実際の値が不明でも、結果は `true` だと分かります。2 番目のオペランドの実際の値を観測できたとしても、それは `true` または `false` のどちらかであり、どちらの場合も結果は `true` になります。したがって、この場合は欠損が *伝播しません*。

```jldoctest
julia> true | missing
true

julia> missing | true
true
```

一方、オペランドの一方が `false` の場合、もう一方の値によって結果は `true` にも `false` にもなり得ます。そのため、もう一方のオペランドが `missing` なら、結果も `missing` でなければなりません。

```jldoctest
julia> false | true
true

julia> true | false
true

julia> false | false
false

julia> false | missing
missing

julia> missing | false
missing
```

論理積演算子 [`&`](@ref) の動作は、`|` 演算子と似ています。ただし、オペランドの一方が `false` の場合は、欠損が伝播しません。たとえば、最初のオペランドがその場合に当たるときは、次のようになります。

```jldoctest
julia> false & false
false

julia> false & true
false

julia> false & missing
false
```

反対に、オペランドの一方が `true` の場合は、欠損が伝播します。たとえば、最初のオペランドがその場合に当たるときは、次のようになります。

```jldoctest
julia> true & true
true

julia> true & false
false

julia> true & missing
missing
```

最後に、排他的論理和演算子 [`xor`](@ref) では、両方のオペランドが常に結果に影響するため、`missing` 値は常に伝播します。また、否定演算子 [`!`](@ref) は、ほかの単項演算子と同様に、オペランドが `missing` の場合は `missing` を返します。

## Control Flow and Short-Circuiting Operators

[`if`](@ref)、[`while`](@ref)、[ternary operator](@ref man-conditional-evaluation) `x ? y : z` などの制御フロー演算子は、欠損値を受け付けません。実際の値を観測できたとしたら `true` と `false` のどちらになるか分からず、プログラムがどう動作すべきか判断できないためです。このような状況で `missing` 値に遭遇すると、[`TypeError`](@ref) がスローされます。

```jldoctest
julia> if missing
           println("here")
       end
ERROR: TypeError: non-boolean (Missing) used in boolean context
```

同じ理由から、前述の論理演算子とは異なり、短絡評価を行うブール演算子 [`&&`](@ref) と [`||`](@ref) は、オペランドの値によって次のオペランドを評価するかどうかが決まる状況では、`missing` 値を受け付けません。たとえば、次のようになります。

```jldoctest
julia> missing || false
ERROR: TypeError: non-boolean (Missing) used in boolean context

julia> missing && false
ERROR: TypeError: non-boolean (Missing) used in boolean context

julia> true && missing && false
ERROR: TypeError: non-boolean (Missing) used in boolean context
```

一方、`missing` 値を使わずに結果を決定できる場合は、エラーはスローされません。これは、`missing` オペランドを評価する前に短絡評価が行われる場合と、`missing` オペランドが最後のオペランドである場合です。

```jldoctest
julia> true && missing
missing

julia> false && missing
false
```

## Arrays With Missing Values

欠損値を含む配列は、ほかの配列と同じように作成できます。

```jldoctest
julia> [1, missing]
2-element Vector{Union{Missing, Int64}}:
 1
  missing
```

この例が示すように、このような配列の要素型は `Union{Missing, T}` であり、`T` は欠損していない値の型です。これは、配列の要素が型 `T`（ここでは `Int64`）または型 `Missing` のいずれかになり得ることを表しています。この種の配列では、実際の値を保持する `Array{T}` と、各要素の型（つまり、`Missing` か `T` か）を示す `Array{UInt8}` を組み合わせた、効率的なメモリ格納方式が使われます。

欠損値を許容する配列は、標準的な構文で作成できます。欠損値で埋められた配列を作るには、`Array{Union{Missing, T}}(missing, dims)` を使います。

```jldoctest
julia> Array{Union{Missing, String}}(missing, 2, 3)
2×3 Matrix{Union{Missing, String}}:
 missing  missing  missing
 missing  missing  missing
```

!!! note
    `undef` または `similar` を使うと、現在は `missing` で埋められた配列が得られる場合があります。しかし、これはそのような配列を作る正しい方法ではありません。上記のように、`missing` コンストラクターを使ってください。


`missing` の要素を許容する要素型（例: `Vector{Union{Missing, T}}`）を持ち、`missing` の要素を含まない配列は、`missing` の要素を許容しない配列型（例: `Vector{T}`）に、[`convert`](@ref) を使って変換できます。配列に `missing` 値が含まれている場合は、変換中に `MethodError` がスローされます。

```jldoctest
julia> x = Union{Missing, String}["a", "b"]
2-element Vector{Union{Missing, String}}:
 "a"
 "b"

julia> convert(Array{String}, x)
2-element Vector{String}:
 "a"
 "b"

julia> y = Union{Missing, String}[missing, "b"]
2-element Vector{Union{Missing, String}}:
 missing
 "b"

julia> convert(Array{String}, y)
ERROR: MethodError: Cannot `convert` an object of type Missing to an object of type String
```

## Skipping Missing Values

`missing` 値は標準的な数学演算子で伝播するため、欠損値を含む配列に対して集約関数を呼び出すと、`missing` が返されます。

```jldoctest
julia> sum([1, missing])
missing
```

このような場合は、欠損値を無視するために [`skipmissing`](@ref) 関数を使います。

```jldoctest
julia> sum(skipmissing([1, missing]))
1
```

この便利な関数は、`missing` 値を効率的に除外するイテレーターを返します。そのため、イテレーターに対応する任意の関数と組み合わせて使えます。

```jldoctest skipmissing
julia> x = skipmissing([3, missing, 2, 1])
skipmissing(Union{Missing, Int64}[3, missing, 2, 1])

julia> maximum(x)
3

julia> sum(x)
6

julia> mapreduce(sqrt, +, x)
4.146264369941973
```

配列に対して `skipmissing` を呼び出して作成したオブジェクトは、元の配列のインデックスを使ってインデックス付けできます。欠損値に対応するインデックスはこれらのオブジェクトでは無効であり、そのインデックスを使おうとするとエラーがスローされます（また、`keys` と `eachindex` ではスキップされます）。

```jldoctest skipmissing
julia> x[1]
3

julia> x[2]
ERROR: MissingException: the value at index (2,) is missing
[...]
```

これにより、インデックスを扱う関数を `skipmissing` と組み合わせて使えます。特に、検索関数や find 関数が該当します。これらの関数は、`skipmissing` が返すオブジェクトで有効なインデックスを返します。また、そのインデックスは *元の配列* における一致要素の位置も示します。

```jldoctest skipmissing
julia> findall(==(1), x)
1-element Vector{Int64}:
 4

julia> findfirst(!iszero, x)
1

julia> argmax(x)
1
```

[`collect`](@ref) を使うと、`missing` ではない値を取り出して配列に格納できます。

```jldoctest skipmissing
julia> collect(x)
3-element Vector{Int64}:
 3
 2
 1
```

## Logical Operations on Arrays

前述の論理演算子に対する三値論理は、配列に適用される論理関数にも使われます。そのため、[`==`](@ref) 演算子を使った配列の等値判定では、`missing` 要素の実際の値が分からなければ結果を決定できない場合、`missing` が返されます。実際には、比較する配列の欠損していない値がすべて等しくても、一方または両方の配列に欠損値が含まれていれば（位置が異なる場合も含む）、`missing` が返されます。

```jldoctest
julia> [1, missing] == [2, missing]
false

julia> [1, missing] == [1, missing]
missing

julia> [1, 2, missing] == [1, missing, 2]
missing
```

単一の値の場合と同様に、[`isequal`](@ref) を使うと、`missing` 値をほかの `missing` 値とは等しく、欠損していない値とは異なるものとして扱えます。

```jldoctest
julia> isequal([1, missing], [1, missing])
true

julia> isequal([1, 2, missing], [1, missing, 2])
false
```

[`any`](@ref) 関数と [`all`](@ref) 関数も、三値論理の規則に従います。そのため、結果を決定できない場合は `missing` を返します。

```jldoctest
julia> all([true, missing])
missing

julia> all([false, missing])
false

julia> any([true, missing])
true

julia> any([false, missing])
missing
```
