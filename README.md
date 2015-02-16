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

#### Why insecure?

During setup I created the file `/.pass` to use to lookup the mysql rootpassword for later startup changes (adding the default user). This is not deleted after creating the image. Also the default user/password is *hardcoded* into the `start.sh` script. So please don't use this in production ;). If you have a better idea on how to do this properly, let me know.
