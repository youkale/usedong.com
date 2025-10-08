#!/bin/bash

# Cloudflare Pages 部署脚本
# 该脚本会在 Cloudflare Pages 构建时自动执行

set -e

echo "🚀 开始部署到 Cloudflare Pages..."

# 检查 Hugo 版本
echo "📦 Hugo 版本信息："
hugo version

# 清理旧的构建文件
echo "🧹 清理旧的构建文件..."
rm -rf public

# 构建网站
echo "🔨 构建 Hugo 网站..."
hugo --minify --gc

# 构建完成
echo "✅ 构建完成！输出目录：public/"
ls -lh public/

# 显示构建统计
echo "📊 构建统计："
echo "- HTML 文件数量: $(find public -name "*.html" | wc -l)"
echo "- CSS 文件数量: $(find public -name "*.css" | wc -l)"
echo "- JS 文件数量: $(find public -name "*.js" | wc -l)"
echo "- 图片文件数量: $(find public \( -name "*.jpg" -o -name "*.png" -o -name "*.gif" -o -name "*.webp" \) | wc -l)"

echo "🎉 部署准备完成！"
