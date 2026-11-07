```julia
MIME
```

標準的なインターネットデータ形式を表す型です。「MIME」は「Multipurpose Internet Mail Extensions」の略で、この標準はもともと、メールメッセージに添付するマルチメディアファイルを記述するために使われていました。

`MIME` オブジェクトを [`show`](@ref) の第2引数として渡すと、その形式での出力を要求できます。

# Examples

```jldoctest
julia> show(stdout, MIME("text/plain"), "hi")
"hi"
```
