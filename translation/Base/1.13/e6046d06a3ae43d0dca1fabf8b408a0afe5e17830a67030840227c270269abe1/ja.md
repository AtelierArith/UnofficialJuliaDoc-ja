```julia
splat(f)
```

次と同等です。

```julia
    my_splat(f) = args->f(args...)
```

つまり、関数を受け取り、新しい関数を返します。この新しい関数は引数を1つ取り、それを元の関数にスプラットします。複数の引数を取る関数を、単一の引数を受け取ることを想定したコンテキストに渡す際に便利です。そのコンテキストでは、タプルが単一の引数として渡されます。

# Examples

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
