/**
 * 
 */
package com.bigyellow.hm.web;


import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.bigyellow.hm.dao.DrinkRecordDao;
import com.bigyellow.hm.entity.DrinkRecord;

/**
 * Handles and retrieves the login or denied page depending on the URI template
 */
@Controller
public class HomeController {
        
	protected static Logger logger = Logger.getLogger("controller");
	
	@Autowired
	DrinkRecordDao dao;

	/**
	 * Handles and retrieves the login JSP page
	 * 
	 * @return the name of the JSP page
	 */
	@RequestMapping(value = "/home", method = RequestMethod.GET)
	public String getLoginPage(@RequestParam(value="uid", required=false) String uid, 
			RedirectAttributes  model) {
		logger.debug("Received request to home page for " + uid);
		
		List<DrinkRecord> records = dao.getTodayRecords(uid);
//		model.put("records", records);
//		model.put("uid", uid);
		
		model.addFlashAttribute("records", records);
		model.addFlashAttribute("uid", uid);
		
		// This will resolve to /WEB-INF/jsp/loginpage.jsp
		
		return "redirect:/web/today?user="+uid;
	}
	
	@RequestMapping(value = "/today", method = RequestMethod.GET)
	public String toTodayPage(@RequestParam(value="user", required=false) String user, 
			Model model,HttpServletRequest request) {
		logger.debug("Received request to today page ");
		
		Map<String , ? > maps = model.asMap();
		String uid = (String) maps.get("uid");
		logger.info("uid : " + uid);
		logger.info("user" + user);
		
		logger.info("uid in request" + request.getParameter("uid"));
		// This will resolve to /WEB-INF/jsp/loginpage.jsp
		
		return "home";
	}
 
}