### 使用helm简明教程

helm 安装请看脚本内容

helm 添加私有仓库

```shell script
helm  repo add myops  https://harbor.opsbible.com/chartrepo/ops --username=admin --password=Harbor12345 --insecure-skip-tls-verify
```
--insecure-skip-tls-verify 用户跳过https认证 也可以直接添加--ca-file ca.crt

注意 chartrepo 路径是默认的,必须有,否则报错 ops 是自己创建的

helm 查看当前已经有仓库
```shell script
helm repo list
```

删除仓库
```shell script
helm repo remove myops
```

查看仓库的charts
```shell script
helm search repo myops keydb
```
创建charts
```shell script
helm create myapp
```


