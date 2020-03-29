package org.limr.lambdas.audiolambda;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClient;
import com.amazonaws.services.dynamodbv2.model.AttributeValue;
import com.amazonaws.services.dynamodbv2.model.BatchWriteItemRequest;
import com.amazonaws.services.dynamodbv2.model.PutRequest;
import com.amazonaws.services.dynamodbv2.model.GetItemRequest;
import com.amazonaws.services.dynamodbv2.model.GetItemResult;
import com.amazonaws.services.dynamodbv2.model.WriteRequest;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.LambdaLogger;
import com.amazonaws.services.lambda.runtime.RequestHandler;

import org.json.JSONException;
import org.json.JSONObject;


public class AudioLambda implements RequestHandler<RequestClass, ResponseClass> {
    private String tableName = System.getenv("TABLE_NAME");

    public ResponseClass handleRequest(RequestClass input, Context context) {
        LambdaLogger logger = context.getLogger();
        AmazonDynamoDBClient client = new AmazonDynamoDBClient();
        
        logger.log("Link ID = " + input.getLinkID());
        logger.log("IP = " + input.getip());
        logger.log("Port = " + Integer.toString(input.getPort()));
        if (input.isInvalid()) {
            GetItemRequest request = new GetItemRequest();
    
            Map<String,AttributeValue> key = new HashMap<String,AttributeValue>();
            key.put("LinkID", new AttributeValue(input.getLinkID()));
            request.setKey(key);
            request.setTableName(tableName);
    
            GetItemResult result = client.getItem(request);
            Map<String,AttributeValue> item = result.getItem();

            if (item != null && item.containsKey("Port") && item.containsKey("IP")) {
                if (Integer.parseInt(item.get("Port").getS()) == input.getPort() && item.get("IP").getS().equals(input.getip())) {
                    Map<String, AttributeValue> putItems = new HashMap<String,AttributeValue>();
                    putItems.put("LinkID", new AttributeValue(input.getLinkID()));
                    putItems.put("IP", new AttributeValue("0.0.0.0"));
                    putItems.put("Port", new AttributeValue("0"));
            
                    client.putItem(tableName, putItems);
                }
            }

            ResponseClass response = new ResponseClass();
            return response;
        }

        if (input.isSender()) {
            GetItemRequest request = new GetItemRequest();
    
            Map<String,AttributeValue> key = new HashMap<String,AttributeValue>();
            key.put("LinkID", new AttributeValue(input.getLinkID()));
            request.setKey(key);
            request.setTableName(tableName);
    
            GetItemResult result = client.getItem(request);
            Map<String,AttributeValue> item = result.getItem();
    
            ResponseClass response = new ResponseClass();
            if (item != null && item.containsKey("Port") && item.containsKey("IP")) {
                response.setPort(Integer.parseInt(item.get("Port").getS()));
                response.setip(item.get("IP").getS());
            } else {
                response.setPort(0);
                response.setip("0.0.0.0");
            }
            return response;
        } else {
            Map<String, AttributeValue> putItems = new HashMap<String,AttributeValue>();
            putItems.put("LinkID", new AttributeValue(input.getLinkID()));
            putItems.put("IP", new AttributeValue(input.getip()));
            putItems.put("Port", new AttributeValue(Integer.toString(input.getPort())));
    
            client.putItem(tableName, putItems);

            ResponseClass response = new ResponseClass();
            return response;
        }


    }
}

