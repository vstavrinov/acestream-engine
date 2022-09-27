# acestream-engine
Docker image with acestream engine.

It intended for using mostly as base image for others like [acestream-service](https://github.com/vstavrinov/acestream-service) but You can build and run it as standalone service:

```
docker build -t acestream-engine .
docker run --detach --name acestream-engine --publish 6878:6878 --env HOME=. \
    acestream-engine sh -c "./acestreamengine --client-console"
```

After that you can use acestream engine by usual way connecting to it's  standard port 6878
