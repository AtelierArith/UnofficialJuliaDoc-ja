```julia
replace_ref_begin_end!(ex)
```

「ref」式（つまり、`A[...]`）`ex`内にあるシンボル `:begin` および `:end` の出現箇所を、適切な関数呼び出し（`firstindex` または `lastindex`）で再帰的に置き換えます。置換には最も近い外側の ref が使われるため、

```julia
A[B[end]]
```

は次のように変換されます。

```julia
A[B[lastindex(B)]]
```
