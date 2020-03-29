#!/bin/bash
if [ $# -ne 0 ]; then
    if [ $1 = "lambda" ]; then
        cd lambdas

        cd audioLambda
        printf '\n\nBuilding Audio Lambda\n\n'
        mvn clean verify
        if [ $? -ne 0 ]; then
            printf '\n\n Audio Lambda build failed!\n\n'
            exit -1
        fi

        cd ..

        cd uploadImageLambda
        printf '\n\nBuilding UploadImage Lambda\n\n'
        mvn clean verify
        if [ $? -ne 0 ]; then
            printf '\n\n UploadImage Lambda build failed!\n\n'
            exit -1
        fi

        cd ..

        cd putSensorDataLambda
        printf '\n\nBuilding PutSensorData Lambda\n\n'
        mvn clean verify
        if [ $? -ne 0 ]; then
            printf '\n\n PutSensorData Lambda build failed!\n\n'
            exit -1
        fi

        cd ..

        cd getSensorDataLambda
        printf '\n\nBuilding GetSensorData Lambda\n\n'
        mvn clean verify
        if [ $? -ne 0 ]; then
            printf '\n\n GetSensorData Lambda build failed!\n\n'
            exit -1
        fi

        cd ..

        cd fileUploadLambda
        printf '\n\nBuilding FileUpload Lambda\n\n'
        mvn clean verify
        if [ $? -ne 0 ]; then
            printf '\n\n FileUpload Lambda build failed!\n\n'
            exit -1
        fi

        cd ../..
    fi
fi
printf '\n\nStarting Terraform!\n\n'
cd Terraform
terraform plan -out=plan.out
terraform apply plan.out