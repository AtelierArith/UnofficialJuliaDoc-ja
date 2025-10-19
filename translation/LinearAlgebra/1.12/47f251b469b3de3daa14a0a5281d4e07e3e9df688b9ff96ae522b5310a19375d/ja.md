```julia
norm(A, p::Real=2)
```

任意の数値の iterable コンテナ `A`（任意の次元の配列を含む）に対して、`p`-ノルム（デフォルトは `p=2`）を計算します。これは `A` が対応する長さのベクトルであるかのように扱われます。

`p`-ノルムは次のように定義されます。

$$
\|A\|_p = \left( \sum_{i=1}^n | a_i | ^p \right)^{1/p}
$$

ここで、$a_i$ は `A` のエントリ、$| a_i |$ は [`norm`](@ref) の `a_i` のノルム、$n$ は `A` の長さです。`p`-ノルムは `A` のエントリの [`norm`](@ref) を使用して計算されるため、`p != 2` の場合、ベクトルのベクトルの `p`-ノルムはブロックベクトルとしての解釈と互換性がありません。

`p` は任意の数値を取ることができます（すべての値が数学的に有効なベクトルノルムを生成するわけではありません）。特に、`norm(A, Inf)` は `abs.(A)` の中で最大の値を返し、`norm(A, -Inf)` は最小の値を返します。`A` が行列で `p=2` の場合、これはフロベニウスノルムに相当します。

第二引数 `p` は必ずしも `norm` のインターフェースの一部ではなく、カスタム型は第二引数なしで `norm(A)` のみを実装することがあります。

行列の演算子ノルムを計算するには [`opnorm`](@ref) を使用してください。

# 例

```jldoctest
julia> v = [3, -2, 6]
3-element Vector{Int64}:
  3
 -2
  6

julia> norm(v)
7.0

julia> norm(v, 1)
11.0

julia> norm(v, Inf)
6.0

julia> norm([1 2 3; 4 5 6; 7 8 9])
16.881943016134134

julia> norm([1 2 3 4 5 6 7 8 9])
16.881943016134134

julia> norm(1:9)
16.881943016134134

julia> norm(hcat(v,v), 1) == norm(vcat(v,v), 1) != norm([v,v], 1)
true

julia> norm(hcat(v,v), 2) == norm(vcat(v,v), 2) == norm([v,v], 2)
true

julia> norm(hcat(v,v), Inf) == norm(vcat(v,v), Inf) != norm([v,v], Inf)
true
```
