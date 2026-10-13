create:
	eksctl create cluster -f eks-cluster.yaml

deploy:
	kubectl apply -f kubernetes/configmap.yaml
	kubectl apply -f kubernetes/secret.yaml
	kubectl apply -f kubernetes/deployment.yaml
	kubectl apply -f kubernetes/service.yaml

verify:
	kubectl get nodes
	kubectl get pods
	kubectl get svc

destroy:
	eksctl delete cluster -f eks-cluster.yaml
