#! /bin/bash

##
# Change the following variables for your new project.
##

# The project code will be used as part of your:
# - Dockerhost hostname prefix
# - Docker image name prefix
# - Docker container name prefix
# - Drupal database name
# It is suggested to use only one short alphanumeric word without special characters, e.g. foobar.
PROJECT_CODE=vdd

# The IP that will be assigned to the DockerHost VM, host-only IP.
# Only valid for user running a VM for DockerHost.
DOCKER_HOST_IP=192.168.59.104

### End of Configuration ###



##
# Start executions.
##
# Replace the PROJECT_CODE token in the config files.
find ./ -name '*Vagrantfile' -type f -print0 | xargs -0 sed -i '' -e 's/PROJECT_CODE/'$PROJECT_CODE'/g'
find ./Docker -type f -print0 | xargs -0 sed -i '' -e 's/PROJECT_CODE/'$PROJECT_CODE'/g'

# Replace the DOCKER_HOST_IP.
sed -i '' -e 's/DOCKER_HOST_IP/'$DOCKER_HOST_IP'/g' ./DockerHostVagrantfile

# Finish.
echo 'Done. You can type the following command to start the project:'
echo 'vagrant up --no-parallel'
