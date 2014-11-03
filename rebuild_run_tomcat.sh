#mvn clean generate-resources process-resources -DserverName=local -Djdbc.db=amp-210-dev-tc7 -Djdbc.user=amp -Djdbc.password=amp -Djdbc.port=5433
echo "unmounting"
~/end-script.sh 
sleep 2
echo "double unmounting"
sudo umount /home/thadk/gitrepos/amp/TEMPLATE

sleep 2
echo "wipe & checkout latest code"
cd ~/Downloads/apache-tomcat-7.0.55/webapps/ROOT/
git reset --hard && git svn rebase

sleep 2

mvn clean generate-resources process-resources -DserverName=local -Djdbc.db=amp-timor-210-stg-tc7 -Djdbc.user=amp -Djdbc.password=amp -Djdbc.port=5433

sleep 2
#run monetdb and mount
~/start-script.sh


sleep 2

cd ~/Downloads/apache-tomcat-7.0.55/
export CATALINA_OPTS="-Damp.disableMemCheck=true -Dorg.apache.jasper.compiler.Parser.STRICT_QUOTE_ESCAPING=false -Djava.awWHITESPACE=false  -Djava.awt.headless=true -XX:PermSize=1512m -Xms1512M -Xmx2048M"
./bin/catalina.sh run

echo ThadScript:now unmounting
~/end-script.sh