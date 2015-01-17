# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.6"

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'docker'

docker_host_name = "PROJECT_CODE_dockerhost"
docker_host_vagrantfile = "./DockerHostVagrantfile"

# We need vagrant-vbguest.
unless Vagrant.has_plugin?("vagrant-vbguest")
  puts "--- WARNING ---"
  puts "We need the vagrant plugin: vagrant-vbguest"
  puts "Please install it in your system by typing:"
  puts "vagrant plugin install vagrant-vbguest"
  raise 'vagrant-vbguest not installed.'
end

Vagrant.configure(2) do |config|
  # Syslog container.
  config.vm.define "syslog" do |syslog|
    syslog.vm.provider "docker" do |d|
      d.build_dir = "./Docker/syslog"
      d.build_args = ["-t=syslog:devel"]

      d.name = "syslog"
      d.volumes = ["/tmp/syslog/dev:/dev"]
      d.remains_running = true

      d.vagrant_machine = "#{docker_host_name}"
      d.vagrant_vagrantfile = "#{docker_host_vagrantfile}"
      d.force_host_vm = true
    end
  end

  # Data file container.
  config.vm.define "PROJECT_CODE-data-file" do |data|
    data.vm.provider "docker" do |d|
      d.build_dir = "./Docker/data-file"
      d.build_args = ["-t=PROJECT_CODE-data-file:devel"]

      d.name = "PROJECT_CODE-data-file"
      d.remains_running = false

      d.vagrant_machine = "#{docker_host_name}"
      d.vagrant_vagrantfile = "#{docker_host_vagrantfile}"
      d.force_host_vm = true
    end
  end
  # Data SQL container.
  config.vm.define "PROJECT_CODE-data-sql" do |data|
    data.vm.provider "docker" do |d|
      d.build_dir = "./Docker/data-sql"
      d.build_args = ["-t=PROJECT_CODE-data-sql:devel"]

      d.name = "PROJECT_CODE-data-sql"
      d.remains_running = false

      d.vagrant_machine = "#{docker_host_name}"
      d.vagrant_vagrantfile = "#{docker_host_vagrantfile}"
      d.force_host_vm = true
    end
  end

  # Mysql Server.
  config.vm.define "PROJECT_CODE-mysql" do |m|
    m.vm.provider "docker" do |d|
      d.build_dir = "./Docker/mysql"
      d.build_args = ["-t=PROJECT_CODE-mysql:devel"]

      d.name = "PROJECT_CODE-mysql"
      d.volumes = ["/tmp/syslog/dev/log:/dev/log"]
      d.create_args = ["--volumes-from", "PROJECT_CODE-data-sql"]
      d.remains_running = true

      d.vagrant_machine = "#{docker_host_name}"
      d.vagrant_vagrantfile = "#{docker_host_vagrantfile}"
      d.force_host_vm = true
    end
  end

  # PHP-FPM.
  config.vm.define "PROJECT_CODE-php-fpm" do |f|
    f.vm.provider "docker" do |d|
      d.build_dir = "./Docker/drupal"
      d.build_args = ["-t=PROJECT_CODE-drupal:devel"]

      d.name = "PROJECT_CODE-php-fpm"
      d.cmd = ["fpm", "devel"]
      d.create_args = ["--volumes-from", "PROJECT_CODE-data-file"]
      d.link("PROJECT_CODE-mysql:db")
      # We mount drupal folder directly so that we
      # can edit source code in host machine.
      d.volumes = ["/vagrant/Docker/drupal/drupal:/var/www/drupal", "/tmp/syslog/dev/log:/dev/log"]
      d.remains_running = true

      d.vagrant_machine = "#{docker_host_name}"
      d.vagrant_vagrantfile = "#{docker_host_vagrantfile}"
      d.force_host_vm = true
    end
  end

  # PHP Cron.
  config.vm.define "PROJECT_CODE-php-cron" do |c|
    c.vm.provider "docker" do |d|
      d.build_dir = "./Docker/drupal"
      d.build_args = ["-t=PROJECT_CODE-drupal:devel"]

      d.name = "PROJECT_CODE-php-cron"
      d.cmd = ["cron"]
      d.create_args = ["--volumes-from", "PROJECT_CODE-data-file"]
      d.link("PROJECT_CODE-mysql:db")
      # We mount drupal folder directly so that we
      # can edit source code in host machine.
      d.volumes = ["/vagrant/Docker/drupal/drupal:/var/www/drupal", "/tmp/syslog/dev/log:/dev/log"]
      d.remains_running = true

      d.vagrant_machine = "#{docker_host_name}"
      d.vagrant_vagrantfile = "#{docker_host_vagrantfile}"
      d.force_host_vm = true
    end
  end

  # Nginx
  config.vm.define "PROJECT_CODE-nginx" do |n|
    n.vm.provider "docker" do |d|
      d.build_dir = "./Docker/drupal"
      d.build_args = ["-t=PROJECT_CODE-drupal:devel"]

      d.name = "PROJECT_CODE-nginx"
      d.cmd = ["nginx"]
      d.create_args = ["--volumes-from", "PROJECT_CODE-data-file"]
      d.link("PROJECT_CODE-php-fpm:fpm")
      # We mount drupal folder directly so that we
      # can edit source code in host machine.
      d.volumes = ["/vagrant/Docker/drupal/drupal:/var/www/drupal", "/tmp/syslog/dev/log:/dev/log"]
      d.remains_running = true
      d.ports = ["80:80"]

      d.vagrant_machine = "#{docker_host_name}"
      d.vagrant_vagrantfile = "#{docker_host_vagrantfile}"
      d.force_host_vm = true
    end
  end

end
