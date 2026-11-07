```julia
NamedTuple
```

`NamedTuple`は、その名のとおり、名前付きの[`Tuple`](@ref)です。つまり、各要素に一意の名前が付いた、タプルに似た値のコレクションであり、名前は[`Symbol`](@ref)で表されます。`Tuple`と同様に、`NamedTuple`は不変です。構築後に名前や値をその場で変更することはできません。

名前付きタプルは、キーを指定したタプルリテラル（例：`(a=1, b=2)`）、開き括弧の後にセミコロンを置いたタプルリテラル（例：`(; a=1, b=2)`。この形式では、後述のようにプログラムで生成した名前も使用できます）、または`NamedTuple`型をコンストラクターとして使う方法（例：`NamedTuple{(:a, :b)}((1,2))`）で作成できます。

名前付きタプルの名前に対応する値には、フィールドアクセス構文（例：`x.a`）または[`getindex`](@ref)を使ってアクセスできます（例：`x[:a]`、`x[(:a, :b)]`）。名前のタプルは[`keys`](@ref)で、値のタプルは[`values`](@ref)で取得できます。

!!! note
    `NamedTuple`を反復すると、名前ではなく*値*が得られます（下の例を参照）。名前と値のペアを反復するには、[`pairs`](@ref)関数を使います。


[`@NamedTuple`](@ref)マクロを使うと、`NamedTuple`型を簡単に宣言できます。

# Examples

```jldoctest
julia> x = (a=1, b=2)
(a = 1, b = 2)

julia> x.a
1

julia> x[:a]
1

julia> x[(:a,)]
(a = 1,)

julia> keys(x)
(:a, :b)

julia> values(x)
(1, 2)

julia> collect(x)
2-element Vector{Int64}:
 1
 2

julia> collect(pairs(x))
2-element Vector{Pair{Symbol, Int64}}:
 :a => 1
 :b => 2
```

キーワード引数をプログラムで定義する場合と同様に、タプルリテラル内のセミコロンの後に`name::Symbol => value`のペアを指定して、名前付きタプルを作成できます。この方法と`name=value`構文は組み合わせて使えます。

```jldoctest
julia> (; :a => 1, :b => 2, c=3)
(a = 1, b = 2, c = 3)
```

名前と値のペアは、名前付きタプル、または各要素が2つの値を持つコレクションで、最初の値がシンボルであるものを返す任意のイテレーターをスプラットして渡すこともできます。

```jldoctest
julia> keys = (:a, :b, :c); values = (1, 2, 3);

julia> NamedTuple{keys}(values)
(a = 1, b = 2, c = 3)

julia> (; (keys .=> values)...)
(a = 1, b = 2, c = 3)

julia> nt1 = (a=1, b=2);

julia> nt2 = (c=3, d=4);

julia> (; nt1..., nt2..., b=20) # the final b overwrites the value from nt1
(a = 1, b = 20, c = 3, d = 4)

julia> (; zip(keys, values)...) # zip yields tuples such as (:a, 1)
(a = 1, b = 2, c = 3)
```

キーワード引数と同様に、識別子やドット式は名前として扱われます。

```jldoctest
julia> x = 0
0

julia> t = (; x)
(x = 0,)

julia> (; t.x)
(x = 0,)
```

!!! compat "Julia 1.5"
    識別子やドット式から名前を暗黙的に取得できるようになったのは、Julia 1.5以降です。


!!! compat "Julia 1.7"
    複数の`Symbol`を指定した`getindex`メソッドが使えるのは、Julia 1.7以降です。

