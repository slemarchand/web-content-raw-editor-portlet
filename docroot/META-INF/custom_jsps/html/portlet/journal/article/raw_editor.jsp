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

<%@ include file="/html/portlet/journal/init.jsp" %>

<%@ page import="com.liferay.portlet.PortletURLFactoryUtil" %>

<%
JournalArticle article = (JournalArticle)request.getAttribute(WebKeys.JOURNAL_ARTICLE);

String portletId = "1_WAR_webcontentraweditorportlet";

PortletURL rawEditorPortletURL = PortletURLFactoryUtil.create(request, portletId, plid, Constants.VIEW);
rawEditorPortletURL.setWindowState(LiferayWindowState.POP_UP);
rawEditorPortletURL.setParameter("id", Long.toString(article.getId()));

boolean hasUpdatePermission = JournalArticlePermission.contains(permissionChecker, article, ActionKeys.UPDATE);
%>

<style>

</style>

<aui:script use="aui-button">

	var rawEditorTab = A.one('#<portlet:namespace />rawEditorTab');

	if (rawEditorTab != null) {
		rawEditorTab.setAttribute('style','display:none');
	}

	var form = A.one(document.<portlet:namespace />fm1);

	var formChanged = false;

	form.delegate(
		'change',
		function(event) {
			formChanged = true;
		},
		':input'
	);

	var hasUnsavedChanges = function() {
		var unsavedChanges = formChanged;

		if (!unsavedChanges && typeof CKEDITOR !== 'undefined') {
			A.Object.some(
				CKEDITOR.instances,
				function(item, index, collection) {
					var parentForm = A.one('#' + item.element.getId()).ancestor('form');

					if (parentForm.compareTo(form)) {
						unsavedChanges = item.checkDirty();

						return unsavedChanges;
					}
				}
			);
		}

		return unsavedChanges;
	};

	// Define raw editor button

	var rawEditorButtonId = '<portlet:namespace/>rawEditorButton';

	var rawEditorButtonConfig = {
		icon: '<%= hasUpdatePermission?"icon-edit":"icon-search" %>',
		id: rawEditorButtonId,
		label: '<%= UnicodeLanguageUtil.get(pageContext, hasUpdatePermission?"raw-editor":"raw-viewer") %>',
		on: {
			click: function(event) {

				console.log('click on raw editor button');

				event.domEvent.preventDefault();

				if (!hasUnsavedChanges()) {

					var title = '<%= HtmlUtil.escapeJS(article.getTitle(locale)) %>';
					var uri = '<%= HtmlUtil.escapeJS(rawEditorPortletURL.toString()) %>';
					
					Liferay.Util.Window.getWindow({
						title: title,
						uri: uri,
			            dialog: {
			            	openingWindow: window,
			                modal: true,
			                cache: false,
			                destroyOnHide: true
			            }
			        }).after('destroy', function(event) {
			        	if(window._1_WAR_webcontentraweditorportlet_reloadRequired) {
			        		
			        		new A.LoadingMask({		
								target: A.one('.portlet-content')
							}).show();
			        		
			        		window.location.reload(true);
			        	}
			        });
	
				}
				else if (confirm('<liferay-ui:message key="in-order-to-open-raw-editor,-the-web-content-will-be-saved-as-a-draft" />')) {
					var hasStructure = window.<portlet:namespace />journalPortlet.hasStructure();
					var hasTemplate = window.<portlet:namespace />journalPortlet.hasTemplate();
					var updateStructureDefaultValues = window.<portlet:namespace />journalPortlet.updateStructureDefaultValues();

					if (hasStructure && !hasTemplate && !updateStructureDefaultValues) {
						window.<portlet:namespace />journalPortlet.displayTemplateMessage();
					}
					else {
						form.one('#<portlet:namespace /><%= Constants.CMD %>').val('<%= Constants.PREVIEW %>');

						submitForm(form);
					}
				}
			},
			render: function(event) {
				new A.Tooltip(
					{
						trigger: '#<portlet:namespace/>rawEditorButton'
					}
				).render();
			}
		},
		title: '<liferay-ui:message key="raw-editor-allows-you-to-directly-manage-content-as-raw-xml" />'
	};

	// Place raw editor button in article toolbar

	A.one('#<portlet:namespace />articleToolbar')
		.placeAfter('<div id="<portlet:namespace />rawEditorToolbar">');

	new A.Toolbar(
		{
			boundingBox: '#<portlet:namespace />rawEditorToolbar',
			children: [[rawEditorButtonConfig]]
		}
	).render();

	A.one('#' + rawEditorButtonId).appendTo('#<portlet:namespace />articleToolbar .btn-group');

</aui:script>