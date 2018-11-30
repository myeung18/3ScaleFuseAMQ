@Library('cicdutils@master') 
def osUtil = new com.openshift.global.util.DeployUtils() 

pipeline {
    agent any
    tools {
        maven 'maven-3'
        jdk 'jdk1.8.0'
        oc 'oc'
    }
    environment { 
        openShiftHost = 'https://master.rhdp.ocp.cloud.lab.eng.bos.redhat.com:8443'
        openShiftToken = 'iLJqUd4yHDwpn_kZigpNi-QwNSCC9H-IOYZJQ_b0oPo'
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
                script {
                    osUtil.cmdDeploy()
                }
            }
        }
        stage('Build fisuser') {
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
         stage('Build fisalert') {
            environment { 
                serviceName = 'fisalert-service'
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
        stage('Build UI') {
            environment { 
                serviceName = 'nodejsalert-ui'
            }
            steps {
                echo 'Building..'
                sh '''  
                    ls -last 
                '''
                script {
                    osUtil.cmdNpmDeploy()
                }
            }
        }
        stage('Test') {
            steps {
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
