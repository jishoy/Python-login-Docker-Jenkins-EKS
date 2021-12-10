pipeline{
    agent any
    environment {
        registry = '519852036875.dkr.ecr.us-west-1.amazonaws.com/jishoy-ecr'
        registryCredential = 'my.awsecr.id'
        AWS_DEFAULT_REGION = 'us-west-1'
        AWS_ACCOUNT_ID = '519852036875'
        IMAGE_REPO_NAME =  'jishoy-ecr'
        IMAGE_TAG = 'jish'
        dockerImage = ''
    }
    
  stages{
         stage('Git clone') {
            steps {
             git branch: 'main', changelog: false, poll: false, url: 'https://github.com/jishoy-cloudjournee/python-djanjo-login.git'
              sh 'ls'
            }
         }
     
       stage('Sonarqube') {
         environment {
             scannerHome = tool 'sonar_scanner'
        }   
           
       steps {
         withSonarQubeEnv('sonarqube') {
            sh "${scannerHome}/bin/sonar-scanner"
        }   
         timeout(time: 10, unit: 'MINUTES') {
            waitForQualityGate abortPipeline: true
         }
     }
 }


      
    
       stage('Build Docker') { 
              steps
              {
                //sh 'docker build -t jishoy96/django .'
                script {
                  dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
                 }
              }
          }

      stage('Logging into AWS ECR') {
            steps {
                script {
                    sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
                }
                 
            }
        }
  
     stage('Pushing to ECR') {
     steps {  
         script {
                sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${registry}:$IMAGE_TAG"
                sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"
         }
     }
     }

      stage ('K8S Deploy') {
      steps { 
              kubernetesDeploy(
                configs: 'login.yaml',
                kubeconfigId: 'mycluster',
                enableConfigSubstitution: true
              )               
        }  
      }     
  }
}

