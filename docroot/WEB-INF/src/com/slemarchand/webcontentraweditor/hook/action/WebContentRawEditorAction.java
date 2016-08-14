package com.slemarchand.webcontentraweditor.hook.action;

import com.liferay.portal.kernel.portlet.LiferayPortletURL;
import com.liferay.portal.kernel.portlet.LiferayWindowState;
import com.liferay.portal.kernel.struts.BaseStrutsAction;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.workflow.WorkflowConstants;
import com.liferay.portal.util.PortalUtil;
import com.liferay.portlet.PortletURLFactoryUtil;
import com.liferay.portlet.journal.model.JournalArticle;
import com.liferay.portlet.journal.service.JournalArticleServiceUtil;
import com.slemarchand.webcontentraweditor.util.PortletKeys;

import javax.portlet.PortletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class WebContentRawEditorAction extends BaseStrutsAction {

	@Override
	public String execute(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		String namespace;
		
		String portletId = request.getParameter("p_p_id");
		
		if(Validator.isNotNull(portletId)) {
			namespace = StringPool.UNDERLINE + portletId + StringPool.UNDERLINE;
		} else {
			namespace = StringPool.BLANK;
		}
		
		long companyId = PortalUtil.getCompanyId(request);
		
		long groupId = ParamUtil.getLong(request, namespace + "groupId");
		
		String articleId = request.getParameter(namespace + "articleId");
		
		JournalArticle article = JournalArticleServiceUtil.getLatestArticle(
				groupId, articleId, WorkflowConstants.STATUS_ANY);
				
		long id = article.getId();
				
		LiferayPortletURL url = PortletURLFactoryUtil.create(
				request, PortletKeys.WEB_CONTENT_RAW_EDITOR, PortalUtil.getControlPanelPlid(companyId),
				PortletRequest.RENDER_PHASE);
		
		url.setWindowState(LiferayWindowState.POP_UP);
		
		url.setParameter("id", Long.toString(id));
		
		response.sendRedirect(url.toString());
		
		return StringPool.BLANK;
	}
}
