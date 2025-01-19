### 一个sing-box-subscribe容器:
- 支持程序自动更新
- 支持程序挂载到本地硬盘，重启后程序内容不发生变化
- 原程序地址在：https://github.com/Toperlock/sing-box-subscribe
- docker hub地址：https://hub.docker.com/r/ruicaok/sing-box-subscribe


### 使用教程
- 本地构建
```
docker build -t ruicaok/sing-box-subscribe:lastest .
```

- 直接运行
```shell
docker run -itd -e USER_ID=1000 -e GROUP_ID=1000 -p 5000:5000 -v /your_local_path:/sing-box-subscribe ruicaok/sing-box-subscribe:lastest
```
- 使用docker compose
```yaml
version: "3.7"

services:
  sing-box-subscribe:
    container_name: sing-box-subscribe
    image: ruicaok/sing-box-subscribe:lastest
    ports:
      - "5000:5000"
    volumes:
      - /your_local_path:/sing-box-subscribe
    environment:
      - USER_ID=1000
      - GROUP_ID=1000
```
- 参数说明
  - USER_ID与GROUP_ID：与your_local_path下的用户权限有关，默认值为1000，如果当前系统的用户ID与其不一致，请修改改变量，防止该路径下的文件无法打开或者修改
  - your_local_path： 容器启动后会将程序全部放到改路径下，如果想重置程序，删除your_local_path下的所有内容

### 更新程序
- 重启容器会自动更新程序
- 程序放在your_local_path路径下，可以在下面手动修改程序或者上传最新的程序
