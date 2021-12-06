#!/bin/bash
# Construye la imagen docker y la publica en el repositorio de ECR
# $1 => dockerfile Path
# $2 => .jar Path
# $3 => .jar FILE
# $4 => AWS_REGION
# $5 => ECR_URL
# $6 => ECR_REPO_NAME
# $7 => DOCKER_TAG
# $8 => BRANCH
# Example:
# ./push_ecr_repo.sh DOCKERFILE_PATH JAR_PATH JAR_FILE AWS_REGION ECR_URL ECR_REPO_NAME DOCKER_TAG BRANCH

# Se hace un cd a la carpeta donde se encuentra el .jar debido a que 
# para poder ejecutar el COPY del dockerfile el comando docker build debe ejecutarse en el mismo
# contexto que el .jar
#cd $2

aws ecr get-login-password --region $4 | docker login --username AWS --password-stdin $5
#docker build --build-arg JAR_FILE=$3 -t $5:latest-$8 -t $5:$7 -f $1 .
docker build --build-arg JAR_FILE=$3 -t $5:latest-$8 -t $5:$7  .
docker push --all-tags $5
