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
 * File Name    : UserDao.java
 *
 * <p> History : <br><br>
 *
 * SNo / CR PR_No / Modified by / Date Modified / Comments <br>
 * --------------------------------------------------------------------------------
 *  
 */
package com.stee.its.ams.user.dao;

import java.io.Serializable;
import java.util.List;

import com.stee.its.ams.dao.BaseDao;
import com.stee.its.ams.dao.GenericDaoException;
import com.stee.its.ams.user.entity.User;

/**
 * @author huang.zhengyu@wuxi.stee.stengg.com.cn
 * @version 1.0
 * @date 2013-10-22
 */
public interface UserDao extends BaseDao<Serializable, User>{
	List<User> getList();
	User findByUsername(String username) throws GenericDaoException;
	User findByEmail(String email) throws GenericDaoException;
	boolean registerUser(User user) throws GenericDaoException;
	boolean editUser(User user) throws GenericDaoException;
	boolean loginUser(User user) throws GenericDaoException;
}
