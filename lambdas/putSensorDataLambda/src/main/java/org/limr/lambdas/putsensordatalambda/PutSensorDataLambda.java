package org.limr.lambdas.putsensordatalambda;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClient;
import com.amazonaws.services.dynamodbv2.model.AttributeValue;
import com.amazonaws.services.dynamodbv2.model.BatchWriteItemRequest;
import com.amazonaws.services.dynamodbv2.model.GetItemRequest;
import com.amazonaws.services.dynamodbv2.model.GetItemResult;
import com.amazonaws.services.dynamodbv2.model.PutItemRequest;
import com.amazonaws.services.dynamodbv2.model.PutRequest;
import com.amazonaws.services.dynamodbv2.model.QueryRequest;
import com.amazonaws.services.dynamodbv2.model.QueryResult;
import com.amazonaws.services.dynamodbv2.model.WriteRequest;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.LambdaLogger;
import com.amazonaws.services.lambda.runtime.RequestHandler;

import org.json.JSONException;
import org.json.JSONObject;


public class PutSensorDataLambda implements RequestHandler<RequestClass, ResponseClass> {
    private String tableName = System.getenv("TABLE_NAME");

    public ResponseClass handleRequest(RequestClass input, Context context) {
        LambdaLogger logger = context.getLogger();
        AmazonDynamoDBClient client = new AmazonDynamoDBClient();

        JSONObject sensorValues;
        try {
            sensorValues = new JSONObject(input.getSensorValues());
        } catch (JSONException e) {
            return null;
        }

        BatchWriteItemRequest request = new BatchWriteItemRequest();
        Map<String,List<WriteRequest>> requestItems = new HashMap<String,List<WriteRequest>>();
        List<WriteRequest> writeRequests = new LinkedList<WriteRequest>();
        
        StringBuilder logString = new StringBuilder();
        logString.append(input.getTimestamp() + ": ");
        String[] keySet = JSONObject.getNames(sensorValues);
        for (String key : keySet) {
            WriteRequest writeRequest = new WriteRequest();
            PutRequest putRequest = new PutRequest();
            putRequest.addItemEntry("Timestamp", new AttributeValue(input.getTimestamp()));
            putRequest.addItemEntry("SensorID", new AttributeValue(key));
            AttributeValue value = new AttributeValue();
            value.setN(sensorValues.getString(key));
            putRequest.addItemEntry("SensorValue", value);
            writeRequest.setPutRequest(putRequest);
            writeRequests.add(writeRequest);
            logString.append(key);
            logString.append("=");
            logString.append(value.getN());
            logString.append(", ");
        }
        logger.log(logString.toString());

        if (input.getSensorNetworkID() == null) {
            requestItems.put(tableName + "0", writeRequests);
        } else {
            requestItems.put(tableName + input.getSensorNetworkID(), writeRequests);
        }

        request.setRequestItems(requestItems);

        client.batchWriteItem(request);
        ResponseClass response = new ResponseClass();
        response.isActive(false);
        return response;
    }
}

