FROM jpetazzo/dind

RUN apt-get update

RUN apt-get install nano
RUN apt-get install git -y

# Source for Installing SSH Server: https://github.com/rastasheep/ubuntu-sshd/blob/master/14.04/Dockerfile
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

RUN echo 'root:root' |chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
#RUN sed -ri 's/ClientAliveInterval 5/#ClientAliveInterval 5/g' /etc/ssh/sshd_config
#RUN sed -ri 's/ClientAliveCount 1/#ClientAliveCount 1/g' /etc/ssh/sshd_config
RUN echo 'ClientAliveInterval 1800'>> /etc/ssh/sshd_config
RUN echo 'ClientAliveCountMax 10' >> /etc/ssh/sshd_config


#RUN sed -ri 's/^#?ClientAliveInterval\s+.*/ClientAliveInterval 5/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

  
RUN /bin/bash -c \
               'curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"; \
               sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl; \
               rm kubectl; \
               curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3; \
               chmod 700 get_helm.sh; \
               ./get_helm.sh; \
               rm get_helm.sh'

# Bash-Completion for Kubectl https://kubernetes.io/docs/tasks/tools/included/optional-kubectl-configs-bash-linux
RUN apt-get update
RUN apt-get install bash-completion
RUN kubectl completion bash > /etc/bash_completion.d/kubectl

EXPOSE 22

# CMD    ["/usr/sbin/sshd", "-D"]
ENTRYPOINT service ssh restart && service docker start && bash
