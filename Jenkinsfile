@Library('cicdutils@master') 
def osUtil = new com.openshift.global.util.DeployUtils() 

pipeline {
    agent any
    /* agent {
        node {
            label 'maven'
        }
    } */
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
        stage('Build Gateway') {
            environment { 
                serviceName = 'maingateway-service'
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
        stage('Test') {
            steps {
                sh '''

                '''
              openshiftTag(namespace: 'justfortesting',
                      srcStream: 'maingateway-service',
                      srcTag: 'latest',
                      destStream: 'maingateway-service',
                      destTag: 'promoteXX')
                echo 'Testing..'
            }
        }
        stage('Pushing to UAT') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
