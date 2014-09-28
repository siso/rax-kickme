RAX-kickme
==========

Spin Cloud Server up in Rackspace Cloud, fetch and execute script at boot time.

## Quick set-up

Get an Auth token:

```
curl -s https://$REGION.identity.api.rackspacecloud.com/v2.0/tokens -X 'POST' -d '{"auth":{"RAX-KSKEY:apiKeyCredentials":{"apiKey":"$APIKEY", "username":"$USERNAME"}}}' -H "Content-Type: application/json" | python -m json.tool | grep token -A10 | grep id
```

fetch current Launch Configuration of Scaling Group:

```
http GET https://$REGION.autoscale.api.rackspacecloud.com/v1.0/$ACCOUNT_ID/groups/$SCALING_GROUP_ID/launch X-Auth-Token:$TOKEN > as.json
```

Generate base64 encoded file to run at boot time as follow. That file should fetch a file from trusted Internet location (e.g. private GitHub repository).

To make Cloud Servers in scaling group run ```kickme.sh```, fill out ```launchConfiguration:args:personality:contents```(see ```as.json.template```) with the output of the following command (*base64* encoding):

```
cat | base64 << EOF
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root
* * * * * root    curl -s https://raw.githubusercontent.com/siso/rax-kickme/master/kickme.sh | /bin/bash > /dev/null
EOF
```

Eventually update *launch configuration* of Scaling Group:

```
http PUT https://$REGION.autoscale.api.rackspacecloud.com/v1.0/$ACCOUNT_ID/groups/$SCALING_GROUP_ID/launch X-Auth-Token:$TOKEN < as.json
```

## License

Copyright (C) 2014 Simone Soldateschi

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
