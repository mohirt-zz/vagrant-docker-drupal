# Vagrant Docker Drupal (VDD)
A Vagrant setup that uses Docker as provider, builds Docker images and creates Docker containers for running Drupal. Fully embrace the Docker principle: One Concern per Container.

## Introduction
The project can be a boiler plate for starting a new Drupal project, or integrating existing Drupal project into Docker styles. So that developers can have more control on the application environments, and sysadmin can rest assure that the deployment can go smoothly.

In summary, Vagrant will fire up a host vm (ubuntu:14.04)  and install a Docker daemon. Base image (ubuntu:14.04) will be used, and system services like Nginx, PHP-FPM, MySQL will be running inside container. A [Data Volume Container](https://docs.docker.com/userguide/dockervolumes/) will be created to hold persistent data.

## Prerequisite
- [Vagrant](https://www.vagrantup.com/downloads.html) >= v1.6.0
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- Vagrant Plugin:
  - [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest)
  - (Windows) [vagrant-winnfsd](https://github.com/GM-Alex/vagrant-winnfsd) or similar tools to provide nfs service

A fast Internet and patient, because many images will be downloaded for the first time.

## Quick Start
1. Clone the git repository from Github

        git clone https://github.com/stevenyeung/vagrant-docker-drupal.git <your_project_code>

2. Change the variables in `project-init.sh`, this script will modify the VM hostname and IP in the config files
  - `PROJECT_CODE=<your_project_code>`
  - `DOCKER_HOST_IP=<host_only_ip>`

3. Execute `project-init.sh`

        bash ./project-init.sh

4. Use Vagrant to fire up your Docker Host VM, it will build the images and create containers automatically

        vagrant up --no-parallel

5. While Vagrant is busying provisioning your development environment, you may change your `hosts` file if you want to access the Drupal using hostname. Something like:

        <host_only_ip> <your_project_code>.local

6. When Vagrant finish provisioning (stop flooding), use a browser and visit `http://<your_project_code>.local`

## Under The Hood
Coming soon...

## Coming Features
- A nice backup strategies
- A proper sendmail solutions for containers
- Centralized logging
- Memcache container
- Varnish container
- Solr container

## FAQ
Coming soon...

## Acknowledgments
Special thanks to [António](https://github.com/perusio) for the great [Nginx config for Drupal](https://github.com/perusio/drupal-with-nginx) and [PHP-FPM config](https://github.com/perusio/php-fpm-example-config).

The `entrypoint.sh` script for MySQL is based on the idea from [docker-library/mysql](https://github.com/docker-library/mysql).

The project idea is coming from [Blog Zenika](http://blog.zenika.com/index.php?post/2014/10/07/Setting-up-a-development-environment-using-Docker-and-Vagrant).
