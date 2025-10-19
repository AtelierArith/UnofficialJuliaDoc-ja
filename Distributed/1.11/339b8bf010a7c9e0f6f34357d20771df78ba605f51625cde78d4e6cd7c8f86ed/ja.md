```julia
remoteref_id(r::AbstractRemoteRef) -> RRID
```

`Future`s と `RemoteChannel`s は次のフィールドによって識別されます：

  * `where` - 参照されているオブジェクト/ストレージが実際に存在するノードを指します。
  * `whence` - リモート参照が作成されたノードを指します。これは、参照されている実際のオブジェクトが存在するノードとは異なることに注意してください。たとえば、マスタープロセスから `RemoteChannel(2)` を呼び出すと、`where` の値は 2 になり、`whence` の値は 1 になります。
  * `id` は、`whence` で指定されたワーカーから作成されたすべての参照の中で一意です。

まとめると、`whence` と `id` はすべてのワーカーの中で参照を一意に識別します。

`remoteref_id` は低レベルの API で、リモート参照の `whence` と `id` の値をラップした `RRID` オブジェクトを返します。
