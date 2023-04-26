<p>
<img src="https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white" />
<img src="https://img.shields.io/badge/python%20-%2314354C.svg?&style=for-the-badge&logo=python&logoColor=white"/>
<img src="https://img.shields.io/badge/AWS%20-%23FF9900.svg?&style=for-the-badge&logo=amazon-aws&logoColor=white"/> 
<img src="https://img.shields.io/badge/docker%20-%230db7ed.svg?&style=for-the-badge&logo=docker&logoColor=white"/>
</p>

# EKS with KEDA HPA & Karpenter cluster autoscaler
AWS Elastic Kubernetes with KEDA for horizontal pod autoscaling in conjunction with Karpenter for cluster scaling.

The K8s world has always been aligned with metrics, which is a default inheritance from infrastructure scaling. Considering the number of business usecases that need scaled processing, metics-based scaling psychology is not ideal in the age of microservices, decoupled architectures, and distributed applications.

KEDA is a K8s plug and play module for HPA that deeply integrates with any K8s format be it in cloud or baremetal. With KEDA you can explicitly map the apps you want to use event-driven scale, with other apps continuing to function. This makes KEDA a flexible and safe option to run alongside any number of other Kubernetes applications or frameworks.

*** 

<p align="center">
  <img  src="https://github.com/khanasif1/aws-eks-with-keda-hpa/blob/main/img/Keda.gif?raw=true">
</p>
