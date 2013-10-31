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
 * File Name    : UserDaoImpl.java
 *
 * <p> History : <br><br>
 *
 * SNo / CR PR_No / Modified by / Date Modified / Comments <br>
 * --------------------------------------------------------------------------------
 *  
 */
package com.stee.its.ams.user.dao;

import java.util.List;

import javax.persistence.Query;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.stee.its.ams.common.Constants;
import com.stee.its.ams.common.EncryptUtils;
import com.stee.its.ams.dao.BaseJpaDaoSupport;
import com.stee.its.ams.dao.GenericDaoException;
import com.stee.its.ams.user.entity.User;


/**
 * @author huang.zhengyu@wuxi.stee.stengg.com.cn
 * @version 1.0
 * @date 2013-10-22
 */

@Repository(value="UserDaoImpl")
@Transactional(readOnly = true)
public class UserDaoImpl extends BaseJpaDaoSupport<Integer, User> implements UserDao {
	
	public static final Logger logger = LoggerFactory.getLogger(UserDaoImpl.class);
	
	public List<User> getList() {
		List<User> result = (List<User>) this.getEm().createNamedQuery(
				"User.findAll").getResultList();
		logger.info("getUserList size" + result.size());
		
		for(User user : result) {
			user.setPassword(Constants.PASSWORD);
			user.setRepassword(Constants.PASSWORD);
		}
		return result;
	}
	
	@Transactional(readOnly = false , propagation = Propagation.REQUIRES_NEW)
	public boolean registerUser(User user) throws GenericDaoException {
		validateUser(user);
		String encryptedPass = EncryptUtils.encryptMD5(user.getPassword());
		user.setPassword(encryptedPass);
		user.setRepassword(encryptedPass);
		this.add(user);
		return true;
	}
	
	@Transactional(readOnly = false , propagation = Propagation.REQUIRES_NEW)
	public boolean editUser(User user) throws GenericDaoException {
		logger.debug("edit user : " + user.toString());
		User editUser = this.findById(user.getId());
		if (!Constants.PASSWORD.equalsIgnoreCase(user.getPassword())) {
			String encryptedPass = EncryptUtils.encryptMD5(user.getPassword());
			editUser.setPassword(encryptedPass);
			editUser.setRepassword(encryptedPass);
		}
		if (!user.getEmail().equalsIgnoreCase(editUser.getEmail())) {
			User saveEmailUser = this.findByEmail(user.getEmail());
			if (saveEmailUser != null) {
				throw new GenericDaoException("Email " + user.getEmail()
						+ " has been registerd ,please change another one.");
			} else{
				editUser.setEmail(user.getEmail());
			}
		}
		logger.debug("save edit user : " + editUser.toString());
		this.saveOrUpdate(editUser);
		return true;
	}
	
	@Transactional(readOnly = false , propagation = Propagation.REQUIRES_NEW)
	public boolean loginUser(User user) throws GenericDaoException {
		
		boolean result = true;
		User existedUser = findByUsername(user.getUsername());

		if (existedUser == null) {
			throw new GenericDaoException(user.getUsername()
					+ " has not been registerd yet ,please register first.");
		} else {
			if (!existedUser.getPassword().equals(
					EncryptUtils.encryptMD5(user.getPassword()))) {
				throw new GenericDaoException("email or password is wrong.");
			}
		}

		return result;
	}
	
	
	public User findByUsername(String username) throws GenericDaoException {
		Query query = this.getEm().createNamedQuery("User.findByUsername");
		query.setParameter("username", username);
		if (query.getResultList().size() == 0) {
			return null;
		} else {
			return (User) query.getSingleResult();
		}
	}
	
	public User findByEmail(String email) throws GenericDaoException {
		Query query = this.getEm().createNamedQuery("User.findByEmail");
		query.setParameter("email", email);
		if (query.getResultList().size() == 0) {
			return null;
		} else {
			return (User) query.getSingleResult();
		}
	}
	

	/**
	 * validate user info
	 * @param user
	 * @return
	 * @throws GenericDaoException 
	 */
	private boolean validateUser(User user) throws GenericDaoException {
		User existedUser = this.findByUsername(user.getUsername());
		if (existedUser != null) {
			throw new GenericDaoException("Username " + user.getUsername()
					+ " has been registerd ,please change another one.");
		}
		existedUser = this.findByEmail(user.getEmail());
		if (existedUser != null) {
			throw new GenericDaoException("Email " + user.getEmail()
					+ " has been registerd ,please change another one.");
		}
		return true;
	}

	
	
}
