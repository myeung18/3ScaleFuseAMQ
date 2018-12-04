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
        mySqlUser = 'root'
        mySqlPwd = 'ncPIGN8cKa5Aki4c'
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
                echo "Building.. ${serviceName} "
                build(env.serviceName)

                echo "Deploying ${serviceName} to ${projectName}"
                deploy(env.serviceName, env.projectName, env.openShiftHost, env.openShiftToken, env.mySqlUser, env.mySqlPwd)

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

def build(folderName) {
    sh """

    cd ${folderName}
    
    mvn package -Dmaven.test.skip=true 
    """

}
def deploy(folderName, projName, openShiftHost, openShiftToken, mysqlUser, mysqlPwd) {
    sh """
    cd ${folderName}

    oc login ${openShiftHost} --token=${openShiftToken} --insecure-skip-tls-verify
    oc project ${projName} 

    mvn fabric8:deploy -Dmaven.test.skip=true -Dmysql-service-username=${mysqlUser} -Dmysql-service-password=${mysqlPwd}
    """
}
