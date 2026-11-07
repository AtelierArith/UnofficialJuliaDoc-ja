```julia
runprompt!((; term,prompt,pstate,istate), events::Channel{Symbol}, terminal_properties)
```

確定、保存、または中止されるまで、プロンプトの入力ループを実行します。

`:edit`、`:confirm`、`:save`、または`:abort`を`events`に出力し、rawモードとブラケット付きペーストを管理して、終了時に後処理を行います。
