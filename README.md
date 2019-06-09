# jenkins-docker-with-docker
This Jenkins docker image is based on Jenkins. It has docker tools installed in it as well.

# Usage
I wanted to easily run a Jenkins instance at home by running a single command and this instance should be able to build any software with minimal modifications to the Jenkins container. 

This use-case immediately lends itself to using the Docker Pipeline plugin. However, the jenkins/jenkins:lts image does not have Docker tools installed.

# How to run
docker run -d -p 8080:8080 -p 50000:50000 -v /var/run/docker.sock:/var/run/docker.sock -v jenkins_home:/var/jenkins_home --name jenkins --net cinet --restart always jdchandler88/jenkins-docker-with-docker:latest

For detailed explanations of the options above, see Docker documentation. The description below explains why the options are set the way they are.

* -d : Runs in detached mode. This runs the process in the background, freeing the terminal that was used to start it
* -p 8080:8080 : Exposes container's port 8080 to the host on port 8080. This is for accessing the Jenkins web interface
* -p 50000:50000 : Exposes container's port 50000 to the host on port 50000. This is for launching build agents. NOTE: I personally do not use this feature yet. At home, I don't build enough software to require build agents.
* -v /var/run/docker.sock:/var/run/docker.sock *Important:* This mounts the host's docker socket into the Jenkins container. This enables running sibling containers and *is not docker-in-docker.* (from https://hub.docker.com/r/jenkinsci/pipeline-as-code-github-demo/). THIS IS HIGHLY RECOMMENDED IF USING THIS IMAGE. Search for "docker-in-docker issues" for why.
* -v jenkins_home:/var/jenkins_home : Creates a volume "jenkins_home" and mounts it in the container's /var/jenkins_home directory.
* --name jenkins : Gives the container a name. If using the "--net" option, this is how other containers on the specified network access this container
* --net cinet : Connects this container to the "cinet" network. (To create the network, run "docker network create cinet"). In my case, this serves the purpose of connecting to other services running on the same network, i.e. Nexus.
* --restart always : Restarts the container always except when manually stopped. For me, I want Jenkins to be always available, even after my host machine restarts.


# Rest of my home CI System

The script I run has the following steps: 

* docker network create cinet
* docker run -d -p 8080:8080 -p 50000:50000 -v /var/run/docker.sock:/var/run/docker.sock -v jenkins_home:/var/jenkins_home --name jenkins --net cinet --restart always jdchandler88/jenkins-docker-with-docker:latest
* docker run -d -p 8081:8081 -v nexus-data:/nexus-data --name nexus --net cinet --restart always sonatype/nexus3
