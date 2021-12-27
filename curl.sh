curl -sSL -X GET -G "http://100.121.114.58:8081/service/rest/v1/search/assets" \
  -d repository=maven-snapshots \
  -d maven.groupId=semperti \
  -d maven.artifactId=my-journals \
  -d maven.baseVersion=1.0-SNAPSHOT \
  -d maven.extension=jar \
  -d maven.classifier=jar-with-dependencies \
  | grep -Po '"downloadUrl" : "\K.+(?=",)' \
  | xargs curl -fsSL -o journals-1.1.-SNAPSHOT.jar