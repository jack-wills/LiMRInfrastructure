package org.limr.lambdas.getsensordatalambda;

public class RequestClass {
    private String sensorID;
    private String sensorNetworkID;

	public String getSensorID() {
		return this.sensorID;
	}

	public void setSensorID(String sensorID) {
		this.sensorID = sensorID;
	}

	public String getSensorNetworkID() {
		return this.sensorNetworkID;
	}

	public void setSensorNetworkID(String sensorNetworkID) {
		this.sensorNetworkID = sensorNetworkID;
	}
}