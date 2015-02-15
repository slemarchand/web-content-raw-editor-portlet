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

package com.slemarchand.webcontentraweditor.util;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.util.ClassResolverUtil;
import com.liferay.portal.kernel.util.MethodKey;
import com.liferay.portal.kernel.util.PortalClassInvoker;
import com.liferay.portal.security.permission.PermissionChecker;
import com.liferay.portlet.journal.model.JournalArticle;
public class JournalArticlePermission {

	public static void check(
			PermissionChecker permissionChecker, JournalArticle article,
			String actionId)
		throws PortalException, SystemException {

		try {
			PortalClassInvoker.invoke(false, _checkMethodKey, permissionChecker, article, actionId);

		} catch (PortalException e) {
			throw e;
		} catch (SystemException e) {
			throw e;
		} catch (Exception e) {
			throw new SystemException(e);
		}
	}

	public static boolean contains(
			PermissionChecker permissionChecker, JournalArticle article,
			String actionId)
		throws PortalException, SystemException {

		boolean value;

		try {
			Object returnObj = PortalClassInvoker.invoke(false, _containsMethodKey, permissionChecker, article, actionId);

			value = (boolean)returnObj;

		} catch (PortalException e) {
			throw e;
		} catch (SystemException e) {
			throw e;
		} catch (Exception e) {
			throw new SystemException(e);
		}

		return value;
	}

	private final static String _CLASS_NAME = "com.liferay.portlet.journal.service.permission.JournalArticlePermission";

	private static MethodKey _containsMethodKey = new MethodKey(
			ClassResolverUtil.resolveByPortalClassLoader(_CLASS_NAME),
			"contains", PermissionChecker.class, JournalArticle.class, String.class); private static MethodKey _checkMethodKey = new MethodKey(
			ClassResolverUtil.resolveByPortalClassLoader(_CLASS_NAME),
			"check", PermissionChecker.class, JournalArticle.class, String.class);
}