sudo docker run -d --name nginx \
--restart=unless-stopped \
--network host \
nginx
