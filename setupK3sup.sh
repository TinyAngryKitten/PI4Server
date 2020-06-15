#install k3sup and arkade (for installing apps)
curl -sLS https://get.k3sup.dev | sh
curl -sLS https://dl.get-arkade.dev | sudo sh
brew install helm

#install ssh keys to enable k3sup to login
#cat ~/Keys/sshkey.pub | ssh ubuntu@10.0.0.95 "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >>  ~/.ssh/authorized_keys"
#cat ~/Keys/sshkey.pub | ssh ubuntu@10.0.0.96 "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >>  ~/.ssh/authorized_keys"
ssh-copy-id ubuntu@10.0.0.96
ssh-copy-id ubuntu@10.0.0.95

export masterIP=10.0.0.96
export worker1=10.0.0.95
export user=ubuntu

k3sup install \
  --ip $masterIP \
  --user $user \
  --cluster

k3sup join \
  --ip $worker1 \
  --server-ip $masterIP \
  --user $user
