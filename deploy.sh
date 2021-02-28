#!/usr/bin/env sh


# 确保脚本抛出遇到的错误
set -e

# 打包生成静态文件
npm run build

# 进入打包好的文件夹
cd docs/.vuepress/dist

# 创建git的本地仓库，提交修改
git init
git add .
git config user.name 'ATaoyoyo'
git config user.email '1029187998@qq.com'
git commit -m 'deploy'

# 覆盖式地将本地仓库发布至github，因为发布不需要保留历史记录
# 格式为：git push -f git@github.com:'用户名'/'仓库名'.git master
git remote add origin https://github.com/ATaoyoyo/ATaoyoyo.github.io.git 
git branch -M main
git push -u -f origin main

cd -