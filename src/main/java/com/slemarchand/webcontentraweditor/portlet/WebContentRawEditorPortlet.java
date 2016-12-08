/**
 * Copyright (c) 2015-present Sebastien Le Marchand All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 3 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

package com.slemarchand.webcontentraweditor.portlet;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.lar.ExportImportThreadLocal;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.security.auth.PrincipalException;
import com.liferay.portal.security.permission.ActionKeys;
import com.liferay.portal.security.permission.PermissionThreadLocal;
import com.liferay.portal.service.ServiceContext;
import com.liferay.portal.service.ServiceContextThreadLocal;
import com.liferay.portlet.journal.model.JournalArticle;
import com.liferay.portlet.journal.service.JournalArticleLocalServiceUtil;
import com.liferay.portlet.journal.service.JournalArticleServiceUtil;
import com.slemarchand.webcontentraweditor.util.JournalArticlePermission;
import com.liferay.util.bridges.mvc.MVCPortlet;

import java.io.IOException;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

/**
 * Portlet implementation class WebContentRawEditorPortlet
 */
public class WebContentRawEditorPortlet extends MVCPortlet {

	public void saveRawContent(ActionRequest actionRequest,
			ActionResponse actionResponse) throws IOException, PortletException {

		long id = ParamUtil.getLong(actionRequest, "id");

		String content = ParamUtil.getString(actionRequest, "content");

		ServiceContext serviceContext = ServiceContextThreadLocal.getServiceContext();
		
		long userId  = serviceContext.getUserId();
		
		try {

			JournalArticle article = JournalArticleServiceUtil.getArticle(id);
			
			JournalArticlePermission.check(
					PermissionThreadLocal.getPermissionChecker(), article,
					ActionKeys.UPDATE);
			
			// Need to simulate import process to be allowed to update any 
			// version of the article. 
			ExportImportThreadLocal.setPortletImportInProcess(true);
			
			JournalArticleLocalServiceUtil.updateArticle(
					userId, 
					article.getGroupId(), article.getFolderId(),
					article.getArticleId(), article.getVersion(), 
					article.getTitleMap(), article.getDescriptionMap(), 
					content,
					article.getLayoutUuid(), serviceContext);
			
		} catch (PortalException e) {
			throw new PortletException(e);
		} catch (SystemException e) {
			throw new PortletException(e);
		}
	}

	@Override
	protected void doDispatch(
			RenderRequest renderRequest, RenderResponse renderResponse)
		throws IOException, PortletException {

		if (SessionErrors.contains(
				renderRequest, PrincipalException.class.getName())) {

			include("/error.jsp", renderRequest, renderResponse);
		}
		else {

			super.doDispatch(renderRequest, renderResponse);
		}
	}
}