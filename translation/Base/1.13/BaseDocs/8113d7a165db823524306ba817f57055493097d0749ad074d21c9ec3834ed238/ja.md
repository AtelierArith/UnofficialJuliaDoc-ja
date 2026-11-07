```julia
for outer
```

`for` ループで、既存のローカル変数を反復処理に再利用します。

詳しくは、[manual section on variable scoping](@ref scope-of-variables) を参照してください。

こちらも参照してください: [`for`](@ref)。

# Examples

```jldoctest
julia> function f()
           i = 0
           for i = 1:3
               # empty
           end
           return i
       end;

julia> f()
0
```

```jldoctest
julia> function f()
           i = 0
           for outer i = 1:3
               # empty
           end
           return i
       end;

julia> f()
3
```

```jldoctest
julia> i = 0 # global variable
       for outer i = 1:3
       end
ERROR: syntax: no outer local variable declaration exists for "for outer"
[...]
```
