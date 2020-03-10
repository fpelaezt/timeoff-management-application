#!/bin/bash

#Variables
environment="production"
branch="master"

echo "Welcome to the TIMEOFF Complete deploy script"
echo "This will deploy into the selected environment all the TIMEOFF Code"

#GIT CLONE and DEPLOY
rm -rf /tmp/deploy-timeoff /tmp/temp
echo "COMMAND: git clone -b $branch git@172.28.8.155:fernando.pelaez/timeoff-management-application.git /tmp/temp"
git clone -b $branch git@172.28.8.155:fernando.pelaez/timeoff-management-application.git /tmp/temp 2>&1 | tee git.log
if cat git.log | grep "fatal" ; then
    echo "DEBUG: Remote branch $branch not found in GIT server, exiting with errors"
    exit
else
    mv /tmp/temp /tmp/deploy-timeoff
    rm -rf /tmp/temp
    cd /tmp/deploy-timeoff/
    echo "DEBUG: Git clone sucessfull, deploying into $environment..."
    tar -cvf /tmp/deploy-timeoff/timeoff-management.tar *
    cd -
    echo "COMMAND: ansible-playbook -i hosts deploy-all-timeoff.yml"
    ansible-playbook -i hosts deploy-all-timeoff.yml
fi