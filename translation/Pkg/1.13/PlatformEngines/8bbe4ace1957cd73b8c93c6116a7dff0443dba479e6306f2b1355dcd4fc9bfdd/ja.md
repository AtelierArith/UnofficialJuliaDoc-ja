```julia
verify(path::AbstractString, hash::AbstractString;
       verbose::Bool = false, report_cache_status::Bool = false,
       details::Union{Vector{String},Nothing} = nothing)
```

ファイル `path` と `hash` が与えられた場合、ファイルの SHA256 を計算し、`hash` と比較します。この方法では、以前に検証したファイルの再検証を高速化するため、検証結果を `"$(path).sha256"` ファイルにキャッシュします。`".sha256"` ファイルが存在しない場合は、完全な検証を行ってファイルを作成し、計算したハッシュを `".sha256"` ファイルに保存します。`".sha256"` ファイルが存在する場合は、その内容を確認し、格納されているハッシュが指定された `hash` パラメーターと一致すること、および `path` にあるファイルが前回の検証以降変更されていないことを、ファイルの更新日時から確認します。

`report_cache_status` が `true` に設定されている場合、検証が正常に完了したかどうかを示す `true`/`false` に加えて、ハッシュキャッシュの状態を詳細に報告する `Symbol` が戻り値になります。

`details` が指定されている場合、関連する詳細情報はログに記録されず、そこに出力されます。
