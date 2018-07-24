#!/bin/bash
    project(){
    # Check if any arguments are passed
    if [ -z "$1" ]; then
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
    if [ -z "$2" ]; then
        echo 'Error: Specify default username'
        return 1
    fi
    # set default username
    sfdx force:config:set defaultusername=$2

    #open vscode
    code . -n
    }

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
##retrieval function
    retrieve(){
        
        ##Check for arguments
        SANDBOX=$1
        if [ -z "$1" ]; then
            echo "Error: Specify the sandbox name as parameter. Please enter the name of a sandbox:"
            read NAME 
            if [ -n "$NAME" ]; then
               SANDBOX=$NAME
            fi
        fi
        PACKAGENAME=$
        if [ -z "$2" ]; then
            echo "Error: Specify the package name as parameter. Please enter the name of a package:"
            read NAME 
            if [ -n "$NAME" ]; then
               PACKAGE=$NAME
            fi
        fi
        ## retrieve package using mdapi
        sfdx force:mdapi:retrieve -u $SANDBOX -p $PACKAGE -r ./mdapi
        ## unzip package file
        unzip ./mdapi/unpackaged.zip -d ./mdapi
        ## convert into source
        sfdx force:mdapi:convert -r ./mdapi -d ./force-app
    }
##test function
    testecho(){
        echo $1
    }

    
export project
export testecho