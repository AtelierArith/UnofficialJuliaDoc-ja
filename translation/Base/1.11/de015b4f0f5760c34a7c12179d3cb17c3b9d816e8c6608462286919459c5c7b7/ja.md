```
kill(p::Process, signum=Base.SIGTERM)
```

プロセスにシグナルを送信します。デフォルトはプロセスを終了させることです。プロセスがすでに終了している場合は成功を返しますが、プロセスの終了に失敗した場合（例：権限不足）にはエラーをスローします。
