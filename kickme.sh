#!/usr/bin/env sh

echo "Alive'n'kickin'" > /kicked.txt

# Eventually comment rax-kick cronjob out, to disable it
cat /etc/cron.d/kickme | sed "s/^/#/g" > /etc/cron.d/kickme

exit 0
