package org.limr.lambdas.putsensordatalambda;

public class RequestClass {
    private String timestamp;
    private String sensorValues;
    private String sensorNetworkID;

	public String getTimestamp() {
		return this.timestamp;
	}

	public void setTimestamp(String timestamp) {
		this.timestamp = timestamp;
	}

	public String getSensorValues() {
		return this.sensorValues;
	}

	public void setSensorValues(String sensorValues) {
		this.sensorValues = sensorValues;
	}

	public String getSensorNetworkID() {
		return this.sensorNetworkID;
	}

	public void setSensorNetworkID(String sensorNetworkID) {
		this.sensorNetworkID = sensorNetworkID;
	}
}