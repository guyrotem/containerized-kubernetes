# containerized-kubernetes
Bootstrap a Kubernetes single-node testing cluster inside a container with minimum prerequisites.

## Why should I use it?
There are several options to run a local Kubernetes testing cluster: [minikube](https://minikube.sigs.k8s.io/docs/), [kind](https://kind.sigs.k8s.io/), [k3s](https://k3s.io/), which you should probably consider first, however the containerized-kubernetes solution requires nothing but docker runtime installed.
It is therefore useful for environments where you cannot or would like to avoid installing additional tools: CI environments you have no control of, or your colleagues who would like to run tests without additional installations.

This solution is based on "kind" (by eliminating the dependency on kind CLI/Go), for the basic scenario of a single-node cluster. More configurations might be added in the future, however it is highly recommended to use "kind" directly if circumstances allow it, as it is much more mature, better maintained and feature-ful.

## Instructions

### Use latest release image

`docker pull guyrotem/kubernetes:latest`

`docker run ...`    //  TODO

`docker exec ... bootstrap-k8s` 

`docker exec ... post-init`

`... copy /etc/kubernetes/admin.conf ...`

... use kubectl or your favorite [Kubernetes client](https://kubernetes.io/docs/reference/using-api/client-libraries/) with the obtained client auth.  

### Build your own image
 
`docker build -t $imageName /image`

`docker run <... many flags> -t $imageName`

`docker exec ... bootstrap-k8s $containerIp`

`docker exec ... post-init`

`... copy /etc/kubernetes/admin.conf ...`