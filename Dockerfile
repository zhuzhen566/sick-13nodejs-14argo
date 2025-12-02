# 构建阶段：使用 node:alpine 精简镜像
FROM node:20-alpine AS builder

# 设置时区（可选）
ENV TZ=UTC
RUN apk add --no-cache tzdata

# 创建应用目录
WORKDIR /app

# 复制 package.json（虽无依赖，但保留扩展性）
COPY package.json ./
RUN npm init -y && \
    npm install express axios --save

# 复制主程序
COPY index.js ./index.js

# 安装运行时依赖：curl（用于 meta 获取）、bash（兼容 exec）、procps（pkill）
RUN apk add --no-cache curl bash procps

# 暴露端口（HTTP 订阅端口 + Argo 映射端口）
EXPOSE 3000 8001

# 启动命令：确保前台运行、支持信号传递
CMD ["node", "index.js"]
