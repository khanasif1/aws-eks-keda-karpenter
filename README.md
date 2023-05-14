<p>
<img src="https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white" />
<img src="https://img.shields.io/badge/python%20-%2314354C.svg?&style=for-the-badge&logo=python&logoColor=white"/>
<img src="https://img.shields.io/badge/AWS%20-%23FF9900.svg?&style=for-the-badge&logo=amazon-aws&logoColor=white"/> 
<img src="https://img.shields.io/badge/docker%20-%230db7ed.svg?&style=for-the-badge&logo=docker&logoColor=white"/>
<img src="https://img.shields.io/badge/AWS-EKS-orange"/>
<img src="https://img.shields.io/badge/KEDA-2.5.0-blue"/>
<img src="https://img.shields.io/badge/Karpenter-0.3.0-green"/>
</p>


# EKS with KEDA HPA & Karpenter cluster autoscaler
This repository contains the necessary files and instructions to deploy and configure [KEDA](https://keda.sh/) (Kubernetes-based Event Driven Autoscaling) and [Karpenter](https://github.com/awslabs/karpenter) (Kubernetes Node Autoscaler) on an Amazon Elastic Kubernetes Service (EKS) cluster.

KEDA enables autoscaling of Kubernetes pods based on the number of events in event sources such as Azure Service Bus, RabbitMQ, Kafka, and more. Karpenter is a Kubernetes node autoscaler that scales the number of nodes in your cluster based on resource usage.

*** 
## Sample Usecase 
<p align="center">
  <img  src="https://github.com/khanasif1/aws-eks-with-keda-hpa/blob/main/img/Keda.gif?raw=true">
</p>

## Prerequisites

Before you begin, ensure that you have the following prerequisites:

- An active AWS account.
- Kubernetes command-line tool (`kubectl`) installed.
- [eksctl](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)
- [AWS CLI](https://aws.amazon.com/cli/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
- [helm](https://helm.sh/)

## Installation

To install KEDA and Karpenter on your AWS EKS cluster, follow these steps:

1. Clone this repository to your local machine or download it as a ZIP file.
   ```shell
   git clone https://github.com/khanasif1/aws-eks-keda-karpenter.git
   ```

2. Navigate to the repository's directory.
   ```shell
   cd aws-eks-keda-karpenter
   ```

3. C

## Configuration

The repository contains the necessary configuration files for deploying KEDA and Karpenter. You can modify these files to suit your specific requirements. Here are some important files to note:

- `keda/deploy/`: Contains the deployment files for KEDA components.
- `karpenter/deploy/`: Contains the deployment files for Karpenter components.
- `karpenter/config/`: Contains the configuration files for Karpenter.

Feel free to modify these files according to your needs.

## Contributing

Contributions to this repository are welcome. If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

## License

This repository is licensed under the [MIT License](LICENSE). Please refer to the [LICENSE](LICENSE) file for more details.

## Acknowledgements

- [KEDA](https://keda.sh/) - Kubernetes-based Event Driven Autoscaling
- [Karpenter](https://github.com/awslabs/karpenter) - Kubernetes Node Autoscaler

## Contact

For any questions or inquiries, please contact:

Your Name  
Email: [khanasif1@gmail.com](mailto:khanasif1@gmail.com)  
Website: [https://khanasif1.wordpress.com](https://khanasif1.wordpress.com/)