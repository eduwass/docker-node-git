# docker-node-git
Docker Image with Node that will auto-pull codebase using the specified Git repo.

Copied some nice Git / Env vars functionalities from: [ngineered/nginx-php-fpm](https://github.com/ngineered/nginx-php-fpm) 

### Docker Hub
[https://hub.docker.com/r/eduwass/docker-node-git/](https://hub.docker.com/r/eduwass/docker-node-git/)

### Dynamically Pulling code from git
One of the nice features of this container is its ability to pull code from a git repository with a couple of environmental variables passed at run time.

**Note:** You need to have your SSH key that you use with git to enable the deployment. I recommend using a special deploy key per project to minimise the risk.

To run the container and pull code simply specify the GIT_REPO URL including *git@* and then make sure you have a folder on the docker host with your id_rsa key stored in it:
```
sudo docker run -e 'GIT_REPO=git@git.ngd.io:ngineered/ngineered-website.git'  -v /opt/ngddeploy/:/root/.ssh -p 8080:80 -d richarvey/nginx-php-fpm
```
To pull a repository and specify a branch add the GIT_BRANCH environment variable:
```
sudo docker run -e 'GIT_REPO=git@git.ngd.io:ngineered/ngineered-website.git' -e 'GIT_BRANCH=stage' -v /opt/ngddeploy/:/root/.ssh -p 8080:80 -d richarvey/nginx-php-fpm
```

## Special Features

### Push code to Git
To push code changes back to git simply run:
```
sudo docker exec -t -i <CONATINER_NAME> /usr/bin/push
```
### Pull code from Git (Refresh)
In order to refresh the code in a container and pull newer code form git simply run:
```
sudo docker exec -t -i <CONTAINER_NAME> /usr/bin/pull
```
### Install Extra Modules
If you wish to install extras at boot time, such as extra php modules you can specify this by adding the DEBS flag, to add multiple packages you need to space separate the values:
```
sudo docker run --name nginx -e 'DEBS=php5-mongo php-json" -p 8080:80 -d richarvey/nginx-php-fpm
```
### Templating
This container will automatically configure your web application if you template your code. For example if you are linking to MySQL like above, and you have a config.php file where you need to set the MySQL details include $$_MYSQL_ENV_MYSQL_DATABASE_$$ style template tags.

Example:
```
<?php
database_name = $$_MYSQL_ENV_MYSQL_DATABASE_$$;
database_host = $$_MYSQL_PORT_3306_TCP_ADDR_$$;
...
?>
```
### Using environment variables
If you want to link to an external MySQL DB and not using linking you can pass variables directly to the container that will be automatically configured by the container.

Example:
```
sudo docker run -e 'GIT_REPO=git@git.ngd.io:ngineered/ngineered-website.git' -e 'GIT_BRANCH=stage' -e 'MYSQL_HOST=host.x.y.z' -e 'MYSQL_USER=username' -e 'MYSQL_PASS=password' -v /opt/ngddeploy/:/root/.ssh -p 8080:80 -d richarvey/nginx-php-fpm
```

This will expose the following variables that can be used to template your code.
```
MYSQL_HOST=host.x.y.z
MYSQL_USER=username
MYSQL_PASS=password
```
To use these variables in a template you'd do the following in your file:
```
<?php
database_host = $$_MYSQL_HOST_$$;
database_user = $$_MYSQL_USER_$$;
database_pass = $$_MYSQL_PASS_$$
...
?>
```
