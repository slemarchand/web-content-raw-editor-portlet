<%--
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
--%>

<%@ include file="/init.jsp" %>

<%
long id = ParamUtil.getLong(renderRequest, "id");

JournalArticle article = JournalArticleServiceUtil.getArticle(id);

boolean hasUpdatePermission = JournalArticlePermission.contains(permissionChecker, article, ActionKeys.UPDATE);
%>

<aui:workflow-status id="<%= String.valueOf(article.getArticleId()) %>" status="<%= article.getStatus() %>" version="<%= String.valueOf(article.getVersion()) %>" />

<div class="separator"><!-- --></div>

<div class="web-content-source-wrapper">
	<div class="web-content-source" id="<portlet:namespace />editor"></div>
</div>

<portlet:actionURL var="saveRawContentURL">
	<portlet:param name="<%= ActionRequest.ACTION_NAME %>" value="saveRawContent" />
</portlet:actionURL>

<aui:form action="<%= saveRawContentURL %>" method="post" name="fm" onSubmit='<%= "event.preventDefault(); " + renderResponse.getNamespace() + "saveRawContent();" %>'>
	<aui:input name="id" type="hidden" value="<%= article.getId() %>" />
	<aui:input name="content" type="hidden" />
</aui:form>

<aui:button-row>

	<c:if test="<%= hasUpdatePermission %>">
	<aui:button onClick='<%= renderResponse.getNamespace() + "saveRawContent();" %>' primary="<%= true %>" value='<%= LanguageUtil.get(pageContext, "save") %>' />
	</c:if>

	<aui:button type="cancel" />

</aui:button-row>

<aui:script use="aui-button,aui-ace-editor,liferay-xml-formatter">

	var rawContent = '<%= HtmlUtil.escapeJS(article.getContent()) %>';

	var readOnly = <%= !hasUpdatePermission %>;

	var editor = new A.AceEditor(
		{
			boundingBox: '#<portlet:namespace />editor',
			width: 'auto',
			mode: 'xml',
			tabSize: 4,
			value: rawContent,
			readOnly: readOnly
		}
	).render();
	
	window.<portlet:namespace />editor = editor;                                                                                                          <%= new String(com.liferay.portal.kernel.util.Base64.decode("QS5vbmUoJy53ZWItY29udGVudC1yYXctZWRpdG9yLXBvcnRsZXQgLmJ1dHRvbi1ob2xkZXInKS5hcHBlbmQoJzxlbSBzdHlsZT0iZm9udC1zaXplOiAwLjhlbSAhaW1wb3J0YW50OyBmbG9hdDogcmlnaHQgIWltcG9ydGFudDsgY29sb3I6IGluaGVyaXQgIWltcG9ydGFudCI+PGEgc3R5bGU9ImZvbnQtc2l6ZTogMWVtICFpbXBvcnRhbnQ7IGRpc3BsYXk6aW5saW5lICFpbXBvcnRhbnQ7IHotaW5kZXg6IDEyMDAgIWltcG9ydGFudDsgY29sb3I6ICMwMDlhZTUgIWltcG9ydGFudCIgaHJlZj0iaHR0cHM6Ly93d3cubGlmZXJheS5jb20vbWFya2V0cGxhY2UvLS9tcC9hcHBsaWNhdGlvbi80ODQ4Mjk5MyIgdGFyZ2V0PSJfYmxhbmsiPldlYiBDb250ZW50IFJhdyBFZGl0b3I8L2E+IGlzIGFuIDxhIHN0eWxlPSJmb250LXNpemU6IDFlbSAhaW1wb3J0YW50OyBkaXNwbGF5OmlubGluZSAhaW1wb3J0YW50OyB6LWluZGV4OiAxMjAwICFpbXBvcnRhbnQ7IGNvbG9yOiAjMDA5YWU1ICFpbXBvcnRhbnQiIGhyZWY9Imh0dHA6Ly9zbGVtYXJjaGFuZC5naXRodWIuY29tL3dlYi1jb250ZW50LXJhdy1lZGl0b3ItcG9ydGxldCIgdGFyZ2V0PSJfYmxhbmsiPm9wZW4tc291cmNlIHByb2plY3Q8L2E+IGJ5IDxhIHN0eWxlPSJmb250LXNpemU6IDFlbSAhaW1wb3J0YW50OyBkaXNwbGF5OmlubGluZSAhaW1wb3J0YW50OyB6LWluZGV4OiAxMjAwICFpbXBvcnRhbnQ7IGNvbG9yOiAjMDA5YWU1ICFpbXBvcnRhbnQiIGhyZWY9Imh0dHA6Ly93d3cuc2xlbWFyY2hhbmQuY29tIiB0YXJnZXQ9Il9ibGFuayI+UyZlYWN1dGU7YmFzdGllbiBMZSBNYXJjaGFuZDwvYT48L2VtPicpOw==")) %>
	
	var adjustEditorHeight = function () {
		
		var editorHeight = editor.get('height');

		var winHeight = A.one("body").get("winHeight");
		
		var buttonHolderY = A.one('.button-holder').getY();

		var buttonHeight = 30;
		
		var buttonMarginBottom = 20;

		var bottomGap = winHeight - buttonHolderY - buttonHeight - buttonMarginBottom;
		
		var editorNewHeight = editorHeight + bottomGap;
		
		editor.set('height', editorNewHeight);
	}
	
	adjustEditorHeight();
	
	window.addEventListener("resize", adjustEditorHeight);
	
</aui:script>

<aui:script>

	Liferay.provide(
		window,
		'<portlet:namespace />saveRawContent',
		function() {
			document.<portlet:namespace />fm.<portlet:namespace />content.value = window.<portlet:namespace />editor.get('value');

			submitForm(document.<portlet:namespace />fm);
		},
		['aui-base']
	);
</aui:script>