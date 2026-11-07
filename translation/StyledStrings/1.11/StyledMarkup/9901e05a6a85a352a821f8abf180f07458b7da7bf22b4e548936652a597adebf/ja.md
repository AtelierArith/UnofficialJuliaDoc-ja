```julia
styled(content::AbstractString) -> AnnotatedString
```

スタイル付き文字列を構築します。文字列内では、`{<specs>:<content>}`によって、カンマ区切りの指定リスト`<specs>`に従い、`<content>`に書式が適用されます。各指定には、フェイス名、インラインのフェイス指定、または`key=value`のペアを指定できます。値に`,=:{}`のいずれかの文字が含まれる場合は、`{...}`で囲む必要があります。

これは[`@styled_str`](@ref)マクロと機能的に同等ですが、補間機能はありません。
