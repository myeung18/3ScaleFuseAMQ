pipeline {
    agent {
        node {
            label 'maven'
        }
    }
    environment { 
        openShiftHost = 'https://master.rhdp.ocp.cloud.lab.eng.bos.redhat.com:8443'
        openShiftToken = 'mTREpHpIp2NUucoR75dyuhmf1aM_gx2af2kLR0C1A94'
        mySqlUser = 'dbuser'
        mySqlPwd = 'password'
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
                projectName = 'rh-dev'
            }
            steps {
                echo "Building.. ${serviceName} "
                build(env.serviceName)

                echo "Deploying ${serviceName} to ${projectName}"
                jdeploy(env.serviceName, env.projectName, env.openShiftHost, env.openShiftToken, env.mySqlUser, env.mySqlPwd)

            }
        }
        stage('Build fisuser-service') {
            environment { 
                serviceName = 'fisuser-service'
                projectName = 'rh-dev'
            }
            steps {
                echo "Building.. ${serviceName} "
                build(env.serviceName)

                echo "Deploying ${serviceName} to ${projectName}"
                deploy(env.serviceName, env.projectName, env.openShiftHost, env.openShiftToken, env.mySqlUser, env.mySqlPwd)
           }
        }
        stage('Build fisalert-service') {
            environment { 
                serviceName = 'fisalert-service'
                projectName = 'rh-dev'
            }
            steps {
                echo "Building.. ${serviceName} "
                build(env.serviceName)

                echo "Deploying ${serviceName} to ${projectName}"
                deploy(env.serviceName, env.projectName, env.openShiftHost, env.openShiftToken, env.mySqlUser, env.mySqlPwd)
            }
        }
        stage('Build nodejsalert-ui') {
            environment { 
                serviceName = 'nodejsalert-ui'
                projectName = 'rh-testing'
            }
            steps {
                echo 'Building.. ${serviceName}'
                sh '''  
                    ls -last 
                '''

                node ('nodejs') {
                    git "https://github.com/myeung18/3ScaleFuseAMQ" 
 
                    script {
                        sh """
                        cd ${serviceName}

                        oc login ${openShiftHost} --token=${openShiftToken} --insecure-skip-tls-verify 
                        oc project ${projectName}

                        npm install && npm run openshift
                        """
                    }
                } 
            }
        }
        stage('Pushing to Test') {
            environment {
                projectName = 'rh-testing'
                imageNameSpace = 'rh-dev'
                srcTag = 'latest'
                destTag = 'promoteTest'
                serviceName = 'maingateway-service'
            }
            steps {
                sh ''' 
                    echo "Testing should be done here"
                    sleep 5

                ''' 

                echo "Deployment to ${projectName} "
                promoteServiceSetup(openShiftHost, openShiftToken, 'maingateway-service', env.imageNameSpace, env.destTag, env.projectName)    
                promoteService(env.imageNameSpace, env.projectName,'maingateway-service', env.srcTag, env.destTag)

                promoteServiceSetup(openShiftHost, openShiftToken, 'fisuser-service', env.imageNameSpace, env.destTag, env.projectName)    
                promoteService(env.imageNameSpace, env.projectName, 'fisuser-service', env.srcTag, env.destTag)

                promoteServiceSetup(openShiftHost, openShiftToken, 'fisalert-service', env.imageNameSpace, env.destTag, env.projectName)    
                promoteService(env.imageNameSpace, env.projectName, 'fisalert-service', env.srcTag, env.destTag)

                promoteServiceSetup(openShiftHost, openShiftToken, 'nodejsalert-ui', env.destTag, env.projectName)    
                promoteService(env.imageNameSpace, env.projectName, 'nodejsalert-ui', env.srcTag, env.destTag)
            }
        }
        stage('Pushing to Prod') {
            environment {
                projectName = 'rh-prod'
                imageNameSpace = 'rh-dev'
                srcTag = 'latest'
                destTag = 'promoteProd'
                serviceName = 'maingateway-service'
            }
            steps {
                timeout(time: 2, unit: 'DAYS') {
                  input message: 'Approve to production?'
                }
                echo 'Deploying....${projectName} '
                
                promoteServiceSetup(openShiftHost, openShiftToken, env.serviceName, env.imageNameSpace, env.destTag, env.projectName)    
                promoteService(env.imageNameSpace, env.projectName, env.serviceName, env.srcTag, env.destTag)

            }
        }
    }
}

def promoteServiceSetup(openShiftHost, openShiftToken, svcName, imageNameSpace, tagName, projName) {
    sh """ 
        oc login ${openShiftHost} --token=${openShiftToken} --insecure-skip-tls-verify 
        oc create dc ${svcName} --image=docker-registry.default.svc:5000/${imageNameSpace}/${svcName}:${tagName} -n ${projName} 
        oc deploy ${svcName} --cancel -n ${projName}
        oc expose dc ${svcName} --port=8080 -n ${projName}
        oc expose svc ${svcName} --name=${svcName} -n ${projName}
         
    """

}
def promoteService (imageNamespace, projName, svcName, sourceTag, destinationTag) {
    echo  "hello method out   ${projName} "
    openshiftTag(namespace: imageNamespace,
                  srcStream: svcName,
                  srcTag: sourceTag,
                  destStream: svcName,
                  destTag: destinationTag)

    openshiftDeploy(namespace: projName,
  			     deploymentConfig: svcName,
			     waitTime: '300000')

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
