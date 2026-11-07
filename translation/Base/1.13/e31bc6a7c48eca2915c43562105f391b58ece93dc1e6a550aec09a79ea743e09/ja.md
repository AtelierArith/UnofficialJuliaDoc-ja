```julia
unsafe_string(p::Ptr{T}, [length::Integer]) where {T<:Union{UInt16,UInt32,Cwchar_t}}
unsafe_string(p::Cwstring)
```

UTF-16（`T=UInt16`）、UTF-32（`T=UInt32`）、またはシステム依存の`wchar_t`（`T=Cwchar_t`または`Cwstring`）でエンコードされたC形式（NUL終端）の文字列のアドレスから文字列をトランスコードし、`String`（UTF-8エンコーディング）を返します。[`transcode`](@ref)と同様ですが、ポインターから直接読み取ります。（このポインターは、その後安全に解放できます。）`length`（エンコーディング単位で表したデータの長さ）を指定した場合、文字列をNUL終端にする必要はありません。

`p`が、指定された長さのデータ（またはNUL終端データ）を指す有効なメモリアドレスでない場合、この関数はクラッシュするため、「unsafe」とされています。
