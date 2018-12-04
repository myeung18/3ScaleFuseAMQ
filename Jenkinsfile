@Library('cicdutils@master') 
def osUtil = new com.openshift.global.util.DeployUtils() 

pipeline {
    agent {
        node {
            label 'maven'
        }
    }
    environment { 
        openShiftHost = 'https://master.rhdp.ocp.cloud.lab.eng.bos.redhat.com:8443'
        openShiftToken = 'mTREpHpIp2NUucoR75dyuhmf1aM_gx2af2kLR0C1A94'
    }
    stages {
        stage ("source") {
            steps {
                git 'https://github.com/myeung18/3ScaleFuseAMQ'
            }
        }
        stage('Build maingateway-service') {
            environment { 
                serviceName = 'maingateway-service'
                projectName = 'justfortesting'
            }
            steps {
                echo 'Building..'
                sh '''  
                ls -last 

                cd $serviceName
        
                mvn package -Dmaven.test.skip=true 

                '''
               /* script {
                    osUtil.cmdDeploy()
                } 
                */ 
            }
        }
        stage('Build fisuser-service') {
            environment { 
                serviceName = 'fisuser-service'
                projectName = 'justfortesting'
            }
            steps {
                echo 'Building..'
                sh '''  
                    ls -last 
                '''
                /* 
                script {
                    osUtil.cmdDeploy()
                } 
                */
            }
        }
        stage('Build fisalert-service') {
            environment { 
                serviceName = 'fisalert-service'
                projectName = 'justfortesting'
            }
            steps {
                echo 'Building..'
                sh '''  
                    ls -last 
                '''
                /* 
                script {
                    osUtil.cmdDeploy()
                } 
                */
            }
        }
        stage('Build nodejsalert-ui') {
            environment { 
                serviceName = 'nodejsalert-ui'
                projectName = 'justfortesting'
            }
            steps {
                echo 'Building..'
                sh '''  
                    ls -last 
                '''

                /*
                node ('nodejs') {
                    git "https://github.com/myeung18/3ScaleFuseAMQ" 
 
                    script {
                        osUtil.cmdNpmDeploy()
                    }
                } 
                */
            }
        }
        stage('Pushing to Test') {
            environment {
                projectName = 'rh-testing'
            }
            steps {
                sh '''

                '''
                tagImage('justfortesting','maingateway-service', 'latest','promoteTEST')
                echo 'Testing..'
            }
        }
        stage('Pushing to Prod') {
            steps {
              timeout(time: 2, unit: 'DAYS') {
                  input message: 'Approve to production?'
            }
            echo 'Deploying....'
            }
        }
    }
}

def tagImage (projName, svcName, sourceTag, destinationTag) {
   echo  "hello method out   ${projName} "
      openshiftTag(namespace: projName,
                  srcStream: svcName,
                  srcTag: sourceTag,
                  destStream: svcName,
                  destTag: destinationTag)

    sh '''
       echo  "hello method   ${param1} "

      '''

}
