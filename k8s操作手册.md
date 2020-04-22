### kubernetes使用手册

#### 第一章 常用技巧

+ 查看节点状态get nodes
```shell script
kubectl get nodes
```
可以添加的常用参数:

--show-labels 显示节点的标签

-o wide/json/yaml 输出格式

--selector='`<key>=<value>`' 如: --selector='group=app' 根据标签选择

+ 查看pod状态

```shell script
kubectl get pod
```

常用参数:
-A --all-namespaces 查看所有名称空间下的

-o  wide/json/yaml 输出格式,wide常用



+ taint 污点标记命令

去掉master节点 NoSchedule,让pod可以调度在msater节点上
```shell script
kubectl taint node km01 node-role.kubernetes.io/master-
```
恢复master节点不可调度污点
```shell script
kubectl taint node km01 node-role.kubernetes.io/master="":NoSchedule
```

+ 给node节点打标签

给node节点添加role标记
```shell script
kubectl label node kn01 node-role.kubernetes.io/ops=
```
添加其他标签,`<key>=<label>`
```shell script
kubectl label node kn01 group=app
```
删除标签,`<key>-`
```shell script
kubectl label node kn01 group-
```

