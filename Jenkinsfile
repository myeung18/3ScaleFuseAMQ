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
            steps {
                echo 'Building..'
                sh '''  
                    ls -last 

                    cd maingateway-service 

                    mvn package -Dmaven.test.skip=true 
                    
                    oc login https://master.rhdp.ocp.cloud.lab.eng.bos.redhat.com:8443 --token=WddnuYe5y7_7CslKND9tWdS2vn6CRLR5eRu5OlOrITI 
                    
                    oc project justfortesting                    

                    mvn fabric8:deploy 
                    
                '''
            }
        }
        stage('Build fisuser') {
            steps {
                echo 'Building..'
                sh '''  
                    ls -last 

                    cd fisuser-service 

                    mvn package -Dmaven.test.skip=true 
                    
                    oc login https://master.rhdp.ocp.cloud.lab.eng.bos.redhat.com:8444 --token=WddnuYe5y7_7CslKND9tWdS2vn6CRLR5eRu5OlOrITI 
                    
                    oc project justfortesting                    

                    mvn fabric8:deploy 
                    
                '''
            }
        }
         stage('Build fisalert') {
            steps {
                echo 'Building..'
                sh '''  
                    ls -last 

                    cd fisalert-service 

                    mvn package -Dmaven.test.skip=true 
                    
                    oc login https://master.rhdp.ocp.cloud.lab.eng.bos.redhat.com:8443 --token=WddnuYe5y7_7CslKND9tWdS2vn6CRLR5eRu5OlOrITI 
                    
                    oc project justfortesting                    

                    mvn fabric8:deploy -Dmaven.test.skip=true  
                    
                '''
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
