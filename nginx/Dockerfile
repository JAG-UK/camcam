# nginx/Dockerfile
FROM alfg/nginx-rtmp:latest

# Overwrite the default config with ours
COPY nginx.conf /etc/nginx/nginx.conf

# Run nginx directly, skipping any entrypoint scripts
ENTRYPOINT ["nginx", "-g", "daemon off;"]
