```julia
=
```

`=` は代入演算子です。

  * 変数 `a` と式 `b` に対して、`a = b` は `a` が `b` の値を参照するようにします。
  * 関数 `f(x)` に対して、`f(x) = x` は新しい関数定数 `f` を定義するか、`f` がすでに定義されている場合は `f` に新しいメソッドを追加します。この使い方は `function f(x); x; end` と同等です。
  * `a[i] = v` は [`setindex!`](@ref)`(a,v,i)` を呼び出します。
  * `a.b = c` は [`setproperty!`](@ref)`(a,:b,c)` を呼び出します。
  * 関数呼び出しの中で、`f(a=b)` は `b` をキーワード引数 `a` の値として渡します。
  * カンマ付きの括弧の中で、`(a=1,)` は [`NamedTuple`](@ref) を構築します。

# 例

`a` を `b` に代入しても `b` のコピーは作成されません。代わりに [`copy`](@ref) または [`deepcopy`](@ref) を使用してください。

```jldoctest
julia> b = [1]; a = b; b[1] = 2; a
1-element Vector{Int64}:
 2

julia> b = [1]; a = copy(b); b[1] = 2; a
1-element Vector{Int64}:
 1

```

関数に渡されたコレクションもコピーされません。関数は引数が参照するオブジェクトの内容を変更（変異）することができます。（このような関数の名前は慣例的に '!' で終わります。）

```jldoctest
julia> function f!(x); x[:] .+= 1; end
f! (generic function with 1 method)

julia> a = [1]; f!(a); a
1-element Vector{Int64}:
 2

```

代入は複数の変数に並行して操作でき、イテラブルから値を取得します：

```jldoctest
julia> a, b = 4, 5
(4, 5)

julia> a, b = 1:3
1:3

julia> a, b
(1, 2)

```

代入は複数の変数に直列で操作でき、右端の式の値を返します：

```jldoctest
julia> a = [1]; b = [2]; c = [3]; a = b = c
1-element Vector{Int64}:
 3

julia> b[1] = 2; a, b, c
([2], [2], [2])

```

範囲外のインデックスでの代入はコレクションを成長させません。コレクションが [`Vector`](@ref) の場合、[`push!`](@ref) または [`append!`](@ref) を使用して成長させることができます。

```jldoctest
julia> a = [1, 1]; a[3] = 2
ERROR: BoundsError: attempt to access 2-element Vector{Int64} at index [3]
[...]

julia> push!(a, 2, 3)
4-element Vector{Int64}:
 1
 1
 2
 3

```

`[]` を代入してもコレクションから要素は削除されません。代わりに [`filter!`](@ref) を使用してください。

```jldoctest
julia> a = collect(1:3); a[a .<= 1] = []
ERROR: DimensionMismatch: tried to assign 0 elements to 1 destinations
[...]

julia> filter!(x -> x > 1, a) # in-place & thus more efficient than a = a[a .> 1]
2-element Vector{Int64}:
 2
 3

```
