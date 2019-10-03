#!/bin/bash
if [ $# -ne 0 ]; then
    if [ $1 = "lambda" ]; then
        cd lambdas

        cd putSensorDataLambda
        printf '\n\nBuilding PutSensorData Lambda\n\n'
        mvn clean verify
        if [ $? -ne 0 ]; then
            printf '\n\n PutSensorData Lambda build faild!\n\n'
            exit -1
        fi

        cd ..

        cd getSensorDataLambda
        printf '\n\nBuilding GetSensorData Lambda\n\n'
        mvn clean verify
        if [ $? -ne 0 ]; then
            printf '\n\n GetSensorData Lambda build faild!\n\n'
            exit -1
        fi

        cd ../..
    fi
fi
printf '\n\nStarting Terraform!\n\n'
cd Terraform
terraform plan -out=plan.out
terraform apply plan.out