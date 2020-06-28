# containerized-kubernetes
Bootstrap a Kubernetes single-node testing cluster inside a container with minimum prerequisites.

## Why should I use it?
There are several options to run a local Kubernetes testing cluster: [minikube](https://minikube.sigs.k8s.io/docs/), [kind](https://kind.sigs.k8s.io/), [k3s](https://k3s.io/), which you should probably consider first, however the containerized-kubernetes solution requires nothing but docker runtime installed.
It is therefore useful for environments where you cannot or would like to avoid installing additional tools: CI environments you have no control of, or your colleagues who would like to run tests without additional installations.

This solution is based on "kind" (by eliminating the dependency on kind CLI/Go), for the basic scenario of a single-node cluster. More configurations might be added in the future, however it is highly recommended to use "kind" directly if circumstances allow it, as it is much more mature, better maintained and feature-ful.

## Instructions

### Use latest release image

`docker pull guyrotem/kubernetes:latest`


`NODE_NAME=k8s-control-plane`

`KUBE_CONFIG_PATH=~/.kube/containerized-k8s`

`CONTAINERIZED_K8S_PORT=32768`

`DOCKER_CLIENT_IP=127.0.0.1` #Mac

`API_SERVER_PORT=6443`


`docker run --name=$NODE_NAME --hostname=$NODE_NAME --privileged --security-opt seccomp=unconfined --security-opt apparmor=unconfined --tmpfs /tmp --tmpfs /run -p $DOCKER_CLIENT_IP:$CONTAINERIZED_K8S_PORT:$API_SERVER_PORT --tty --label io.x-k8s.kind.role="control-plane" --label io.x-k8s.kind.cluster="k8s" --detach=true -t guyrotem/kubernetes`

`CONTAINER_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $NODE_NAME)`

`docker exec -it k8s-control-plane bootstrap-k8s.sh`

`docker exec -it k8s-control-plane post-init.sh`


// retrieve admin credentials

`docker exec -it k8s-control-plane cat /etc/kubernetes/admin.conf | sed "s|$CONTAINER_IP:6443|127.0.0.1:$CONTAINERIZED_K8S_PORT|g" > $KUBE_CONFIG_PATH`

// verify

// create busybox

`cat <<EOF | kubectl --kubeconfig $KUBE_CONFIG_PATH create -f -                        
apiVersion: v1
kind: Pod
metadata:
  name: busybox
  labels:
    app: busybox
spec:
  containers:
    - image: busybox
      command:
        - sleep
        - "1800"
      imagePullPolicy: IfNotPresent
      name: busybox
EOF`

// make sure pod is running

`kubectl --kubeconfig $KUBE_CONFIG_PATH get pods`

... use kubectl or your favorite [Kubernetes client](https://kubernetes.io/docs/reference/using-api/client-libraries/) with the obtained client auth.  

### Build your own image
 
`docker build -t $imageName /image`

`docker run <... many flags> -t $imageName`

`docker exec ... bootstrap-k8s $containerIp`

`docker exec ... post-init`

`... copy /etc/kubernetes/admin.conf ...`
