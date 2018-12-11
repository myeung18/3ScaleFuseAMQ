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
    stages {
        stage ("source") {
            steps {
                git 'https://github.com/myeung18/3ScaleFuseAMQ'
            }
        }
        stage('Wait for user to select module to build.') {
            steps {
                script {
                    env.userSelModule = input(id: 'userInput', message: 'Please select which module to bulid?',
                    parameters: [[$class: 'ChoiceParameterDefinition', defaultValue: 'strDef', 
                       description:'describing choices', name:'nameChoice', choices: "Gateway\nFisUser\nFisAlert\nUI\nAll"]
                    ])
        
                    println("user selected module " + env.userSelModule);
                }
            }
        }
        stage('Build maingateway-service') {
            environment { 
                serviceName = 'maingateway-service'
            }
            when {
                expression {
                    env.userInput == 'Gateway' || env.userInput == 'All'
                }
            }
            steps {
                echo "Building.. ${serviceName} "
                //build(env.serviceName)

                echo "Deploying ${serviceName} to ${CICD_PROJECT}"
                //deploy(env.serviceName, params.CICD_PROJECT, params.OPENSHIFT_URL, params.OPENSHIFT_TOKEN, params.MYSQL_USER, params.MYSQL_PWD)

            }
        }
        stage('Build fisuser-service') {
            environment { 
                serviceName = 'fisuser-service'
            }
            when {
                expression {
                    env.userSelModule == 'FisUser' || env.userSelModule == 'All'
                }
            }
            steps {
                echo "Building.. ${serviceName} "
                //build(env.serviceName)

                echo "Deploying ${serviceName} to ${CICD_PROJECT}"
                //deploy(env.serviceName, params.CICD_PROJECT, params.OPENSHIFT_URL, params.OPENSHIFT_TOKEN, params.MYSQL_USER, params.MYSQL_PWD)
           }
        }
        stage('Build fisalert-service') {
            environment { 
                serviceName = 'fisalert-service'
            }
            when {
                expression {
                    env.userSelModule == 'FisAlert' || env.userSelModule == 'All'
                }
            }
            steps {
                echo "Building.. ${serviceName} "
                //build(env.serviceName)

                echo "Deploying ${serviceName} to ${CICD_PROJECT}"
                //deploy(env.serviceName, params.CICD_PROJECT, params.OPENSHIFT_URL, params.OPENSHIFT_TOKEN, params.MYSQL_USER, params.MYSQL_PWD)
            }
        }
        stage('Build nodejsalert-ui') {
            environment { 
                serviceName = 'nodejsalert-ui'
            }
            when {
                expression {
                    env.userSelModule == 'UI' || env.userSelModule == 'All'
                }
            }
            steps {
                echo "Building.. ${serviceName}"
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
                srcTag = 'latest'
                destTag = 'promoteTest'
                serviceName = 'maingateway-service'
            }
            steps {
                echo "Deploy to ${TEST_PROJECT} "
                promoteServiceSetup(params.OPENSHIFT_URL, params.OPENSHIFT_TOKEN, 'maingateway-service', params.IMAGENAMESPACE, env.destTag, params.TEST_PROJECT)    
                promoteService(params.IMAGENAMESPACE, params.TEST_PROJECT,'maingateway-service', env.srcTag, env.destTag)
            }
        }
        stage('Pushing to Test - fisuser') {
            environment {
                srcTag = 'latest'
                destTag = 'promoteTest'
                serviceName = 'fisuser-service'
            }
            steps {
                echo "Deploy to ${TEST_PROJECT} "
                promoteServiceSetup(params.OPENSHIFT_URL, params.OPENSHIFT_TOKEN, 'fisuser-service', params.IMAGENAMESPACE, env.destTag, params.TEST_PROJECT)    
                promoteService(params.IMAGENAMESPACE, params.TEST_PROJECT, 'fisuser-service', env.srcTag, env.destTag)
            }
        }
        stage('Pushing to Test - fisalert') {
            environment {
                srcTag = 'latest'
                destTag = 'promoteTest'
                serviceName = 'fisalert-service'
            }
            steps {
                echo "Deploy to ${TEST_PROJECT} "
                promoteServiceSetup(params.OPENSHIFT_URL, params.OPENSHIFT_TOKEN, 'fisalert-service', params.IMAGENAMESPACE, env.destTag, params.TEST_PROJECT)
                promoteService(params.IMAGENAMESPACE, params.TEST_PROJECT, 'fisalert-service', env.srcTag, env.destTag)
            }
        }
        stage('Pushing to Test - nodejsalert') {
            environment {
                srcTag = 'latest'
                destTag = 'promoteTest'
                serviceName = 'nodejsalert-service'
            }
            steps {
                echo "Deploy to ${TEST_PROJECT} "
                promoteServiceSetup(params.OPENSHIFT_URL, params.OPENSHIFT_TOKEN, 'nodejsalert-ui', params.IMAGENAMESPACE, env.destTag, params.TEST_PROJECT)
                promoteService(params.IMAGENAMESPACE, params.TEST_PROJECT, 'nodejsalert-ui', env.srcTag, env.destTag)
            }
        }
        stage('Wait for user to select module to push to production.') {
            steps {
                script {
                    env.userSelModule = input(id: 'userInput', message: 'Please select module to push to production?',
                    parameters: [[$class: 'ChoiceParameterDefinition', defaultValue: 'strDef', 
                       description:'describing choices', name:'nameChoice', choices: "Gateway\nFisUser\nFisAlert\nUI\nAll"]
                    ])
        
                    println("user selected module " + env.userSelModule);
                }
            }
        }
        stage('Pushing to Prod - maingateway') {
            environment {
                srcTag = 'latest'
                destTag = 'promoteProd'
                serviceName = 'maingateway-service'
            }
            when {
                expression {
                    env.userselmodule == 'Gateway' || env.userselmodule == 'All'
                }
            }
            steps {
                echo 'Deploy to ${PROD_PROJECT} '
                
                promoteServiceSetup(params.OPENSHIFT_URL, params.OPENSHIFT_TOKEN, env.serviceName, params.IMAGENAMESPACE, env.destTag, params.PROD_PROJECT)
                promoteService(params.IMAGENAMESPACE, params.PROD_PROJECT, env.serviceName,  env.srcTag, env.destTag)
            }
        }
        stage('Pushing to Prod - fisuser') {
            environment {
                srcTag = 'latest'
                destTag = 'promoteProd'
                serviceName = 'fisuser-service'
            }
            when {
                expression {
                    env.userselmodule == 'fisuser' || env.userselmodule == 'All'
                }
            }
            steps {
                echo "Deploy to ${PROD_PROJECT} "
                promoteServiceSetup(params.OPENSHIFT_URL, params.OPENSHIFT_TOKEN, 'fisuser-service', params.IMAGENAMESPACE, env.destTag, params.PROD_PROJECT)
                promoteService(params.IMAGENAMESPACE, params.PROD_PROJECT, 'fisuser-service', env.srcTag, env.destTag)
            }
        }
        stage('Pushing to prod - fisalert') {
            environment {
                srcTag = 'latest'
                destTag = 'promoteProd'
                serviceName = 'fisalert-service'
            }
            when {
                expression {
                    env.userSelModule == 'FisAlert' || env.userSelModule == 'All'
                }
            }
            steps {
                echo "Deploy to ${PROD_PROJECT} "
                promoteServiceSetup(params.OPENSHIFT_URL, params.OPENSHIFT_TOKEN, 'fisalert-service', params.IMAGENAMESPACE, env.destTag, params.PROD_PROJECT)
                promoteService(params.IMAGENAMESPACE, params.PROD_PROJECT, 'fisalert-service', env.srcTag, env.destTag)
            }
        }
        stage('Pushing to prod - nodejsalert') {
            environment {
              srcTag = 'latest'
              destTag = 'promoteProd'
              serviceName = 'nodejsalert-service'
            }
            when {
                expression {
                    env.userselmodule == 'UI' || env.userselmodule == 'All'
                }
            }
            steps {
                echo "Deploy to ${PROD_PROJECT} "
                promoteServiceSetup(params.OPENSHIFT_URL, params.OPENSHIFT_TOKEN, 'nodejsalert-ui', params.IMAGENAMESPACE, env.destTag, params.PROD_PROJECT)
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
