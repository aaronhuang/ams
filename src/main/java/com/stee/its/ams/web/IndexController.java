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
 * File Name    : IndexController.java
 *
 * <p> History : <br><br>
 *
 * SNo / CR PR_No / Modified by / Date Modified / Comments <br>
 * --------------------------------------------------------------------------------
 *  
 */
package com.stee.its.ams.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @author huang.zhengyu@wuxi.stee.stengg.com.cn
 * @version 1.0
 * @date 2013-10-23
 */

@Controller
public class IndexController {

	@RequestMapping("/index")
	public String getIndexPage() {
		// This will resolve to /WEB-INF/html/index.html
		return "index";
	}

	@RequestMapping("/register")
	public String getLoginPage() {
		// This will resolve to /WEB-INF/html/register.html
		return "register";
	}

}
