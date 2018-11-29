@Library('cicdutils@master') 
def osUtil = new com.openshift.global.util.DeployUtils() 

pipeline {
    agent any
    tools {
        maven 'maven-3'
        jdk 'jdk1.8.0'
        oc 'oc'
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
            steps {
                echo 'Building..'
                sh '''  
                    ls -last 

                    cd nodejsalert-ui

                    oc login https://master.rhdp.ocp.cloud.lab.eng.bos.redhat.com:8443 --token=WddnuYe5y7_7CslKND9tWdS2vn6CRLR5eRu5OlOrITI 
                    
                    oc project justfortesting                    

                    export PATH=$PATH:/usr/local/bin 
                        
                    npm install && npm run openshift
                    
                '''
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
