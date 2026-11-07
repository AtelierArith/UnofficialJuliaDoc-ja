```julia
=
```

`=`は代入演算子です。

  * 変数`a`と式`b`に対して、`a = b`は`a`が`b`の値を参照するようにします。
  * 関数`f(x)`に対して、`f(x) = x`は新しい関数定数`f`を定義します。すでに`f`が定義されている場合は、`f`に新しいメソッドを追加します。この用法は`function f(x); x; end`と同等です。
  * `a[i] = v`は[`setindex!`](@ref)`(a,v,i)`を呼び出します。
  * `a.b = c`は[`setproperty!`](@ref)`(a,:b,c)`を呼び出します。
  * 関数呼び出しの中では、`f(a=b)`はキーワード引数`a`の値として`b`を渡します。
  * カンマを含む括弧内では、`(a=1,)`は[`NamedTuple`](@ref)を構築します。

# Examples

`a`を`b`に代入しても、`b`のコピーは作成されません。代わりに[`copy`](@ref)または[`deepcopy`](@ref)を使用してください。

```jldoctest
julia> b = [1]; a = b; b[1] = 2; a
1-element Vector{Int64}:
 2

julia> b = [1]; a = copy(b); b[1] = 2; a
1-element Vector{Int64}:
 1

```

関数に渡されたコレクションもコピーされません。関数は、引数が参照するオブジェクトの内容を変更（ミューテート）できます。このような関数の名前には、慣例として「!」が付けられます。

```jldoctest
julia> function f!(x); x[:] .+= 1; end
f! (generic function with 1 method)

julia> a = [1]; f!(a); a
1-element Vector{Int64}:
 2

```

代入では、反復可能オブジェクトから値を取り出して、複数の変数に並列に代入できます。

```jldoctest
julia> a, b = 4, 5
(4, 5)

julia> a, b = 1:3
1:3

julia> a, b
(1, 2)

```

代入では、複数の変数に順番に代入できます。この場合、右端の式の値が返されます。

```jldoctest
julia> a = [1]; b = [2]; c = [3]; a = b = c
1-element Vector{Int64}:
 3

julia> b[1] = 2; a, b, c
([2], [2], [2])

```

範囲外のインデックスへの代入によって、コレクションが拡張されることはありません。コレクションが[`Vector`](@ref)の場合は、代わりに[`push!`](@ref)または[`append!`](@ref)で拡張できます。

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

`[]`を代入しても、コレクションから要素は削除されません。削除するには、代わりに[`filter!`](@ref)を使用してください。

```jldoctest
julia> a = collect(1:3); a[a .<= 1] = []
ERROR: DimensionMismatch: tried to assign 0 elements to 1 destinations
[...]

julia> filter!(x -> x > 1, a) # in-place & thus more efficient than a = a[a .> 1]
2-element Vector{Int64}:
 2
 3

```
