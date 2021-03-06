echo "Install Dev Enviroment Softwares"
echo

#oc login -u system:admin
#oc project openshift
#oc create -f https://raw.githubusercontent.com/jboss-fuse/application-templates/master/fis-image-streams.json -n openshift
#oc import-image amq62-openshift --from=registry.access.redhat.com/jboss-amq-6/amq62-openshift -n openshift --confirm


echo "Create cicd demo project to work"
echo


oc login -u ahameed
oc new-project cicddev --display-name="Application Integration Demo" --description="Development Dev environment for Agile Integration"


echo "Setup the surrounding softwate and environment"
echo
echo "Start up MySQL for database access"
oc create -f https://raw.githubusercontent.com/openshift/origin/master/examples/db-templates/mysql-ephemeral-template.json
oc new-app --template=mysql-ephemeral --param=MYSQL_PASSWORD=password --param=MYSQL_USER=dbuser --param=MYSQL_DATABASE=sampledb

echo "Start up Broker for bitcoin gateway"
oc import-image amq62-openshift --from=registry.access.redhat.com/jboss-amq-6/amq62-openshift --confirm
oc create -f projecttemplates/amq62-openshift.json
oc new-app --template=amq62-basic --param=MQ_USERNAME=admin --param=MQ_PASSWORD=admin --param=IMAGE_STREAM_NAMESPACE=cicddev



