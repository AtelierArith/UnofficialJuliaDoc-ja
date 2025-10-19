```julia
position(stream::NoopStream)
```

`stream`の現在の位置を取得します。

このメソッドは、次の場合に誤った位置を返す可能性があることに注意してください。

  * `TranscodingStreams.unread`によってデータが挿入された場合、または
  * ラップされたストリームの位置がこのパッケージの外で変更された場合。
