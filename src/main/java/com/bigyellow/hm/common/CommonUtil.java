package com.bigyellow.hm.common;

import java.util.Calendar;
import java.util.Date;

public class CommonUtil {

	public static int calculateStarLevel(Date date, String standardTime) {
		int result = 1;
		Calendar cal = Calendar.getInstance();

		String[] timeArray = standardTime.split(":");

		cal.set(Calendar.HOUR_OF_DAY, Integer.parseInt(timeArray[0]) );
		cal.set(Calendar.MINUTE, Integer.parseInt(timeArray[1]) );
		cal.set(Calendar.SECOND, 0);

		System.out.println(DateUtil.format(cal.getTime() , DateUtil.patterns[1]));

		long diff = Math.abs(date.getTime() - cal.getTimeInMillis());
		if (diff <= 30 * 60 * 1000l) {
			result = 3;
		} else if (diff <= 45 * 60 * 1000l) {
			result = 2;
		}

		System.out.println("result : " + result);
		return result;
	}
	
}
