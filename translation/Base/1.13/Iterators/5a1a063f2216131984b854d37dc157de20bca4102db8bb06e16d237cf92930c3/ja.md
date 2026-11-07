```julia
enumerate(iter)
```

`(i, x)`を返すイテレータです。`i`は1から始まるカウンターで、`x`は、与えられたイテレータの`i`番目の値です。反復対象の値`x`だけでなく、これまでの反復回数も必要な場合に便利です。

`i`は、`iter`のインデックスとして有効とは限らず、別の要素を指す場合もあります。これは、`iter`のインデックスが1から始まらない場合に起こります。また、文字列や辞書などでも起こることがあります。`i`がインデックスであることを確実にしたい場合は、`pairs(IndexLinear(), iter)`メソッドを参照してください。

# Examples

```jldoctest
julia> a = ["a", "b", "c"];

julia> for (index, value) in enumerate(a)
           println("$index $value")
       end
1 a
2 b
3 c

julia> str = "naïve";

julia> for (i, val) in enumerate(str)
           print("i = ", i, ", val = ", val, ", ")
           try @show(str[i]) catch e println(e) end
       end
i = 1, val = n, str[i] = 'n'
i = 2, val = a, str[i] = 'a'
i = 3, val = ï, str[i] = 'ï'
i = 4, val = v, StringIndexError("naïve", 4)
i = 5, val = e, str[i] = 'v'
```
