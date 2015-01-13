# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.6"

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'docker'

DOCKER_HOST_NAME = "PROJECT_CODE_dockerhost"
DOCKER_HOST_VAGRANTFILE = "./DockerHostVagrantfile"

# We need vagrant-vbguest.
unless Vagrant.has_plugin?("vagrant-vbguest")
  puts "--- WARNING ---"
  puts "We need the vagrant plugin: vagrant-vbguest"
  puts "Please install it in your system by typing:"
  puts "vagrant plugin install vagrant-vbguest"
  raise 'vagrant-vbguest not installed.'
end

Vagrant.configure(2) do |config|
  # Data container.
  config.vm.define "data" do |data|
    data.vm.provider "docker" do |d|
      d.build_dir = "./Docker/data"
      d.build_args = ["-t=PROJECT_CODE-data:devel"]

      d.name = "PROJECT_CODE-data"
      d.remains_running = false

      d.vagrant_machine = "#{DOCKER_HOST_NAME}"
      d.vagrant_vagrantfile = "#{DOCKER_HOST_VAGRANTFILE}"
      d.force_host_vm = true
    end
  end

  # Mysql Server.
  config.vm.define "mysql" do |m|
    m.vm.provider "docker" do |d|
      d.build_dir = "./Docker/mysql"
      d.build_args = ["-t=PROJECT_CODE-mysql:devel"]

      d.name = "PROJECT_CODE-mysql"
      d.create_args = ["--volumes-from", "PROJECT_CODE-data"]
      d.remains_running = true

      d.vagrant_machine = "#{DOCKER_HOST_NAME}"
      d.vagrant_vagrantfile = "#{DOCKER_HOST_VAGRANTFILE}"
      d.force_host_vm = true
    end
  end

  # PHP-FPM.
  config.vm.define "fpm" do |f|
    f.vm.provider "docker" do |d|
      d.build_dir = "./Docker/drupal"
      d.build_args = ["-t=PROJECT_CODE-drupal:devel"]

      d.name = "PROJECT_CODE-php-fpm"
      d.cmd = ["fpm", "devel"]
      d.create_args = ["--volumes-from", "PROJECT_CODE-data"]
      d.link("PROJECT_CODE-mysql:db")
      # We mount drupal folder directly so that we
      # can edit source code in host machine.
      d.volumes = ["/vagrant/Docker/drupal/drupal:/var/www/drupal"]
      d.remains_running = true

      d.vagrant_machine = "#{DOCKER_HOST_NAME}"
      d.vagrant_vagrantfile = "#{DOCKER_HOST_VAGRANTFILE}"
      d.force_host_vm = true
    end
  end

  # PHP Cron.
  config.vm.define "cron" do |c|
    c.vm.provider "docker" do |d|
      d.image = "PROJECT_CODE-drupal:devel"

      d.name = "PROJECT_CODE-php-cron"
      d.cmd = ["cron"]
      d.create_args = ["--volumes-from", "PROJECT_CODE-data"]
      d.link("PROJECT_CODE-mysql:db")
      # We mount drupal folder directly so that we
      # can edit source code in host machine.
      d.volumes = ["/vagrant/Docker/drupal/drupal:/var/www/drupal"]
      d.remains_running = true

      d.vagrant_machine = "#{DOCKER_HOST_NAME}"
      d.vagrant_vagrantfile = "#{DOCKER_HOST_VAGRANTFILE}"
      d.force_host_vm = true
    end
  end

  # Nginx
  config.vm.define "nginx" do |n|
    n.vm.provider "docker" do |d|
      d.image = "PROJECT_CODE-drupal:devel"

      d.name = "PROJECT_CODE-nginx"
      d.cmd = ["nginx"]
      d.create_args = ["--volumes-from", "PROJECT_CODE-data"]
      d.link("PROJECT_CODE-php-fpm:fpm")
      # We mount drupal folder directly so that we
      # can edit source code in host machine.
      d.volumes = ["/vagrant/Docker/drupal/drupal:/var/www/drupal"]
      d.remains_running = true
      d.ports = ["80:80"]

      d.vagrant_machine = "#{DOCKER_HOST_NAME}"
      d.vagrant_vagrantfile = "#{DOCKER_HOST_VAGRANTFILE}"
      d.force_host_vm = true
    end
  end

end
