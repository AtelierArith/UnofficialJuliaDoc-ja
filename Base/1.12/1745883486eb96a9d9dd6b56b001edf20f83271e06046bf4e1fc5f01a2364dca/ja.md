```julia
NamedTuple
```

`NamedTuple`は、その名前が示すように、名前付き[`Tuple`](@ref)です。つまり、各エントリが一意の名前を持つ、タプルのような値のコレクションです。この名前は[`Symbol`](@ref)として表されます。`Tuple`と同様に、`NamedTuple`は不変であり、構築後に名前や値をその場で変更することはできません。

名前付きタプルは、キーを持つタプルリテラルとして作成できます。例えば、`(a=1, b=2)`や、開き括弧の後にセミコロンを付けたタプルリテラルとして、例えば`(; a=1, b=2)`（この形式は、以下に説明するようにプログラムで生成された名前も受け入れます）や、コンストラクタとして`NamedTuple`型を使用して、例えば`NamedTuple{(:a, :b)}((1,2))`のように作成できます。

名前付きタプル内の名前に関連付けられた値にアクセスするには、フィールドアクセス構文を使用します。例えば、`x.a`や、[`getindex`](@ref)を使用して、`x[:a]`または`x[(:a, :b)]`のようにアクセスできます。名前のタプルは[`keys`](@ref)を使用して取得でき、値のタプルは[`values`](@ref)を使用して取得できます。

!!! note
    `NamedTuple`を反復処理すると、*値*が名前なしで生成されます。（以下の例を参照してください。）名前と値のペアを反復処理するには、[`pairs`](@ref)関数を使用してください。


[`@NamedTuple`](@ref)マクロは、`NamedTuple`型を便利に宣言するために使用できます。

# 例

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

キーワード引数をプログラム的に定義するのと同様に、名前付きタプルは、タプルリテラル内のセミコロンの後に`name::Symbol => value`のペアを指定することで作成できます。この形式と`name=value`構文は混在させることができます：

```jldoctest
julia> (; :a => 1, :b => 2, c=3)
(a = 1, b = 2, c = 3)
```

名前と値のペアは、名前付きタプルをスプラットするか、各シンボルを最初の値として持つ2値コレクションを生成するイテレータを使用して提供することもできます：

```jldoctest
julia> keys = (:a, :b, :c); values = (1, 2, 3);

julia> NamedTuple{keys}(values)
(a = 1, b = 2, c = 3)

julia> (; (keys .=> values)...)
(a = 1, b = 2, c = 3)

julia> nt1 = (a=1, b=2);

julia> nt2 = (c=3, d=4);

julia> (; nt1..., nt2..., b=20) # 最後のbはnt1からの値を上書きします
(a = 1, b = 20, c = 3, d = 4)

julia> (; zip(keys, values)...) # zipは(:a, 1)のようなタプルを生成します
(a = 1, b = 2, c = 3)
```

キーワード引数と同様に、識別子とドット式は名前を暗示します：

```jldoctest
julia> x = 0
0

julia> t = (; x)
(x = 0,)

julia> (; t.x)
(x = 0,)
```

!!! compat "Julia 1.5"
    識別子とドット式からの暗黙の名前は、Julia 1.5以降で利用可能です。


!!! compat "Julia 1.7"
    複数の`Symbol`を持つ`getindex`メソッドの使用は、Julia 1.7以降で利用可能です。

