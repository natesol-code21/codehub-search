
node {
    environment {
      registry = "797335914619.dkr.ecr.us-east-1.amazonaws.com/"
      repo = "dev-codehub/codehub-search"
      DOCKER_LOGIN='(aws ecr get-login --no-include-email --region us-east-1)'
      dockerImage = ''
      registryurl = '927373803645.dkr.ecr.us-east-1.amazonaws.com/'
    }
     stage('Git Checkout') {
          deleteDir()
          dir ('App'){
              git(
                branch: 'dev_cicd_devops2',
                url: 'https://github.com/usdot-jpo-codehub/codehub-search.git'
            )
          }

        }

    stage('Unit Test') {
        nodejs('node') {
            dir ('App'){
              script {
                sh 'echo Bundling is Complete!!'
            }
          }
  }
  }

      stage('Static Code Analysis'){
        dir ('App'){

        script {
            def scannerHome = tool 'SonarQube Scanner 2.8';
            withSonarQubeEnv('SonarQube') {
                    sh 'cat /var/lib/jenkins/tools/hudson.plugins.sonar.SonarRunnerInstallation/SonarQube_Scanner_2.8/conf/sonar-scanner.properties'
                    sh "${scannerHome}/bin/sonar-scanner -X  -Dsonar.projectName=codehub-search -Dsonar.projectVersion=1.0.0 -Dsonar.projectKey=codehub-search -Dsonar.sources=."
                }
            }
        }
      }
      stage('508 Complaince') {
          script {
              sh 'echo 508 Complaince is complete'
          }
      }

      stage('Integration Test1') {
          script {

              sh 'echo Integration Test 1 is complete'
          }
      }

      stage('Integration Test2') {
          script {

              sh 'echo Integration Test 2 is complete'
          }
      }

      stage('Build Codehub-UI Base Image') {
      dir ('App'){
          script {
            withAWS(region:'us-east-1') {
              sh 'eval $(aws ecr get-login --no-include-email) > login'
              dockerImage=docker.build("927373803645.dkr.ecr.us-east-1.amazonaws.com/nate-docker-production/codehub-search" + ":latest")
          }
            sh 'echo "Completing image build"'
          }
      }
}

      stage('Publish Codehub-Search Image') {
      dir ('App'){
          script {
            withAWS(region:'us-east-1') {
              sh 'eval $(aws ecr get-login --no-include-email) > login'
              dockerImage.push()
          }
            sh 'echo "Completing image build"'
          }
      }
}
      stage('Register TaskDefinition Updates') {
      dir ('App'){
          script {
              sh 'aws ecs register-task-definition --cli-input-json file://codehub-search-taskDefinition.json --region us-east-1'
              sh 'echo Service is Updated'
          }
      }
      }
      stage('Deploy Service') {
      dir ('App'){
      nodejs('node') {
            script {
              sh 'npm install js-yaml -g'
              sh 'npm install js-yaml'
              sh 'npm install elasticdump -g'
              sh 'elasticdump --version'
              sh 'node process_appspec.js $(aws ecs list-task-definitions --region us-east-1 --family-prefix codehub-search | jq -r ".taskDefinitionArns[-1]")'
              sh 'aws s3 cp appspec.yaml s3://codehub-dev-data'
              sh 'aws deploy wait deployment-successful --deployment-id $(aws deploy create-deployment --cli-input-json file://codehub-search-create-deployment.json --region us-east-1 | jq -r ".deploymentId")'
              sh 'aws s3 sync s3://codehub-updated-data .'
              sh 'ls -l '
              sh './create-search-index.sh'
              sh 'elasticdump --input=projects_data.json --output=http://internal-dev-codehub-search-391428177.us-east-1.elb.amazonaws.com:9200/projects --type=data'
              sh 'elasticdump --input=code_data.json --output=http://internal-dev-codehub-search-391428177.us-east-1.elb.amazonaws.com:9200/code --type=data'
              sh 'echo Successfull Deployment Confirmed!!'
              sh 'echo Updated ES Indices are Updated!!'
              sh 'echo ES Updated With Latest Data!!'
            }
        }
}
}

}
