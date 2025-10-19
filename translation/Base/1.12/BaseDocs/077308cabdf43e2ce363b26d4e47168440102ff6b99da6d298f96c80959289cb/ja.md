```julia
function
```

関数は `function` キーワードを使って定義されます：

```julia
function add(a, b)
    return a + b
end
```

または短縮形の表記：

```julia
add(a, b) = a + b
```

[`return`](@ref) キーワードの使い方は他の言語と全く同じですが、しばしば省略可能です。明示的な `return` 文がない関数は、関数本体の最後の式を返します。
