package org.limr.lambdas.uploadimagelambda;

import java.util.HashMap;
import java.util.Map;

import com.amazonaws.HttpMethod;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClient;
import com.amazonaws.services.dynamodbv2.model.AttributeValue;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.GeneratePresignedUrlRequest;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;

import java.util.Date;
import java.time.Instant;

public class UploadImageLambda implements RequestHandler<RequestClass, ResponseClass> {
    private String tableName = System.getenv("TABLE_NAME");

    public ResponseClass handleRequest(RequestClass input, Context context) {
        AmazonDynamoDBClient client = new AmazonDynamoDBClient();

        AmazonS3Client s3Client = new AmazonS3Client();

        GeneratePresignedUrlRequest s3RequestUpload =
            new GeneratePresignedUrlRequest(
                    "limr-image-us-east-1",
                    input.getImageX() + "_" + input.getImageY() + "_" + input.getImageZ() + "_" + input.getRotation() + "_" + input.getTimestamp() + ".jpeg")
                    .withExpiration(Date.from(Instant.now().plusSeconds(3600)))
                    .withMethod(HttpMethod.PUT);
        String uploadUrl = s3Client.generatePresignedUrl(s3RequestUpload).toString();

        GeneratePresignedUrlRequest s3RequestDownload =
            new GeneratePresignedUrlRequest(
                    "limr-image-us-east-1",
                    input.getImageX() + "_" + input.getImageY() + "_" + input.getImageZ() + "_" + input.getRotation() + "_" + input.getTimestamp() + ".jpeg")
                    .withExpiration(Date.from(Instant.now().plusSeconds(604800))) //7 days
                    .withMethod(HttpMethod.GET);
        String downloadUrl = s3Client.generatePresignedUrl(s3RequestDownload).toString();

        Map<String, AttributeValue> putItems = new HashMap<String,AttributeValue>();
        putItems.put("Timestamp", new AttributeValue(input.getTimestamp()));
        putItems.put("ImageURL", new AttributeValue(downloadUrl));
        putItems.put("ImageX", new AttributeValue(input.getImageX()));
        putItems.put("ImageY", new AttributeValue(input.getImageY()));
        putItems.put("ImageZ", new AttributeValue(input.getImageZ()));
        putItems.put("Rotation", new AttributeValue(input.getRotation()));

        client.putItem(tableName, putItems);
        ResponseClass response = new ResponseClass();
        response.setURL(uploadUrl);
        return response;
    }
}

