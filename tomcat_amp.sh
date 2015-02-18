#mvn clean generate-resources process-resources -DserverName=local -Djdbc.db=amp-210-dev-tc7 -Djdbc.user=amp -Djdbc.password=amp -Djdbc.port=5433

echo "make sure ROOT points to 2.11"
sleep 1
rm ~/Downloads/tomcat-env/webapps/ROOT
ln -s  /home/thadk/gitrepos/amp211 ~/Downloads/tomcat-env/webapps/ROOT


#where is this actually running? http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

#run monetdb and mount
"$DIR/start-script.sh"

monetdb stop amp-moldova-210-stg-tc7  
monetdb destroy -f amp-moldova-210-stg-tc7 
monetdb create amp-moldova-210-stg-tc7  
monetdb release amp-moldova-210-stg-tc7  

sleep 4

cd ~/Downloads/tomcat-env/
#cd ~/Downloads/tomcat-env/
export CATALINA_OPTS="-Damp.disableMemCheck=true -Dorg.apache.jasper.compiler.Parser.STRICT_QUOTE_ESCAPING=false -Djava.awWHITESPACE=false  -Djava.awt.headless=true -XX:PermSize=1512m -Xms1512M -Xmx2048M -Duser.country=US -Duser.language=en"
./bin/catalina.sh run

echo ThadScript:now unmounting
~/end-script.sh
