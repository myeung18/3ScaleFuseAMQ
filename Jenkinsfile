pipeline {
    /*agent {
        node {
            label 'maven'
        }
    }*/
    agent any
    parameters{ 
        string (defaultValue: 'notinuse', name:'OPENSHIFT_URL', description:'open shift cluster url')
        string (defaultValue: 'notinuse', name:'OPENSHIFT_TOKEN', description:'open shift token')
        string (defaultValue: 'all', name:'DEPLOY_MODULE', description:'target module to work on')
        string (defaultValue: 'rh-dev', name:'CICD_PROJECT', description:'build or development project')
        string (defaultValue: 'rh-test', name:'TEST_PROJECT', description:'Test project')
        string (defaultValue: 'rh-prod', name:'PROD_PROJECT', description:'Production project')
        string (defaultValue: 'root', name:'MYSQL_USER', description:'My Sql user name')
        string (defaultValue: 'password', name:'MYSQL_PWD', description:'My Sql user password')
        string (defaultValue: 'rh-dev', name:'IMAGENAMESPACE', description:'name space where image deployed')
    }
    environment { 
        openShiftHost = '---'
        openShiftToken = '--'
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
                //build(env.serviceName)

                echo "Deploying ${serviceName} to ${CICD_PROJECT}"
                //deploy(env.serviceName, params.CICD_PROJECT, env.openShiftHost, env.openShiftToken, params.MYSQL_USER, params.MYSQL_PWD)

            }
        }
        stage('Build fisuser-service') {
            environment { 
                serviceName = 'fisuser-service'
                projectName = 'rh-dev'
            }
            steps {
                echo "Building.. ${serviceName} "
                //build(env.serviceName)

                echo "Deploying ${serviceName} to ${projectName}"
                //deploy(env.serviceName, params.CICD_PROJECT, env.openShiftHost, env.openShiftToken, params.MYSQL_USER, params.MYSQL_PWD)
           }
        }
        stage('Build fisalert-service') {
            environment { 
                serviceName = 'fisalert-service'
                projectName = 'rh-dev'
            }
            steps {
                echo "Building.. ${serviceName} "
                //build(env.serviceName)

                echo "Deploying ${serviceName} to ${projectName}"
                //deploy(env.serviceName, params.CICD_PROJECT, env.openShiftHost, env.openShiftToken, params.MYSQL_USER, params.MYSQL_PWD)
            }
        }
        stage('Build nodejsalert-ui') {
            environment { 
                serviceName = 'nodejsalert-ui'
                projectName = 'rh-dev'
            }
            steps {
                echo 'Building.. ${serviceName}'
                /*
                node ('nodejs') {
                    git "https://github.com/myeung18/3ScaleFuseAMQ" 
 
                    script {
                        sh """
                        cd ${serviceName}

                        oc project ${CICD_PROJECT}

                        npm install && npm run openshift
                        """
                    }
                } 
                */
            }
        }
        stage('Pushing to Test - maingateway') {
            environment {
                projectName = 'rh-test'
                imageNameSpace = 'rh-dev'
                srcTag = 'latest'
                destTag = 'promoteTest'
                serviceName = 'maingateway-service'
            }
            steps {
                echo "Deploy to ${projectName} "
                promoteServiceSetup(openShiftHost, openShiftToken, 'maingateway-service', params.IMAGENAMESPACE, env.destTag, params.TEST_PROJECT)    
                promoteService(params.IMAGENAMESPACE, params.TEST_PROJECT,'maingateway-service', env.srcTag, env.destTag)
            }
        }
        stage('Pushing to Test - fisuser') {
            environment {
                projectName = 'rh-test'
                imageNameSpace = 'rh-dev'
                srcTag = 'latest'
                destTag = 'promoteTest'
                serviceName = 'fisuser-service'
            }
            steps {
                echo "Deploy to ${projectName} "
                promoteServiceSetup(openShiftHost, openShiftToken, 'fisuser-service', params.IMAGENAMESPACE, env.destTag, params.TEST_PROJECT)    
                promoteService(params.IMAGENAMESPACE, params.TEST_PROJECT, 'fisuser-service', env.srcTag, env.destTag)
            }
        }
        stage('Pushing to Test - fisalert') {
            environment {
                projectName = 'rh-test'
                imageNameSpace = 'rh-dev'
                srcTag = 'latest'
                destTag = 'promoteTest'
                serviceName = 'fisalert-service'
            }
            steps {
                echo "Deploy to ${projectName} "
                promoteServiceSetup(openShiftHost, openShiftToken, 'fisalert-service', params.IMAGENAMESPACE, env.destTag, params.TEST_PROJECT)
                promoteService(params.IMAGENAMESPACE, params.TEST_PROJECT, 'fisalert-service', env.srcTag, env.destTag)
            }
        }
        stage('Pushing to Test - nodejsalert') {
            environment {
                projectName = 'rh-test'
                imageNameSpace = 'rh-dev'
                srcTag = 'latest'
                destTag = 'promoteTest'
                serviceName = 'nodejsalert-service'
            }
            steps {
                echo "Deploy to ${projectName} "
                promoteServiceSetup(openShiftHost, openShiftToken, 'nodejsalert-ui', params.IMAGENAMESPACE, env.destTag, params.TEST_PROJECT)
                promoteService(params.IMAGENAMESPACE, params.TEST_PROJECT, 'nodejsalert-ui', env.srcTag, env.destTag)
            }
        }
        stage('Confirm Pushing to Prod') {
            steps {
                 script {
                    timeout(time:2, unit: 'DAYS') {
                        def userInput = input(id: 'userInput', message: 'Approve to push to production?')
                    }
                }
            }
        }
        stage('Pushing to Prod - maingateway') {
            environment {
                projectName = 'rh-prod'
                imageNameSpace = 'rh-dev'
                srcTag = 'latest'
                destTag = 'promoteProd'
                serviceName = 'maingateway-service'
            }
            steps {
                echo 'Deploy to ${projectName} '
                
                promoteServiceSetup(openShiftHost, openShiftToken, env.serviceName, params.IMAGENAMESPACE, env.destTag, params.PROD_PROJECT)
                promoteService(params.IMAGENAMESPACE, params.PROD_PROJECT, env.serviceName,  env.srcTag, env.destTag)
            }
        }
        stage('Pushing to Prod - fisuser') {
            environment {
                projectName = 'rh-prod'
                imageNameSpace = 'rh-dev'
                srcTag = 'latest'
                destTag = 'promoteProd'
                serviceName = 'fisuser-service'
            }
            steps {
                echo "Deploy to ${projectName} "
                promoteServiceSetup(openShiftHost, openShiftToken, 'fisuser-service', params.IMAGENAMESPACE, env.destTag, params.PROD_PROJECT)
                promoteService(params.IMAGENAMESPACE, params.PROD_PROJECT, 'fisuser-service', env.srcTag, env.destTag)
            }
        }
        stage('Pushing to prod - fisalert') {
            environment {
                projectName = 'rh-prod'
                imageNameSpace = 'rh-dev'
                srcTag = 'latest'
                destTag = 'promoteProd'
                serviceName = 'fisalert-service'
            }
            steps {
                echo "Deploy to ${projectName} "
                promoteServiceSetup(openShiftHost, openShiftToken, 'fisalert-service', params.IMAGENAMESPACE, env.destTag, params.PROD_PROJECT)
                promoteService(params.IMAGENAMESPACE, params.PROD_PROJECT, 'fisalert-service', env.srcTag, env.destTag)
            }
        }
        stage('Pushing to prod - nodejsalert') {
          environment {
              projectName = 'rh-prod'
              imageNameSpace = 'rh-dev'
              srcTag = 'latest'
              destTag = 'promoteProd'
              serviceName = 'nodejsalert-service'
          }
          steps {
              echo "Deploy to ${projectName} "
              promoteServiceSetup(openShiftHost, openShiftToken, 'nodejsalert-ui', params.IMAGENAMESPACE, env.destTag, params.PROD_PROJECT)
              promoteService(params.IMAGENAMESPACE, params.PROD_PROJECT, 'nodejsalert-ui', env.srcTag, env.destTag)
          }
        }
    }
}

def promoteServiceSetup(openShiftHost, openShiftToken, svcName, imageNameSpace, tagName, projName) {
    sh """ 
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

    oc project ${projName} 

    mvn fabric8:deploy -Dmaven.test.skip=true -Dmysql-service-username=${mysqlUser} -Dmysql-service-password=${mysqlPwd}
    """
}
