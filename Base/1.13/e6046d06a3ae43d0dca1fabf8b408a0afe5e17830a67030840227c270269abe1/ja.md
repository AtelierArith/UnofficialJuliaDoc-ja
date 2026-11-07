```julia
splat(f)
```

次と同等です。

```julia
    my_splat(f) = args->f(args...)
```

つまり、関数を受け取り、その関数に1つの引数を渡す新しい関数を返します。この引数は、元の関数にスプラット展開して渡されます。複数の引数を取る関数を、単一の引数を受け取ることが期待されるコンテキストで使う際に便利なアダプターです。そのコンテキストでは、タプルが単一の引数として渡されます。

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
