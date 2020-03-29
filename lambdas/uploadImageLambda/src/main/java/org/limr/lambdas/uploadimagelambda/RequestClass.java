package org.limr.lambdas.uploadimagelambda;

public class RequestClass {
    private String timestamp;
    private String imageX, imageY, imageZ, rotation;

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

	public String getImageZ() {
		return this.imageZ;
	}

	public void setImageZ(String imageZ) {
		this.imageZ = imageZ;
	}

	public String getRotation() {
		return this.rotation;
	}

	public void setRotation(String rotation) {
		this.rotation = rotation;
	}
}