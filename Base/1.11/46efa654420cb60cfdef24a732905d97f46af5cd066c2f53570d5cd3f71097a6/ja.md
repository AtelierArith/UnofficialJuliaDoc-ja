```
splat(f)
```

は次のように等価です。

```julia
    my_splat(f) = args->f(args...)
```

すなわち、関数を与えると、新しい関数を返し、それは1つの引数を取り、それを元の関数にスプラットします。これは、複数の引数を持つ関数を、単一の引数を期待するコンテキストに渡すためのアダプタとして便利ですが、その単一の引数としてタプルを渡します。

# 例

```jldoctest
julia> map(splat(+), zip(1:3,4:6))
3-element Vector{Int64}:
 5
 7
 9

julia> my_add = splat(+)
splat(+)

julia> my_add((1,2,3))
6
```
