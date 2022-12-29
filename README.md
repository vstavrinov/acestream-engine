# acestream-engine
Docker image with acestream engine.

It intended for using mostly as base image for others like [acestream-service](https://github.com/vstavrinov/acestream-service) but You can run it as standalone service:

```
docker run --detach --publish 6878:6878 vstavrinov/acestream-engine
```

After that you can use acestream engine by usual way connecting to it's  standard port 6878
