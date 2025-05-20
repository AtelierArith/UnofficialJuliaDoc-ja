```
powermod(x::Integer, p::Integer, m)
```

$$
x^p \pmod m
$$

を計算します。

# 例

```jldoctest
julia> powermod(2, 6, 5)
4

julia> mod(2^6, 5)
4

julia> powermod(5, 2, 20)
5

julia> powermod(5, 2, 19)
6

julia> powermod(5, 3, 19)
11
```
