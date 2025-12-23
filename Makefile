.PHONY: help dev build clean deploy-cf test

help: ## 显示帮助信息
	@echo "可用命令："
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

dev: ## 启动本地开发服务器
	hugo server -D

build: ## 构建生产版本
	hugo --minify --gc

clean: ## 清理构建文件
	rm -rf public resources

deploy-cf: build ## 部署到 Cloudflare Pages（需要安装 wrangler）
	@if ! command -v wrangler &> /dev/null; then \
		echo "❌ wrangler 未安装，请运行: npm install -g wrangler"; \
		exit 1; \
	fi
	wrangler pages deploy public --project-name=usedong

test: ## 测试构建
	@echo "🧪 测试构建..."
	@hugo --minify --gc
	@echo "✅ 构建成功！"
	@echo "📊 构建统计："
	@echo "- HTML: $$(find public -name '*.html' | wc -l | xargs) 个文件"
	@echo "- CSS: $$(find public -name '*.css' | wc -l | xargs) 个文件"
	@echo "- JS: $$(find public -name '*.js' | wc -l | xargs) 个文件"
	@rm -rf public

preview: build ## 本地预览生产版本
	@echo "🚀 启动预览服务器..."
	@cd public && python3 -m http.server 8080
