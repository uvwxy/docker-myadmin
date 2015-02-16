# docker-myadmin
### Dockerized mysql + phpmyadmin

This is an (insecure?) docker container to get a MySQL (5.6) server up and running with a phpmyadmin frontend.

The image is based on ubuntu:14.04.

```
# create image
docker build -t uvwxy/myadmin .
# launch it temporarily
docker run -it --rm -p 3306:3306 -p 3307:80 uvwxy/myadmin
```

You can adapt the config in `start.sh`

```
MYSQL_DB=db
MYSQL_USER=user
MYSQL_PASS=pass
```
