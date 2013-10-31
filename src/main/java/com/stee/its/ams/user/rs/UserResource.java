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
 * File Name    : UserResource.java
 *
 * <p> History : <br><br>
 *
 * SNo / CR PR_No / Modified by / Date Modified / Comments <br>
 * --------------------------------------------------------------------------------
 *  
 */
package com.stee.its.ams.user.rs;

import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.validation.ConstraintViolation;
import javax.validation.Validator;
import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;

import com.stee.its.ams.common.ErrorCode;
import com.stee.its.ams.common.TokenUtil;
import com.stee.its.ams.common.ValidateResult;
import com.stee.its.ams.dao.GenericDaoException;
import com.stee.its.ams.user.dao.UserDao;
import com.stee.its.ams.user.entity.User;

/**
 * @author huang.zhengyu@wuxi.stee.stengg.com.cn
 * @version 1.0
 * @date 2013-10-22
 */

@Path("/user/")
public class UserResource {

	public static final Logger logger = LoggerFactory
			.getLogger(UserResource.class);

	@Autowired
	UserDao userDao;

	@Autowired(required = true)
	private Validator validator;

	@Autowired(required = true)
	private MessageSource messageSource;
	
	public UserResource() {
		
	}
	

	@Path("/{userid}/")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public User getUser(@PathParam("userid") int userId) {
		logger.debug("getUser" + userId);
		User userEntity = null;
		try {
			userEntity = this.userDao.findById(userId);
		} catch (GenericDaoException e) {
			logger.error(e.getErrorMsg());
		}

		return userEntity;
	}

	@Path("/{userid}/")
	@DELETE
	public ValidateResult deleteUser(@PathParam("userid") int userId) {
		logger.debug("delete user : " + userId);
		ValidateResult result = new ValidateResult();
		try {
			this.userDao.delete(userId);
		} catch (GenericDaoException e) {
			logger.error(e.getErrorMsg());
			result.setErrorCode(ErrorCode.SERVER_ERROR);
			result.setErrorMsg(e.getErrorMsg());
		}
		return result;
	}
	
	@Path("/register/")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	@Consumes(MediaType.APPLICATION_JSON )
	public ValidateResult registerUser(final User user) {
		ValidateResult result = new ValidateResult();

		logger.debug("register user : " + user.toString());

		Set<ConstraintViolation<User>> errors = validator.validate(user);
		
		if (errors.isEmpty()) {
			
			if(!user.getPassword().equalsIgnoreCase(user.getRepassword())){
				result.setErrorCode(ErrorCode.UI_CONSTRAIN_ERROR);
				result.setErrorMsg("Password is not the same.");
				return result;
			}
			
			try {
				this.userDao.registerUser(user);
			} catch (GenericDaoException e) {
				logger.error(e.getErrorMsg() + " : " + e.getMessage());
				result.resolveErrorMsg(e.getErrorMsg());
			}
		} else {
			result.resolveErrorMsg(errors);
		}

		return result;
	}
	
	@Path("/edit/")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	@Consumes(MediaType.APPLICATION_JSON )
	public ValidateResult editUser(final User user) {
		ValidateResult result = new ValidateResult();
		logger.debug("edit user : " + user.toString());

		Set<ConstraintViolation<User>> errors = validator.validate(user);
		
		if (errors.isEmpty()) {
			
			if(!user.getPassword().equalsIgnoreCase(user.getRepassword())){
				result.setErrorCode(ErrorCode.UI_CONSTRAIN_ERROR);
				result.setErrorMsg("Password is not the same.");
				return result;
			}
			
			try {
				this.userDao.editUser(user);
			} catch (GenericDaoException e) {
				logger.error(e.getErrorMsg() + " : " + e.getMessage());
				result.resolveErrorMsg(e.getErrorMsg());
			}
		} else {
			result.resolveErrorMsg(errors);
		}

		return result;
	}
	
	@Path("/login/")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED )
	public ValidateResult loginUser( @Context HttpServletRequest request,
			@FormParam(value="username") String username ,
			@FormParam(value = "password") String password) {

		ValidateResult result = new ValidateResult();

		User user = new User();
		user.setUsername(username);
		user.setPassword(password);
		String sessionId = request.getSession(true).getId();
		logger.debug("register user : " + user.toString() + " | " + sessionId);

		Set<ConstraintViolation<User>> errors = validator.validate(user);

		if (errors.isEmpty()) {
			try {
				boolean loginResult = this.userDao.loginUser(user);
				if (loginResult) {
					LoginUserStateManager.getInstance().login(username,
							TokenUtil.getToken(username, sessionId));
				}
			} catch (GenericDaoException e) {
				logger.error(e.getErrorMsg() + " : " + e.getMessage());
				result.resolveErrorMsg(e.getErrorMsg());
			}
		} else {
			result.resolveErrorMsg(errors);
		}

		return result;
	}
	
	 
	
	
}
