```julia
enumerate(iter)
```

1から始まるカウンタ`i`と、与えられたイテレータからの`i`番目の値`x`を返すイテレータです。イテレートしている値`x`だけでなく、これまでのイテレーションの回数も必要な場合に便利です。

`i`が`iter`のインデックスとして有効でない場合や、異なる要素をインデックスする場合があります。これは、`iter`のインデックスが1から始まらない場合に発生し、文字列や辞書などで起こる可能性があります。`i`がインデックスであることを保証したい場合は、`pairs(IndexLinear(), iter)`メソッドを参照してください。

# 例

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
