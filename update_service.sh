#!/bin/bash
# $1 => AWS_REGION
# $2 => ECR_URL
# $3 => ECS_CLUSTER_NAME
# $4 => ECS_SERVICE_NAME
# Ejemplo:
# ./update_service.sh AWS_REGION ECR_URL ECS_CLUSTER_NAME ECS_SERVICE_NAME        
aws ecr get-login-password --region $1 
aws ecs update-service --cluster $3 --service $4 --force-new-deployment
