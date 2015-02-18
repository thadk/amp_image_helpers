#mvn clean generate-resources process-resources -DserverName=local -Djdbc.db=amp-210-dev-tc7 -Djdbc.user=amp -Djdbc.password=amp -Djdbc.port=5433
echo "make sure ROOT points to 2.10"
sleep 1
rm ~/Downloads/tomcat-env/webapps/ROOT
ln -s  /home/thadk/gitrepos/amp211 ~/Downloads/tomcat-env/webapps/ROOT

echo "unmounting"
~/end-script.sh
sleep 2
echo "double unmounting"
sudo umount /home/thadk/gitrepos/amp/TEMPLATE

echo "wipe & checkout latest code"
sleep 10
cd ~/Downloads/tomcat-env/webapps/ROOT/
git reset --hard && git svn rebase

sleep 2

mvn clean generate-resources process-resources -DserverName=local -Djdbc.db=amp-moldova-210-stg-tc7 -Djdbc.user=amp -Djdbc.password=amp -Djdbc.port=5433

sleep 2
#run monetdb and mount
~/start-script.sh


sleep 2

cd ~/Downloads/tomcat-env/
export CATALINA_OPTS="-Damp.disableMemCheck=true -Dorg.apache.jasper.compiler.Parser.STRICT_QUOTE_ESCAPING=false -Djava.awWHITESPACE=false  -Djava.awt.headless=true -XX:PermSize=1512m -Xms1512M -Xmx2048M"
./bin/catalina.sh run

echo ThadScript:now unmounting
~/end-script.sh
