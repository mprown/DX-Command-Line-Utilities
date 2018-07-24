#!/bin/bash
##deployment function
    deploy(){
        ##convert force-app to mdapioutput
        sfdx force:source:convert -r ./force-app -d ./mdapioutput
        ##Check for arguments
        SANDBOX=$1
        if [ -z "$1" ]; then
            echo "Error: Specify the sandbox name as parameter. Please enter the name of a sandbox:"
            read NAME 
            if [ -n "$NAME" ]; then
               SANDBOX=$NAME
            fi
        fi

        ##call sfdx to deploy
        sfdx force:mdapi:deploy -d ./mdapioutput -w 3 -u $SANDBOX
        
    }