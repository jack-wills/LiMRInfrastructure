package org.limr.lambdas.getsensordatalambda;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClient;
import com.amazonaws.services.dynamodbv2.model.AttributeValue;
import com.amazonaws.services.dynamodbv2.model.GetItemRequest;
import com.amazonaws.services.dynamodbv2.model.BatchGetItemRequest;
import com.amazonaws.services.dynamodbv2.model.GetItemResult;
import com.amazonaws.services.dynamodbv2.model.KeysAndAttributes;
import com.amazonaws.services.dynamodbv2.model.QueryRequest;
import com.amazonaws.services.dynamodbv2.model.QueryResult;
import com.amazonaws.services.dynamodbv2.model.ScanRequest;
import com.amazonaws.services.dynamodbv2.model.ScanResult;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.LambdaLogger;
import com.amazonaws.services.lambda.runtime.RequestHandler;

import org.json.JSONObject;

public class GetSensorDataLambda implements RequestHandler<RequestClass, ResponseClass> {
    private String tableNamePrefix = System.getenv("TABLE_NAME");

    public ResponseClass handleRequest(RequestClass input, Context context) {
        LambdaLogger logger = context.getLogger();
        AmazonDynamoDBClient client = new AmazonDynamoDBClient();
        String tableName;
        if (input.getSensorNetworkID() == null) {
            tableName = tableNamePrefix + "0";
        } else {
            tableName = tableNamePrefix + input.getSensorNetworkID();
        }

        if (input.getSensorID() == null) {
            ScanRequest request = new ScanRequest();
            request.setTableName(tableName);

            JSONObject sensorValues = new JSONObject();
            List<Map<String,AttributeValue>> list = client.scan(request).getItems();
            for (Map<String,AttributeValue> item : list) {
                sensorValues.put(item.get("SensorID").getS(), item.get("SensorValue").getN());
            }
            
            ResponseClass response = new ResponseClass();
            response.setSensorValues(sensorValues.toString());
            return response;
        } else {
            BatchGetItemRequest request = new BatchGetItemRequest();
            Map<String,KeysAndAttributes> requestItems = new HashMap<String,KeysAndAttributes>();
            KeysAndAttributes readRequests = new KeysAndAttributes();
            String[] sensorIDs = input.getSensorID().split(",");
            Collection<Map<String,AttributeValue>> collection = new ArrayList<Map<String,AttributeValue>>();

            for (String sensorID : sensorIDs) {
                Map<String,AttributeValue> map = new HashMap<String,AttributeValue>();
                map.put("SensorID", new AttributeValue(sensorID));
                collection.add(map);
            }
            readRequests.setKeys(collection);
            requestItems.put(tableName, readRequests);

            JSONObject sensorValues = new JSONObject();
            
            List<Map<String,AttributeValue>> list = client.batchGetItem(request).getResponses().get(tableName);
            for (Map<String,AttributeValue> item : list) {
                sensorValues.put(item.get("SensorID").getS(), item.get("SensorValue").getN());
            }
            
            ResponseClass response = new ResponseClass();
            response.setSensorValues(sensorValues.toString());
            return response;
        }
    }
}

