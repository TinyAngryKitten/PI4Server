kubectl create serviceaccount dashboard
kubectl create clusterrolebinding dashboard --clusterrole=cluster-admin --serviceaccount=default:dashboard

#find secret
#kubectl get secrets
#then find the name of the dashboard user secret and insert it below
#kubectl describe secret dashboard-token-l7psc
#enter this as token at something like localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/
