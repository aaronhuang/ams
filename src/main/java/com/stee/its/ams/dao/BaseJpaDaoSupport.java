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
 * File Name    : BaseJpaDaoSupport.java
 *
 * <p> History : <br><br>
 *
 * SNo / CR PR_No / Modified by / Date Modified / Comments <br>
 * --------------------------------------------------------------------------------
 *  
 */
package com.stee.its.ams.dao;

import java.io.Serializable;
import java.lang.reflect.ParameterizedType;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;


/**
 * @author huang.zhengyu@wuxi.stee.stengg.com.cn
 * @version 1.0
 * @param <V>
 * @date 2013-9-2
 */

@Repository
@Transactional(readOnly = true)
public abstract class BaseJpaDaoSupport<K extends Serializable, E> implements
		BaseDao<Serializable, E> {
	
	protected Class entityClass;
	
	@PersistenceContext
	private EntityManager em;

	public void setEntityManager(EntityManager entityManager) {
		this.em = entityManager;
	}
	
	public EntityManager getEm() {
		return em;
	}


	public void setEm(EntityManager em) {
		this.em = em;
	}


	public BaseJpaDaoSupport() {
		ParameterizedType genericSuperclass = (ParameterizedType) getClass()
				.getGenericSuperclass();
		this.entityClass = (Class) genericSuperclass.getActualTypeArguments()[1];
	}

	@Transactional(readOnly = false , propagation = Propagation.REQUIRES_NEW)
	public E add(E entity) throws GenericDaoException {
		 this.em.persist(entity);
		 this.em.flush();
		 this.em.clear();
		 return entity;
	}

	@Transactional(readOnly = false , propagation = Propagation.REQUIRES_NEW)
	public E saveOrUpdate(E entity) throws GenericDaoException {
		return this.em.merge(entity);
	}
	
	
	@Transactional(readOnly = false , propagation = Propagation.REQUIRES_NEW)
	public void delete(E entity) throws GenericDaoException {
		em.remove(entity);
	}
	
	@Transactional(readOnly = false , propagation = Propagation.REQUIRES_NEW)
	public void delete(Serializable id) throws GenericDaoException {
		E resource = (E) em.find(this.entityClass, id);
		em.remove(resource);
	}

	@Transactional(readOnly = false , propagation = Propagation.REQUIRES_NEW)
	public void delete(List<Serializable> ids) throws GenericDaoException {
		for(Serializable id : ids) {
			this.delete(id);
		}
	}

	public E findById(Serializable id) throws GenericDaoException {
		return (E) this.em.find(entityClass, id);
	}
	
	public Object findById(Serializable id , Class clazz) throws GenericDaoException {
		return this.em.find(clazz, id);
	}

	
	/**
	 * Handle whether to using paging , set paging parameter if using paging.
	 * @param currentPage : start from 0 
	 * @param pageSize
	 * @param query
	 */
	protected void handlePagingParam(int currentPage, int pageSize, Query query) {
		if(currentPage >=0 ) {
			int startPosition = currentPage * pageSize;
			query.setFirstResult(startPosition);
			query.setMaxResults(pageSize);
		}
	}

}
