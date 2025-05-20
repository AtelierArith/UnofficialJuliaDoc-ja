```
SimpleLogger([stream,] min_level=Info)
```

`min_level`以上のレベルのすべてのメッセージを`stream`に記録するためのシンプルなロガーです。ストリームが閉じている場合、`Warn`以上のログレベルのメッセージは`stderr`に記録され、それ以下は`stdout`に記録されます。
