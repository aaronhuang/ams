package com.bigyellow.hm.entity;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author huang.zhengyu@wuxi.stee.stengg.com.cn
 * @version 1.0
 * @date Oct 28, 2014
 */

@Entity
@NamedQueries({
		@NamedQuery(name = "DrinkRecord.findAllRecords", query = "SELECT r FROM DrinkRecord r WHERE r.uid = :uid"),
		@NamedQuery(name = "DrinkRecord.findTodayRecords", query = "SELECT DISTINCT r FROM DrinkRecord r WHERE r.uid = :uid and r.time = :time"),
		@NamedQuery(name = "DrinkRecord.findTodayRecordByCup", query = "SELECT DISTINCT r FROM DrinkRecord r WHERE r.uid = :uid and r.time = :time and r.cupNumber = :cupNumber"),
		@NamedQuery(name = "DrinkRecord.findHistoryRecord", query = "SELECT DISTINCT r FROM DrinkRecord r WHERE r.uid = :uid and r.time < :time") })
@XmlRootElement
public class DrinkRecord extends BaseEntity {

	private String uid;

	@Temporal(TemporalType.DATE)
	private Date time;

	@Temporal(TemporalType.TIMESTAMP)
	private Date recordTime;

	private int total;

	private int starLevel;
	
	private int cupNumber;

	public String getUid() {
		return uid;
	}

	public void setUid(String uid) {
		this.uid = uid;
	}

	public Date getTime() {
		return time;
	}

	public void setTime(Date time) {
		this.time = time;
	}

	public int getTotal() {
		return total;
	}

	public void setTotal(int total) {
		this.total = total;
	}

	public int getCupNumber() {
		return cupNumber;
	}

	public void setCupNumber(int cupNumber) {
		this.cupNumber = cupNumber;
	}

	public Date getRecordTime() {
		return recordTime;
	}

	public void setRecordTime(Date recordTime) {
		this.recordTime = recordTime;
	}
	

	public int getStarLevel() {
		return starLevel;
	}

	public void setStarLevel(int starLevel) {
		this.starLevel = starLevel;
	}

	

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = super.hashCode();
		result = prime * result + cupNumber;
		result = prime * result
				+ ((recordTime == null) ? 0 : recordTime.hashCode());
		result = prime * result + starLevel;
		result = prime * result + ((time == null) ? 0 : time.hashCode());
		result = prime * result + total;
		result = prime * result + ((uid == null) ? 0 : uid.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (!super.equals(obj))
			return false;
		if (getClass() != obj.getClass())
			return false;
		DrinkRecord other = (DrinkRecord) obj;
		if (cupNumber != other.cupNumber)
			return false;
		if (recordTime == null) {
			if (other.recordTime != null)
				return false;
		} else if (!recordTime.equals(other.recordTime))
			return false;
		if (starLevel != other.starLevel)
			return false;
		if (time == null) {
			if (other.time != null)
				return false;
		} else if (!time.equals(other.time))
			return false;
		if (total != other.total)
			return false;
		if (uid == null) {
			if (other.uid != null)
				return false;
		} else if (!uid.equals(other.uid))
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "DrinkRecord [uid=" + uid + ", time=" + time + ", recordTime="
				+ recordTime + ", total=" + total + ", cupNumber=" + cupNumber
				 + ", starLevel=" + starLevel
				+ "]";
	}

}
