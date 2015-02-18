#mvn clean generate-resources process-resources -DserverName=local -Djdbc.db=amp-210-dev-tc7 -Djdbc.user=amp -Djdbc.password=amp -Djdbc.port=5433

#http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

monetdbd start /developer/amp/monet-storage

echo "make sure ROOT points to 2.11"
sleep 1
rm ~/Downloads/tomcat-env/webapps/ROOT
ln -s  /home/thadk/gitrepos/amp211 ~/Downloads/tomcat-env/webapps/ROOT

echo "unmounting"
./end-script.sh
sleep 2
echo "double unmounting"
sudo umount /home/thadk/gitrepos/amp211/TEMPLATE
sudo umount /home/thadk/gitrepos/amp/TEMPLATE

sleep 5
echo "wipe & checkout latest code"
cd ~/Downloads/tomcat-env/webapps/ROOT/
git reset --hard && git svn rebase

sleep 2

mvn clean generate-resources process-resources -DserverName=local -Djdbc.db=amp-moldova-210-stg-tc7 -Djdbc.user=amp -Djdbc.password=amp -Djdbc.port=5433

#./rebuild_run_tomcat211.sh: line 37: /home/thadk/gitrepos/amp211/start-script.sh: No such file or directory


sleep 2
#run monetdb and mount
$DIR/start-script.sh
echo $DIR/start-script.sh


sleep 2

cd ~/Downloads/tomcat-env/
export CATALINA_OPTS="-Damp.disableMemCheck=true -Dorg.apache.jasper.compiler.Parser.STRICT_QUOTE_ESCAPING=false -Djava.awWHITESPACE=false  -Djava.awt.headless=true -XX:PermSize=1512m -Xms1512M -Xmx2048M"
./bin/catalina.sh run

echo ThadScript:now unmounting
~/end-script.sh
