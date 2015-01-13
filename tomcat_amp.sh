#mvn clean generate-resources process-resources -DserverName=local -Djdbc.db=amp-210-dev-tc7 -Djdbc.user=amp -Djdbc.password=amp -Djdbc.port=5433

#run monetdb and mount
~/start-script.sh

monetdb stop amp-moldova-210-stg-tc7  
monetdb destroy -f amp-moldova-210-stg-tc7 
monetdb create amp-moldova-210-stg-tc7  
monetdb release amp-moldova-210-stg-tc7  

sleep 4

#cd ~/Downloads/apache-tomcat-7.0.55/
cd ~/Downloads/tomcat-env/
export CATALINA_OPTS="-Damp.disableMemCheck=true -Dorg.apache.jasper.compiler.Parser.STRICT_QUOTE_ESCAPING=false -Djava.awWHITESPACE=false  -Djava.awt.headless=true -XX:PermSize=1512m -Xms1512M -Xmx2048M -Duser.country=US -Duser.language=en"
./bin/catalina.sh run

echo ThadScript:now unmounting
~/end-script.sh
