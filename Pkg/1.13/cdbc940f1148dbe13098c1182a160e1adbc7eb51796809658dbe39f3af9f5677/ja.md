```julia
mv_temp_dir_retries(temp_dir::String, new_path::String; set_permissions::Bool=true)::Nothing
```

`temp_dir` のディレクトリ名を `new_path` に変更して読み取り専用にするか、`new_path` がすでに存在する場合は何もしないようにしてください。`temp_dir` と `new_path` は、同じファイルシステム上になければなりません。
