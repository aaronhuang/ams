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
 * File Name    : TokenUtil.java
 *
 * <p> History : <br><br>
 *
 * SNo / CR PR_No / Modified by / Date Modified / Comments <br>
 * --------------------------------------------------------------------------------
 *  
 */
package com.stee.its.ams.common;

import com.stee.its.ams.user.entity.UserToken;

/**
 * @author huang.zhengyu@wuxi.stee.stengg.com.cn
 * @version 1.0
 * @date 2013-10-23
 */
public class TokenUtil {
	
	public final static UserToken getToken(String userId, String source) {
		UserToken token = new UserToken();
		token.setUserId(userId);
		if (source == null) {
			source = "";
		}
		String result = "";
		result = EncryptUtils.encryptMD5(source);
		token.setToken(result);
		return token;
	}
	
}
