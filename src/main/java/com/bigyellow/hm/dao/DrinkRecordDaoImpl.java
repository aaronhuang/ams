package com.bigyellow.hm.dao;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.persistence.Query;
import javax.persistence.TemporalType;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.bigyellow.hm.common.DateUtil;
import com.bigyellow.hm.entity.DrinkRecord;



@Repository(value="DrinkRecordDaoImpl")
@Transactional(readOnly = true)
public class DrinkRecordDaoImpl extends BaseJpaDaoSupport<Integer, DrinkRecord>
		implements DrinkRecordDao {

	public static final Logger logger = LoggerFactory
			.getLogger(DrinkRecordDaoImpl.class);

	public List<DrinkRecord> getTodayRecords(String uid) {
		Date currentTime = Calendar.getInstance().getTime();
//		Date currentDate = DateUtil.parse(DateUtil.format(currentTime,
//				DateUtil.patterns[0]));
		List<DrinkRecord> result = new ArrayList<DrinkRecord>();
		Query query = this.getEm()
				.createNamedQuery("DrinkRecord.findTodayRecords")
				.setParameter("uid", uid)
				.setParameter("time", currentTime, TemporalType.DATE);
		result = query.getResultList();
		logger.info("getTodayRecord:" + result.size());
		for (DrinkRecord rec : result) {
			logger.info(rec.toString());
		}
		return result;
	}
	
	public DrinkRecord getTodayRecordByCup(String uid , Integer cupNumber) {
		Date currentTime = Calendar.getInstance().getTime();
		Date currentDate = DateUtil.parse(DateUtil.format(currentTime,
				DateUtil.patterns[0]));
		DrinkRecord result = null;
		Query query = this.getEm()
				.createNamedQuery("DrinkRecord.findTodayRecordByCup")
				.setParameter("uid", uid)
				.setParameter("time", currentDate, TemporalType.DATE)
				.setParameter("cupNumber", cupNumber);;
		List list = query.getResultList();
		if(list != null  && !list.isEmpty()){
			result = (DrinkRecord) query.getSingleResult();
		}
		if(result != null){
			logger.info(result.toString());
		}
		return result;
	}

	public List<DrinkRecord> getHistoryList(String uid) {
		Date currentTime = Calendar.getInstance().getTime();
		Date currentDate = DateUtil.parse(DateUtil.format(currentTime,
				DateUtil.patterns[0]));
		List<DrinkRecord> result = (List<DrinkRecord>) this.getEm()
				.createNamedQuery("DrinkRecord.findHistoryRecord")
				.setParameter("uid", uid)
				.setParameter("time", currentDate).getResultList();
		logger.info("getHistoryList:" + result.size());
		return result;
	}

}
