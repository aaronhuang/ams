package com.bigyellow.hm.dao;

import java.io.Serializable;
import java.util.List;

import com.bigyellow.hm.entity.DrinkRecord;

public interface DrinkRecordDao extends BaseDao<Serializable, DrinkRecord>{
	List<DrinkRecord> getTodayRecords(String uid);
	DrinkRecord getTodayRecordByCup(String uid , Integer cupNumber);
	List<DrinkRecord> getHistoryList(String uid);
	
	List<DrinkRecord> getAllRecords(String uid);
	void clearRecords(String uid);
}
