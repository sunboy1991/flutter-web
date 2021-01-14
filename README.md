<!--
 * @Author: sunboylu
 * @Date: 2021-01-11 14:59:38
 * @LastEditors: sunboylu
 * @LastEditTime: 2021-01-14 15:59:43
 * @Description: 
-->
# myapp

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.
flutter version  1.25.0-8.2 pre
> 注意：
> 开发前请保证flutter SDK 已就绪

1. 切换到beta分支
```
flutter channel beta 

flutter upgrade
```
2. 编译web端需要官方提供的工具flutter_web：
```
flutter pub global activate webdev
```
3. 需要配置一下环境变量:
```
vim .bash_profile

export PATH="$PATH":"$HOME/flutter/.pub-cache/bin"

//刷新配置 生效

source .bash_profile
```
4.开启flutter web开发模式
```
flutter config --enable-web
```
5.打开项目 进入 myapp 输入以命令开始开发
```
 flutter run -d chrome
```

6.打包上线 会生成build文件 需部署到服务端
```
 flutter build web
```
