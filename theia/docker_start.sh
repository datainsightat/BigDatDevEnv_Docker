#!/bin/sh

# Theia
node /home/theia/src-gen/backend/main.js /home/project --hostname=0.0.0.0

#Keep Container alive
tail -f /dev/null