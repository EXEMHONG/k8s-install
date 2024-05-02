#!/bin/sh
sudo systemctl stop firewalld
sudo systemctl disable firewalld


mkdir -p /var/lib/kubelet
# pause 준비한 버전에 맞게 수정
cat <<EOF | sudo tee /var/lib/kubelet/kubeadm-flags.env 
KUBELET_KUBEADM_ARGS=" --container-runtime-endpoint=unix:///var/run/containerd/containerd.sock --pod-infra-container-image=k8s.gcr.io/pause:3.6"
EOF

systemctl restart kubelet
systemctl enable kubelet

kubeadm init --kubernetes-version=v1.27.6 --pod-network-cidr=10.244.0.0/16

if [ $? -ne 0 ]; then
    echo "kubeadm init failed"
    exit
fi

# systemctl enable kubelet
# systemctl start kubelet

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
export KUBECONFIG=/etc/kubernetes/admin.conf


cat <<EOF | sudo tee /etc/resolv.conf
nameserver 8.8.8.8
EOF

# [CNI]
echo "cni : 1. calico 2. flannel"
echo -n "Enter: "
read ans

case $ans in
   1)
        echo "calico"
        cd $INSTALLER_DIR/calico/image
        sudo ctr -n k8s.io images import calico.tar
        cd ..
        kubectl apply -f calico.yaml
    ;;
    2) 
        echo "flannel"
        cd $INSTALLER_DIR/flannel/image
        sudo ctr -n k8s.io images import mirrored-flannelcni-flannel.tar
        sudo ctr -n k8s.io images import mirrored-flannelcni-flannel-cni-plugin.tar
        cd ..
        kubectl apply -f kube-flannel.yml
    ;;
    *)
        echo "no cni"
        break
    ;;
esac

echo "Single Node? [Y/N]"
echo -n "Enter: "
read result

# Setting whether to use kube master node as worker node
# if using kube master node as worker node, apply below command to cluster
if [ "$result" == "Y" ] || [ "$result" == "y" ]; then 
    kubectl taint nodes --all node-role.kubernetes.io/control-plane:NoSchedule-
fi

kubectl get pods -A
kubectl get nodes
