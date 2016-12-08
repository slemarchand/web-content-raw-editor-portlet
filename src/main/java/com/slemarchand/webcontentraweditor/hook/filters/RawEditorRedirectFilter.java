package com.slemarchand.webcontentraweditor.hook.filters;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.servlet.BaseFilter;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RawEditorRedirectFilter extends BaseFilter {

	public void processFilter(
			HttpServletRequest request, HttpServletResponse response, 
			FilterChain chain) {

		try {
			request.getRequestDispatcher("/c/portal/wcre").forward(request, response);
			
		} catch (ServletException e) {
			sendError(request, response, e);
		} catch (IOException e) {
			sendError(request, response, e);
		} 
	}

	private void sendError(
			HttpServletRequest request,
			HttpServletResponse response, Exception e) {
		
		String message = "Unexpected error for URL " 
				+ request.getRequestURL() + ": " + e.getMessage();
		
		_log.error(message, e);
		
		try {
			response.sendError(
					HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
					e.getMessage());
			
		} catch (IOException ioe) {
			_log.error(message, ioe);
		}	
	}

	@Override
	protected Log getLog() {
		return _log;
	}

	private static Log _log = LogFactoryUtil
			.getLog(RawEditorRedirectFilter.class);
}
