```
ssh_tunnel(user, host, bind_addr, port, sshflags, multiplex) -> localport
```

Establish an SSH tunnel to a remote worker. Return a port number `localport` such that `localhost:localport` connects to `host:port`.
