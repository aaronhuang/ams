package com.bigyellow.hm.rs;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;

import com.bigyellow.hm.common.CommonUtil;
import com.bigyellow.hm.common.Constants;
import com.bigyellow.hm.common.ValidateResult;
import com.bigyellow.hm.dao.DrinkRecordDao;
import com.bigyellow.hm.dao.GenericDaoException;
import com.bigyellow.hm.entity.DrinkRecord;

/**
 * @author huang.zhengyu@wuxi.stee.stengg.com.cn
 * @version 1.0
 * @date 2013-10-22
 */

@Path("/drinkrecord/")
public class DrinkRecordResource {

	public static final Logger logger = LoggerFactory
			.getLogger(DrinkRecordResource.class);

	@Autowired
	DrinkRecordDao dao;

	@Autowired(required = true)
	private MessageSource messageSource;
	
	public DrinkRecordResource() {
		
	}

	@Path("/add/{uid}/{cupNumber}")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	@Consumes(MediaType.APPLICATION_JSON )
	public ValidateResult add(@PathParam("uid") String uid ,
			@PathParam("cupNumber") Integer cupNumber) {
		logger.debug("drinkRecordAdd for uid: " + uid + ", cup number : " + cupNumber);
		ValidateResult result = new ValidateResult();
		try {
			DrinkRecord existed = this.dao.getTodayRecordByCup(uid, cupNumber);
			if (existed == null) {
				existed = new DrinkRecord();
				existed.setUid(uid);
				Date current = Calendar.getInstance().getTime();
				existed.setTime(current);
				existed.setRecordTime(current);
				existed.setCupNumber(cupNumber);
				existed.setStarLevel(CommonUtil.calculateStarLevel(current,
						Constants.drinkStandardTime[cupNumber - 1]));
				logger.info("save to database : " + existed.toString());
			}
			this.dao.saveOrUpdate(existed);
			result.setObj(existed);
		} catch (GenericDaoException e) {
			logger.error(e.getErrorMsg() + " : " + e.getMessage());
			result.resolveErrorMsg(e.getErrorMsg());
		}
		
		return result;
	}
	
	@Path("/history/{uid}")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	@Consumes(MediaType.APPLICATION_JSON )
	public List<DrinkRecord> getHistory(@PathParam("uid") String uid) {
		logger.debug("get history for uid: " + uid);
		List<DrinkRecord> result = new ArrayList<DrinkRecord>();
		result = this.dao.getHistoryList(uid);
		logger.debug("get history record size : " + result.size());
		return result;
	}
	
	@Path("/today/{uid}")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	@Consumes(MediaType.APPLICATION_JSON )
	public List<DrinkRecord> getToday(@PathParam("uid") String uid) {
		logger.debug("get today for uid: " + uid);
		List<DrinkRecord> result = this.dao.getTodayRecords(uid);
		return result;
	}
	
	
	
}
