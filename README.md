# IntegrationApp Automation


## Demo Story

An integration application consisting of Multiple services working in combination (single front end with dispatch to two back-ends), one or more APIs that need to be managed via 3scale, and one or more messaging destinations/addresses used for event-driven inputs and outputs. Now want to automate deployment of this application across multiple environments, using pre-defined pipelines provided by the platform. The delivery pipelines must support environment-specific properties, testing, versioning, and the ability to rollback incomplete or failed deployments.

![alt text](images/outline.png "outline")




**Products and Projects**

    • OpenShift Container Platform
    • Red Hat 3scale API Management
    • Red Hat Fuse
    • MySQL Database
    • Red Hat AMQ
    • Node.js (RHOAR) Web Application
    • Jenkins for CICD


![alt text](images/image2.png "outline 2")



 Steps
 
     • Design an application using Fuse, AMQ, and 3Scale.
     • Source to Image (S2I) build and deploy apps on openshift environment.
     • Building a pipeline to support automated CI/CD
     • Expose a REST API using Camel, and export API doc to swagger.
     • Publish API on 3scale environment using CI/CD pipeline.
     • Manage the API through 3scale API management and update the application plan to rate-limit the application.
     • Design a web application that makes its calls through the 3scale API gateway.

## Application Environment

This demo contains below applications.

    • Gateway application https://github.com/redhatHameed/3ScaleFuseAMQ/tree/master/maingateway-service 
    • User Service application https://github.com/redhatHameed/3ScaleFuseAMQ/tree/master/fisuser-service
    • Alert Service Application https://github.com/redhatHameed/3ScaleFuseAMQ/tree/master/fisalert-service
    • Node.js Web application https://github.com/redhatHameed/3ScaleFuseAMQ/tree/master/nodejsalert-ui
    • 3scale (Openshift on-premises) environment

## Automation of Applications in OpenShift
### Build and deploy with pipelines
***The application works under [OpenShift](https://www.okd.io/) or [Minishift](https://www.okd.io/minishift/)***

The following instructions assuming that you are using Minshift. But the same could be applied to OpenShift cluster as well.

Download the source codes from git repository by either forking, or simply cloning it. 

```
git clone https://github.com/RHsyseng/IntegrationApp-Automation.git  
```
Start up your Minishift environment by running

```
minishift start
oc login -u developer
```

Setup `rh-dev`, `rh-test` and `rh-prod` Minishift projects as the target environment (you may skip this step if you already have the environment ready, and this script will first delete the original projects in Minishift and create the new ones).
    
```
./setup/setup.sh <Minishift userId>  #e.g. developer
```

Import the pipeline templates into your target project. For this case, it is `rh-dev`.

```
# switch to rh-dev project
oc project rh-dev

# import fisuser-service pipeline
oc new-app -f fisuser-service/src/main/resources/pipeline-app-build.yml -p IMAGE_REGISTRY=<Image name space>

# import maingateway-service pipeline
oc new-app -f maingateway-service/src/main/resources/pipeline-app-build.yml -p IMAGE_REGISTRY=<Image name space>

# import nodejsalert-ui pipeline
oc new-app -f nodejsalert-ui/resources/pipeline-app-build.yml -p IMAGE_REGISTRY=<Image name space>

# import fisalert-service pipeline
oc new-app -f fisalert-service/src/main/resources/pipeline-app-build.yml -p IMAGE_REGISTRY=<Image name space>

# import integration-master-pipeline
oc new-app -f pipelinetemplates/pipeline-aggregated-build.yml -p IMAGE_REGISTRY=<Image name space>

```

You can also customize the pipeline by changing the following parameters:

```
GIT_REPO             https://github.com/RHsyseng/IntegrationApp-Automation.git
GIT_BRANCH           master            #git branch where you want to build
OPENSHIFT_HOST       <leave it for now, will be used in future release>
OPENSHIFT_TOKEN      <leave it for now, will be used in future release>
MODULE_NAME          <module_name>     #the Java/Node.js module name for this template to build, use default would be fine.
DEV_PROJECT          rh-dev                
TEST_PROJECT         rh-test
PROD_PROJECT         rh-prod
MYSQL_USER           dbuser            #your DB user account
MYSQL_PWD            password          #DB user password
IMAGE_REGISTRY       172.30.1.1:5000   #image registry, usually is the one in your Minishift where you do the build
IMAGE_NAMESPACE      rh-dev            #the namespace where you push the image in Minishift

* If you have customized MYSQL_USER or MYSQL_PWD, please edit the nodejsalert-ui/config.js accordingly.
```
After you have imported all the pipeline templates, you should have them in your Minishift under `Builds`, `Pipelines`.

![Pipeline View](images/pipeline_import_view.png "Pipeline View")

Please start the pipeline from `maingateway-service-pipeline`, `fisuser-service-pipeline`, `fisalert-service-pipeline`, and then `nodejsalert-ui-pipeline`.

With `aggregated-pipeline`, you can build the entire application including all of the above modules mentioned. If you choose this pipeline, by default, it will build the entire application, but you will also be asked to select which individual module you want to bulid.  You will need to make your selection in your Jenkins console.

Once the build is finished, in your Minishift, go to `rh-test` or `rh-prod`, nevigate to `Applications`, `Routes` and click on nodejsalert-ui URL to launch the application.
You should see the application and it is started with web front-end like this: 

![Application View](images/application_launch_view.png "Application View")

