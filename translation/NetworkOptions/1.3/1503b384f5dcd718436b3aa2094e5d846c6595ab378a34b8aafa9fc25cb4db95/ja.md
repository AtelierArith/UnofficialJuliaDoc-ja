```julia
ssh_known_hosts_file() :: String
```

`ssh_known_hosts_file()` 関数は、SSH 接続時にリモートサーバーの身元を確認するために使用する、SSH known hosts ファイルのパスを 1 つ返します。`ssh_known_hosts_files` が返すパスのうち、実際に存在する最初のパスを返します。複数の known hosts ファイルを参照できる呼び出し元は、代わりに `ssh_known_hosts_files` を使用し、その関数のドキュメントに記載されているとおり、返されたすべてのファイルからホストに一致するものを探してください。
