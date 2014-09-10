rax-kickme
==========

Spin Cloud Server up in Rackspace Cloud, fetch and execute script

## Quick set-up

Get an Auth token:

```
curl -s https://$REGION.identity.api.rackspacecloud.com/v2.0/tokens -X 'POST' -d '{"auth":{"RAX-KSKEY:apiKeyCredentials":{"apiKey":"$APIKEY", "username":"$USERNAME"}}}' -H "Content-Type: application/json" | python -m json.tool | grep token -A10 | grep id
```

fetch current Launch Configuration of Scaling Group:

```
http GET https://$REGION.autoscale.api.rackspacecloud.com/v1.0/$ACCOUNT_ID/groups/$SCALING_GROUP_ID/launch X-Auth-Token:$TOKEN > as.json
```

Generate base64 encoded file to run at boot time as follow. That file should fetch a file from a trusted Internet location (e.g. private GitHub repository):

```
echo -n "* * * * * root    curl -s https://raw.githubusercontent.com/siso/rax-kickme/master/kickme.sh | /bin/bash > /dev/null" | base64
```

and use that output as value for the key ```launchConfiguration:args:personality:contents```, as exemplificated in ```as.json.template```.

