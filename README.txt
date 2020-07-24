MAKE SURE instance, CCI-REPO, is RUNNING!!!


To install ONAP execute the following commands in order:
-------------------------------------------------------


eval `ssh-agent -s`

ssh-add /home/ubuntu/.ssh/ohio-key-pair.pem

ansible-playbook install_onap.yml -e 'ansible_python_interpreter=/usr/bin/python3' --vault-password-file=vault-pwd.txt


To uninstall ONAP servers execute the following command:
-------------------------------------------------------


ansible-playbook uninstall_onap.yml -e 'ansible_python_interpreter=/usr/bin/python3' --vault-password-file=vault-pwd.txt


-------------------------------------------------------
|               FRANKFURT RELEASE - 6.0               |
-------------------------------------------------------
Ubuntu     18.04    image: ami-07c1207a9d40bc3bd
Docker     18.09.5  /opt/app/onap-deployments/latest/roles/docker/tasks/main.yml
RKE        1.0.6    https://rancher.com/docs/rke/latest/en/installation/#download-the-rke-binary
Kubernetes 1.15.11  /opt/app/onap-deployments/latest/roles/kubectl/tasks/main.yml
Helm       2.16.6   /opt/app/onap-deployments/latest/roles/helm/tasks/main.yml



