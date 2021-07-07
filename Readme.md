# Project with Docker-in-Docker & SSH Server


# Based on 
- RastaSheep - Ubuntu-SSHD (github.com/rastasheep/ubuntu-sshd)
- jpetazzo - dind (github.com/jpetazzo/dind)

# Execute
1. Build Container
```
docker build -t hub.docker.com/andrisro/dockerdindsshstandalone .
```

2. Run-Container
```
docker run --privileged -p 22:22 -t -i hub.docker.com/andrisro/dockerdindsshstandalone .
```