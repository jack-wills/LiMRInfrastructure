package org.limr.lambdas.uploadimagelambda;

public class RequestClass {
    private String timestamp;
    private String imageX;
    private String imageY;

	public String getTimestamp() {
		return this.timestamp;
	}

	public void setTimestamp(String timestamp) {
		this.timestamp = timestamp;
	}

	public String getImageX() {
		return this.imageX;
	}

	public void setImageX(String imageX) {
		this.imageX = imageX;
	}

	public String getImageY() {
		return this.imageY;
	}

	public void setImageY(String imageY) {
		this.imageY = imageY;
	}
}