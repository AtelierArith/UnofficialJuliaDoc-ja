```julia
mapfoldl(f, op, itr; [init])
```

[`mapreduce`](@ref)と同様ですが、[`foldl`](@ref)のように、左結合性が保証されます。指定した場合、キーワード引数`init`は1回だけ使用されます。一般に、空のコレクションで動作させるには`init`を指定する必要があります。
