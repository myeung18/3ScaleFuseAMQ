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
        openShiftToken = '_km-0ze-iwrZ-AxuljO9HYB5NBkEYOcpR07oWs-Hh2c'
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
            }
            steps {
                echo 'Building..'
                sh '''  
                    ls -last 
                '''
                 
                script {
                    osUtil.cmdDeploy()
                } 
            }
        }
        stage('Build fisuer-service') {
            environment { 
                serviceName = 'fisuser-service'
            }
            steps {
                echo 'Building..'
                sh '''  
                    ls -last 
                '''
                 
                script {
                    osUtil.cmdDeploy()
                } 
            }
        }
        stage('Pushing to Test') {
            steps {
                sh '''

                '''
              openshiftTag(namespace: 'justfortesting',
                      srcStream: 'maingateway-service',
                      srcTag: 'latest',
                      destStream: 'maingateway-service',
                      destTag: 'promotePRD')
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
