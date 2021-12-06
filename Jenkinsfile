pipeline {
    agent any
    parameters {
        string(name: 'version', defaultValue: '', description: 'Número de versión del servicio a publicar')
        string(name: 'artifactId', defaultValue: '', description: 'Id del artefacto creado en esta compilación')
        string(name: 'jarPath', defaultValue: '', description: 'Ruta al .jar del servicio a publicar')
        string(name: 'jarName', defaultValue: '', description: 'Nombre del .jar del servicio a publicar')
        string(name: 'dockerfilePath', defaultValue: '', description: 'Ruta al Dockerfile del servicio a publicar')
        string(name: 'branchName', defaultValue: '', description: 'Nombre del Branch que disparo esta compilación')
        string(name: 'buildNumber', defaultValue: '', description: 'Número de compilación para identificar la imagen a crear')
        string(name: 'repoName', defaultValue: '', description: 'Nombre del repositorio de ECR donde se van a guardar las imágenes')
        string(name: 'serviceName', defaultValue: '', description: 'Nombre del servicio de ECS donde se va a publicar la solución')
    }
    environment {

        VERSION = "${params.version}"

        ARTIFACT_ID = "${params.artifactId}"

        JAR_PATH = "${params.jarPath}"

        JAR_NAME = "${params.jarName}"

        DOCKERFILE_PATH = "${params.dockerfilePath}"

        BRANCH_NAME = "${params.branchName}"

//        BUILD_NUMBER = "${params.buildNumber}"
        BUILD_NUMBER="${BUILD_NUMBER}"

        AWS_REGION = "us-east-1"

//        ECR_URL = "868521053231.dkr.ecr.us-east-1.amazonaws.com/${params.repoName}"
        ECR_URL = "${params.url_ecr}/${params.repoName}"        

        ECR_REPO_NAME = "${params.repoName}"

//        ECS_CLUSTER_NAME = "obl-cluster-prod"
        ECS_CLUSTER_NAME = "${cluster_name}"

        ECS_SERVICE_NAME = "${params.serviceName}"
    }

    stages {
        // En la etapa 'Docker' es donde se genera la imagen del container de la aplicación
        stage('Docker'){
            // Setea las variables de entorno para construir la imagen
            environment
            {
                DOCKER_TAG = "${ARTIFACT_ID}-${VERSION}-${BRANCH_NAME}-${BUILD_NUMBER}"
            }

            steps {
                // Crea la imagen del servicio y realiza un push al repositorio de ecr
                echo "Building docker image... "
                echo "- Proyect: ${ARTIFACT_ID}-${VERSION}"
                echo "- Environmen: ${BRANCH_NAME}"
                sh '''#!/bin/bash
                    sh ./push_ecr_repo.sh $DOCKERFILE_PATH $JAR_PATH $JAR_NAME $AWS_REGION $ECR_URL $ECR_REPO_NAME $DOCKER_TAG $BRANCH_NAME
                '''
                echo "Image published"
            }
        }

        // En la etapa Publish actualiza el servicio de ECS asociado al microservicio para que utilice la última imagen creada
        stage("Publish")
        {
            steps {
                echo "Updating ECS Service..."
                sh '''#!/bin/bash
                    sh ./update_service.sh $AWS_REGION $ECR_URL $ECS_CLUSTER_NAME $ECS_SERVICE_NAME
                '''
                echo "Service updated"
            }
        }
    }
}
