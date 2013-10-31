/** Copyright (C) 2009, ST Electronics Info-Comm Systems PTE. LTD
 * All rights reserved.
 *
 * This software is confidential and proprietary property of 
 * ST Electronics Info-Comm Systems PTE. LTD.
 * The user shall not disclose the contents of this software and shall
 * only use it in accordance with the terms and conditions stated in
 * the contract or license agreement with ST Electronics Info-Comm Systems PTE. LTD.
 *
 * Project Name : ERS (Emergency Response System)
 * File Name    : LoginUserStateManager.java
 *
 * <p> History : <br><br>
 *
 * SNo / CR PR_No / Modified by / Date Modified / Comments <br>
 * --------------------------------------------------------------------------------
 *  
 */
package com.stee.its.ams.user.rs;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.stee.its.ams.user.entity.UserToken;

/**
 * @author huang.zhengyu@wuxi.stee.stengg.com.cn
 * @version 1.0
 * @date 2013-10-23
 */
public class LoginUserStateManager implements LoginUserStateInterface{
	
	private static final Logger logger = LoggerFactory.getLogger(LoginUserStateManager.class);
	
	private static LoginUserStateManager instance = new LoginUserStateManager();
	
	private Map<String, UserToken> map = new HashMap<String, UserToken>();
	
	private LoginUserStateManager() {
	    
	}
	
	public static LoginUserStateManager getInstance() {
	    return instance;
	}
	/**
	 * Successful or failed
	 * When user login, invoke this method.
	 * @param userId
	 * @param userToken
	 * @return
	 */
	synchronized public boolean login(String userId, UserToken userToken) {
	    boolean result = false;
	    if (this.map.get(userId.toLowerCase())==null) {
	        this.map.put(userId.toLowerCase(), userToken);
	        result = true;
	    } 
	    if (logger.isDebugEnabled()) {
	        logger.debug("The Logged user number is " + this.map.size());
	    }
	    return result;
	}
	
	/**
	 * When logout or be kick out, invoke this method.
	 * @param username
	 */
	synchronized public void logout(String userId) {
		if (this.map.get(userId.toLowerCase()) != null) {
			try {
				remove(userId);
			} catch (Exception e) {
				logger.error("Session for " + userId.toLowerCase()
						+ " has been invalidated.");
			}
		}
	}
	/**
	 * @param userId
	 */
	synchronized private void remove (String userId) {
	    if (logger.isDebugEnabled()) {
	        logger.debug("User, " + userId.toLowerCase() + ", is logged out");
	    }
	    this.map.remove(userId.toLowerCase());
	}
	
	/**
	 * Get the user token by userId(use email as userId)
	 * @param id
	 * @return
	 */
	synchronized public UserToken getToken(String userId) {
		return this.map.get(userId.toLowerCase());
	}
	/**
	 * Check if the sesion exist
	 * @param id
	 * @return
	 */
	synchronized public boolean isTokenExist(String userId) {
	    return this.map.containsKey(userId);
	}
	 
	synchronized public int getLoggedUserNumber() {
	    if (logger.isDebugEnabled()) {
	        logger.debug("Conrrent online user number is " + this.map.size());
	    }
	    return this.map.size();
	}

}