```julia
RadioMenu
```

リストから1つの選択肢を選べるメニュー。

# Sample Output

```julia-repl
julia> request(RadioMenu(options, pagesize=4))
Choose your favorite fruit:
^  grape
   strawberry
 > blueberry
v  peach
Your favorite fruit is blueberry!
```
