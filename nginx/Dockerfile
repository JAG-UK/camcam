# nginx/Dockerfile
FROM alfg/nginx-rtmp:latest

# Overwrite the default config with ours
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the symlink helper
COPY update-public.sh /usr/local/bin/update-public.sh
RUN chmod +x /usr/local/bin/update-public.sh

# Run nginx directly, skipping any entrypoint scripts
ENTRYPOINT ["nginx", "-g", "daemon off;"]
