```julia
mapfoldr(f, op, itr; [init])
```

[`mapreduce`](@ref)と同様ですが、[`foldr`](@ref)のように、右結合性が保証されます。指定した場合、キーワード引数`init`は1回だけ使用されます。一般に、空のコレクションを扱うには`init`を指定する必要があります。
