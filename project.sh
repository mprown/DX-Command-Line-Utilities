#!/bin/bash
    function project() {
    # Check if any arguments are passed
    if [ "$#" = 0]; then
        echo "Error: Specify the project name as parameter"
        return 1
    fi
    # Create the new Salesforce DX project
    echo "Creating new project directory $1"
    sfdx force:project:create -n $1
    # Change to the directory of the project
    cd $1
    #create mdapi directory for files pulled from org
    mkdir mdapi
    #create mdapioutput directory to hold files to be pushed back
    #back to sandbox
    mkdir mdapioutput
    #create directory for tests
    mkdir tests
    #check for second param
    if [-z $2]; then
        echo 'Error: Specify default username'
        return 1
    fi
    # set default username
    sfdx force:config:set defaultusername=$2
    
    }

    ##deployment function
    function deploy() {
        ##convert force-app to mdapioutput
        sfdx force:source:convert -r ./force-app -d ./mdapioutput
        ##Check for arguments
        if ["$#"=0]; then
            echo "Error: Specify the sandbox name as parameter"
        return 1
        fi
        ##call sfdx to deploy
        sfdx force:mdapi:deploy -d ./mdapioutput -w 3 -u $1
        
    }