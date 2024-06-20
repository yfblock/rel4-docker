# Rel4-docker

docker-hub: https://hub.docker.com/repository/docker/yfblock/rel4-dev/general

在仓库 的 release 里下载 riscv.tar.gz.

```shell
docker run -v ".:/rel4-test" yfblock/rel4-dev:1.0 sh -c "cd /rel4-test/rel4_kernel && make env && ./build.py"
```

然后在 -c 后面指定需要运行的指令。

如果需要直接进入 docker 执行 shell 的话，那么执行

```shell
docker run -v ".:/rel4-test" yfblock/rel4-dev:1.0 sh
```
