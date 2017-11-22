# JenkinsInDocker4


To fill plugins.txt, run the following on your Jenkins running in port 8080

```sh

curl "http://localhost:8080/pluginManager/api/json?depth=1" | jq -r '.plugins[].shortName'

```