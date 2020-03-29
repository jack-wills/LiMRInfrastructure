package org.limr.lambdas.audiolambda;

public class RequestClass {
    private String linkID;
    private boolean sender;
    private boolean invalid = false;
	private int port;
	private String ip;

	public String getLinkID() {
		return this.linkID;
	}

	public void setLinkID(String linkID) {
		this.linkID = linkID;
	}

	public boolean isSender() {
		return this.sender;
	}

	public void setSender(boolean sender) {
		this.sender = sender;
	}

	public boolean isInvalid() {
		return this.invalid;
	}

	public void setInvalid(boolean invalid) {
		this.invalid = invalid;
	}

	public int getPort() {
		return this.port;
	}

	public void setPort(int port) {
		this.port = port;
	}

	public String getip() {
		return this.ip;
	}

	public void setip(String ip) {
		this.ip = ip;
	}
}