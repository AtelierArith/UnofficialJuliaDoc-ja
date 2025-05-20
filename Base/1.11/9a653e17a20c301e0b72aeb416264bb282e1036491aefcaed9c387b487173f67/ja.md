```
@static
```

パース時に式を部分的に評価します。

例えば、`@static Sys.iswindows() ? foo : bar` は `Sys.iswindows()` を評価し、式に `foo` または `bar` のいずれかを挿入します。これは、存在しない関数への `ccall` のように、他のプラットフォームでは無効な構造がある場合に便利です。`@static if Sys.isapple() foo end` および `@static foo <&&,||> bar` も有効な構文です。
