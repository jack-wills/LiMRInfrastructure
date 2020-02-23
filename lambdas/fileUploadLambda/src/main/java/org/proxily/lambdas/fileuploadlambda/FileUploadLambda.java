package org.proxily.lambdas.fileuploadlambda;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.LambdaLogger;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.S3Event;
import com.amazonaws.services.s3.event.S3EventNotification.S3EventNotificationRecord;

import org.json.JSONException;
import org.json.JSONObject;

import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClient;
import com.amazonaws.services.dynamodbv2.model.AttributeValue;
import com.amazonaws.services.dynamodbv2.model.GetItemRequest;
import com.amazonaws.services.dynamodbv2.model.GetItemResult;
import com.amazonaws.services.sqs.AmazonSQSClient;
import com.amazonaws.services.sqs.model.SendMessageRequest;

import java.util.HashMap;
import java.util.Map;


public class FileUploadLambda implements RequestHandler<S3Event, Object> {
    private String tableName = System.getenv("TABLE_NAME");
    private String queueUrl = System.getenv("QUEUE_URL");

    public Object handleRequest(S3Event input, Context context) {
        LambdaLogger logger = context.getLogger();
        logger.log(input.toJson());
        for (S3EventNotificationRecord record : input.getRecords()) {
            String[] fileName = record.getS3().getObject().getKey().replace(".jpeg", "").split("_");
            String timestamp = fileName[2].replace("%3A",":");

            AmazonDynamoDBClient client = new AmazonDynamoDBClient();
            GetItemRequest request = new GetItemRequest();

            Map<String,AttributeValue> key = new HashMap<String,AttributeValue>();
            key.put("Timestamp", new AttributeValue(timestamp));
            request.setKey(key);
            request.setTableName(tableName);

            GetItemResult result = client.getItem(request);
            Map<String,AttributeValue> item = result.getItem();

            JSONObject itemJson;
            try {
                itemJson = new JSONObject();
            } catch (JSONException e) {
                return null;
            }
            itemJson.put("x", item.get("ImageX").getS());
            itemJson.put("y", item.get("ImageY").getS());
            itemJson.put("url", item.get("ImageURL").getS());
            itemJson.put("timestamp", timestamp);

            AmazonSQSClient sqsClient = new AmazonSQSClient();

            SendMessageRequest sendMessageRequest = new SendMessageRequest();
            sendMessageRequest.setMessageBody(itemJson.toString());
            sendMessageRequest.setQueueUrl(queueUrl);
            sqsClient.sendMessage(sendMessageRequest);
        }
        return null;
    }
}