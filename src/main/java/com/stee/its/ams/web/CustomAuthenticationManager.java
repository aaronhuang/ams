package com.stee.its.ams.web;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.authentication.encoding.Md5PasswordEncoder;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.GrantedAuthorityImpl;

import com.stee.its.ams.user.dao.UserDao;
import com.stee.its.ams.user.entity.User;

/**
 * A custom authentication manager that allows access if the user details
 * exist in the database and if the username and password are not the same.
 * Otherwise, throw a {@link BadCredentialsException}
 */
public class CustomAuthenticationManager implements AuthenticationManager {

	protected static Logger logger = Logger
			.getLogger(CustomAuthenticationManager.class);

	@Autowired
	UserDao userDao;

	public Authentication authenticate(Authentication auth)
			throws AuthenticationException {

		logger.debug("Performing custom authentication");
		User user = new User();
		user.setUsername(auth.getName());
		user.setPassword((String) auth.getCredentials());

		try {
			logger.debug(user.toString());
			this.userDao.loginUser(user);
		} catch (Exception e) {
			logger.error(e.getMessage());
			logger.error("User does not exists!");
			throw new BadCredentialsException(e.getMessage());
		}

		// Compare passwords
		// Make sure to encode the password first before comparing
//		if (passwordEncoder.isPasswordValid(user.getPassword(),
//				(String) auth.getCredentials(), null) == false) {
//			logger.error("Wrong password!");
//			throw new BadCredentialsException("Wrong password!");
//		}

		// Here's the main logic of this custom authentication manager
		// Username and password must be the same to authenticate
		if (auth.getName().equals(auth.getCredentials()) == true) {
			logger.debug("Entered username and password are the same!");
			throw new BadCredentialsException(
					"Entered username and password are the same!");
		} else {
			logger.debug("User details are good and ready to go");
			return new UsernamePasswordAuthenticationToken(auth.getName(),
					auth.getCredentials(), getAuthorities(1));
		}
	}

	/**
	 * Retrieves the correct ROLE type depending on the access level, where
	 * access level is an Integer. Basically, this interprets the access value
	 * whether it's for a regular user or admin.
	 * 
	 * @param access
	 *            an integer value representing the access of the user
	 * @return collection of granted authorities
	 */
	public Collection<GrantedAuthority> getAuthorities(Integer access) {
		// Create a list of grants for this user
		List<GrantedAuthority> authList = new ArrayList<GrantedAuthority>(2);

		// All users are granted with ROLE_USER access Therefore this user gets a ROLE_USER by default
		logger.debug("Grant ROLE_USER to this user");
		authList.add(new GrantedAuthorityImpl("ROLE_USER"));

		// Check if this user has admin access We interpret Integer(1) as an admin user
		if (access.compareTo(1) == 0) {
			// User has admin access
			logger.debug("Grant ROLE_ADMIN to this user");
			authList.add(new GrantedAuthorityImpl("ROLE_ADMIN"));
		}

		// Return list of granted authorities
		return authList;
	}

}
