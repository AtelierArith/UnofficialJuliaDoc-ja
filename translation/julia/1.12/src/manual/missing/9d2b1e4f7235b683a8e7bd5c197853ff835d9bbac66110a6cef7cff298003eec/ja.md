# [Missing Values](@id missing)

Juliaは、統計的な意味で欠損値を表現するためのサポートを提供します。これは、観測において変数の値が利用できないが、理論的には有効な値が存在する状況に対するものです。欠損値は、[`missing`](@ref)オブジェクトを介して表され、これはタイプ[`Missing`](@ref)のシングルトンインスタンスです。`missing`は、[`NULL` in SQL](https://en.wikipedia.org/wiki/NULL_(SQL))および[`NA` in R](https://cran.r-project.org/doc/manuals/r-release/R-lang.html#NA-handling)と同等であり、ほとんどの状況でそれらのように振る舞います。

## Propagation of Missing Values

`missing` 値は、標準的な数学演算子や関数に渡されると自動的に *伝播* します。これらの関数において、オペランドの一つの値に関する不確実性は、結果に対する不確実性を引き起こします。実際には、`missing` 値を含む数学演算は一般的に `missing` を返します：

```jldoctest
julia> missing + 1
missing

julia> "a" * missing
missing

julia> abs(missing)
missing
```

`missing`は通常のJuliaオブジェクトであるため、この伝播ルールはこの動作を実装することを選択した関数にのみ適用されます。これは次のようにして実現できます：

  * `Missing`型の引数に対して定義された特定のメソッドを追加する、
  * このタイプの引数を受け入れ、それらを関数に渡して伝播させる（標準の数学演算子のように）。

パッケージは、新しい関数を定義する際に欠損値を伝播させることが意味を持つかどうかを考慮し、もしそうであれば適切にメソッドを定義する必要があります。`Missing`型の引数を受け入れるメソッドを持たない関数に`missing`値を渡すと、他の型と同様に[`MethodError`](@ref)がスローされます。

`missing` 値を伝播しない関数は、[Missings.jl](https://github.com/JuliaData/Missings.jl) パッケージが提供する `passmissing` 関数でラップすることによって、伝播するようにすることができます。例えば、`f(x)` は `passmissing(f)(x)` になります。

## Equality and Comparison Operators

標準の等価および比較演算子は、上記の伝播ルールに従います：オペランドのいずれかが `missing` の場合、結果は `missing` になります。以下はいくつかの例です：

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

特に、`missing == missing`は`missing`を返すため、`==`を使用して値が欠落しているかどうかをテストすることはできません。`x`が`missing`であるかどうかをテストするには、[`ismissing(x)`](@ref)を使用してください。

特殊な比較演算子 [`isequal`](@ref) と [`===`](@ref) は伝播ルールの例外です。これらは常に `Bool` 値を返し、`missing` 値が存在する場合でも、`missing` を `missing` と等しいと見なし、他の値とは異なると見なします。したがって、値が `missing` であるかどうかをテストするために使用できます：

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

[`isless`](@ref) 演算子は別の例外です：`missing` は他のすべての値よりも大きいと見なされます。この演算子は [`sort!`](@ref) によって使用されるため、`missing` 値は他のすべての値の後に配置されます：

```jldoctest
julia> isless(1, missing)
true

julia> isless(missing, Inf)
false

julia> isless(missing, missing)
false
```

## Logical operators

論理（またはブール）演算子 [`|`](@ref)、[`&`](@ref) および [`xor`](@ref) は、論理的に必要な場合にのみ `missing` 値を伝播させるため、特別なケースです。これらの演算子において、結果が不確かであるかどうかは、特定の操作に依存します。これは、[*three-valued logic*](https://en.wikipedia.org/wiki/Three-valued_logic) の確立されたルールに従っており、例えば SQL の `NULL` や R の `NA` によって実装されています。この抽象的な定義は、具体的な例を通じて最もよく説明される比較的自然な振る舞いに対応しています。

この原則を論理「または」演算子 [`|`](@ref) を使って説明しましょう。ブール論理のルールに従うと、オペランドの一方が `true` であれば、もう一方のオペランドの値は結果に影響を与えず、結果は常に `true` になります。

```jldoctest
julia> true | true
true

julia> true | false
true

julia> false | true
true
```

この観察に基づいて、もしオペランドの一方が `true` で、もう一方が `missing` であれば、オペランドの一方の実際の値についての不確実性にもかかわらず、結果は `true` であることがわかります。もし私たちが第二のオペランドの実際の値を観察できていたなら、それは `true` または `false` のいずれかであり、どちらの場合でも結果は `true` になります。したがって、この特定のケースでは、欠損は *伝播しません*：

```jldoctest
julia> true | missing
true

julia> missing | true
true
```

逆に、オペランドの一つが `false` の場合、結果はもう一つのオペランドの値に応じて `true` または `false` のいずれかになる可能性があります。したがって、そのオペランドが `missing` の場合、結果も `missing` でなければなりません：

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

論理「and」演算子 [`&`](@ref) の動作は、`|` 演算子の動作に似ていますが、オペランドの一方が `false` の場合、欠損値は伝播しないという違いがあります。例えば、最初のオペランドがその場合のとき：

```jldoctest
julia> false & false
false

julia> false & true
false

julia> false & missing
false
```

一方で、欠損はオペランドの一方が `true` の場合に伝播します。例えば最初のオペランドです：

```jldoctest
julia> true & true
true

julia> true & false
false

julia> true & missing
missing
```

最後に、「排他的論理和」演算子 [`xor`](@ref) は常に `missing` 値を伝播させます。なぜなら、両方のオペランドが常に結果に影響を与えるからです。また、否定演算子 [`!`](@ref) は、オペランドが `missing` の場合に `missing` を返すことにも注意してください。他の単項演算子と同様です。

## Control Flow and Short-Circuiting Operators

制御フロー演算子には、[`if`](@ref)、[`while`](@ref)、および [ternary operator](@ref man-conditional-evaluation) の `x ? y : z` が含まれますが、これらは欠損値を許可しません。これは、実際の値が `true` か `false` かを観察できた場合に不確実性があるためです。これは、プログラムがどのように動作すべきかがわからないことを意味します。この場合、[`TypeError`](@ref) が、コンテキスト内で `missing` 値が遭遇されるとすぐにスローされます。

```jldoctest
julia> if missing
           println("here")
       end
ERROR: TypeError: non-boolean (Missing) used in boolean context
```

同様の理由から、上記に示された論理演算子とは対照的に、ショートサーキットブール演算子 [`&&`](@ref) と [`||`](@ref) は、オペランドの値が次のオペランドが評価されるかどうかを決定する状況において `missing` 値を許可しません。例えば：

```jldoctest
julia> missing || false
ERROR: TypeError: non-boolean (Missing) used in boolean context

julia> missing && false
ERROR: TypeError: non-boolean (Missing) used in boolean context

julia> true && missing && false
ERROR: TypeError: non-boolean (Missing) used in boolean context
```

対照的に、`missing` 値なしで結果を決定できる場合はエラーが発生しません。これは、コードが `missing` 演算子を評価する前にショートサーキットする場合や、`missing` 演算子が最後のものである場合です：

```jldoctest
julia> true && missing
missing

julia> false && missing
false
```

## Arrays With Missing Values

欠損値を含む配列は、他の配列と同様に作成できます：

```jldoctest
julia> [1, missing]
2-element Vector{Union{Missing, Int64}}:
 1
  missing
```

この例が示すように、そのような配列の要素タイプは `Union{Missing, T}` であり、`T` は欠損していない値のタイプです。これは、配列のエントリがタイプ `T`（ここでは `Int64`）またはタイプ `Missing` のいずれかであることを反映しています。この種の配列は、実際の値を保持する `Array{T}` と、エントリのタイプ（つまり、それが `Missing` か `T` か）を示す `Array{UInt8}` を組み合わせた効率的なメモリストレージを使用します。

欠損値を許容する配列は、標準の構文を使用して構築できます。`Array{Union{Missing, T}}(missing, dims)`を使用して、欠損値で埋められた配列を作成します：

```jldoctest
julia> Array{Union{Missing, String}}(missing, 2, 3)
2×3 Matrix{Union{Missing, String}}:
 missing  missing  missing
 missing  missing  missing
```

!!! note
    `undef`や`similar`を使用すると、現在は`missing`で埋められた配列が得られるかもしれませんが、これはそのような配列を取得する正しい方法ではありません。上記のように`missing`コンストラクタを使用してください。


`missing` エントリを許可する要素タイプの配列（例： `Vector{Union{Missing, T}}`）は、`missing` エントリを含まない場合、`missing` エントリを許可しない配列タイプ（例： `Vector{T}`）に変換できます。変換には [`convert`](@ref) を使用します。配列に `missing` 値が含まれている場合、変換中に `MethodError` がスローされます：

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

`missing` 値は標準的な数学演算子と共に伝播するため、削減関数は `missing` 値を含む配列に対して呼び出されると `missing` を返します：

```jldoctest
julia> sum([1, missing])
missing
```

この状況では、欠損値をスキップするために [`skipmissing`](@ref) 関数を使用します：

```jldoctest
julia> sum(skipmissing([1, missing]))
1
```

この便利な関数は、`missing` 値を効率的にフィルタリングするイテレーターを返します。したがって、イテレーターをサポートする任意の関数と一緒に使用できます：

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

`skipmissing`を配列に対して呼び出すことで作成されたオブジェクトは、親配列のインデックスを使用してインデックス付けできます。欠損値に対応するインデックスはこれらのオブジェクトには無効であり、それらを使用しようとするとエラーが発生します（`keys`や`eachindex`でもスキップされます）：

```jldoctest skipmissing
julia> x[1]
3

julia> x[2]
ERROR: MissingException: the value at index (2,) is missing
[...]
```

これにより、インデックスで操作する関数が `skipmissing` と組み合わせて機能することができます。これは特に検索および発見関数に当てはまります。これらの関数は、`skipmissing` によって返されるオブジェクトに対して有効なインデックスを返し、また親配列内の一致するエントリのインデックスでもあります：

```jldoctest skipmissing
julia> findall(==(1), x)
1-element Vector{Int64}:
 4

julia> findfirst(!iszero, x)
1

julia> argmax(x)
1
```

[`collect`](@ref)を使用して、`missing`でない値を抽出し、配列に格納します:

```jldoctest skipmissing
julia> collect(x)
3-element Vector{Int64}:
 3
 2
 1
```

## Logical Operations on Arrays

上記で説明した論理演算子の三値論理は、配列に適用される論理関数でも使用されます。したがって、[`==`](@ref) 演算子を使用した配列の等価性テストは、`missing` エントリの実際の値を知らない限り、結果を決定できない場合に `missing` を返します。実際には、比較される配列のすべての非欠損値が等しい場合でも、1つまたは両方の配列に欠損値が含まれている（異なる位置にある可能性がある）場合に `missing` が返されることを意味します。

```jldoctest
julia> [1, missing] == [2, missing]
false

julia> [1, missing] == [1, missing]
missing

julia> [1, 2, missing] == [1, missing, 2]
missing
```

単一の値については、[`isequal`](@ref)を使用して、`missing`値を他の`missing`値と等しいものとして扱いますが、非`missing`値とは異なるものとして扱います：

```jldoctest
julia> isequal([1, missing], [1, missing])
true

julia> isequal([1, 2, missing], [1, missing, 2])
false
```

関数 [`any`](@ref) と [`all`](@ref) も三値論理のルールに従います。したがって、結果が決定できない場合は `missing` を返します:

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
