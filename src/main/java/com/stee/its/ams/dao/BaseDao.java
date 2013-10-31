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
 * File Name    : BaseDao.java
 *
 * <p> History : <br><br>
 *
 * SNo / CR PR_No / Modified by / Date Modified / Comments <br>
 * --------------------------------------------------------------------------------
 *  
 */
package com.stee.its.ams.dao;

import java.io.Serializable;
import java.util.List;


/**
 * @author huang.zhengyu@wuxi.stee.stengg.com.cn
 * @version 1.0
 * @date 2013-9-2
 */
public interface BaseDao<K extends Serializable, E> {

	E add(E entity) throws GenericDaoException;

	E saveOrUpdate(E entity) throws GenericDaoException;
	
	void delete(E entity) throws GenericDaoException;
	
	void delete(K id) throws GenericDaoException;
	
	void delete(List<K> ids) throws GenericDaoException;

	E findById(K id) throws GenericDaoException;
	
	Object findById(K id , Class clazz) throws GenericDaoException;

}
