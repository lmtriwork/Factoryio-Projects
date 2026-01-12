<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html"/>

	<!-- global values from root element attributes (LogFile): -->
	<xsl:variable name="DateText" select="/LogFile/@dateText"/>
	<xsl:variable name="DateTime" select="/LogFile/@dateTime"/>
	<xsl:variable name="TypeColHeader" select="/LogFile/@typeText"/>
	<xsl:variable name="MessageColHeader" select="/LogFile/@messageText"/>
	<xsl:variable name="HelpIdColHeader" select="/LogFile/@helpIdText"/>
	<xsl:variable name="TimeColHeader" select="/LogFile/@timeText"/>
	<xsl:variable name="ProjectName" select="/LogFile/@projectName"/>
	<xsl:variable name="PageTitle" select="/LogFile/@titleName"/>
	<!-- /global values from root element attributes -->

	<xsl:variable name="SupportedMessageTypes">|Action|CriticalError|CriticalDecision|CriticalErrorDecision|Decision|Error|ErrorDecision|Information|Input|Success|Warning|</xsl:variable>
	<xsl:variable name="IconFileExtension">jpg</xsl:variable>
	<xsl:variable name="Action">ICO_PE_InfoActionRequest.ico</xsl:variable>
	<xsl:variable name="CriticalError">ICO_PE_InfoErrorCritical.ico</xsl:variable>
	<xsl:variable name="CriticalDecision">ICO_PE_InfoDecisionCritical.ico</xsl:variable>
	<xsl:variable name="CriticalErrorDecision">ICO_PE_InfoErrorCritical.ico</xsl:variable>
	<xsl:variable name="Decision">ICO_PE_InfoDecision.ico</xsl:variable>
	<xsl:variable name="Error">ICO_PE_InfoError.ico</xsl:variable>
	<xsl:variable name="ErrorDecision">ICO_PE_InfoError.ico</xsl:variable>
	<xsl:variable name="Information">ICO_PE_InfoInformation.ico</xsl:variable>
	<xsl:variable name="Input">ICO_PE_InfoInputRequired.ico</xsl:variable>
	<xsl:variable name="Success">ICO_PE_InfoSuccess.ico</xsl:variable>
	<xsl:variable name="Warning">ICO_PE_InfoWarning.ico</xsl:variable>

	<xsl:template match="/LogFile">
		<html>
			<head>
				<title><xsl:value-of select="$PageTitle"/></title>
				<style type="text/css">
					.TitleText    { font-family:'Siemens TIA Portal Basic'; font-size:15pt; font-weight: bold; color: #59717d; line-height:23px; }
					.Text         { font-family:'Siemens TIA Portal Basic'; font-size:10pt; font-weight: bold; color: black;   line-height:26px; }
					.TableHeader  { font-family:'Siemens TIA Portal Basic'; font-size:10pt;  font-weight: bold;   height: 15pt; text-indent: 5pt; border-style: solid; border-color: #8ca3b0; border-width: 0.5pt 0.5pt 0.5pt 0.0pt; background-color:#b6c5cf; }
					.TableHeader1 { font-family:'Siemens TIA Portal Basic'; font-size:10pt;  font-weight: bold;   height: 15pt; text-indent: 5pt; border-style: solid; border-color: #bfbfbf; border-width: 0.0pt 0.5pt 0.5pt 0.0pt; background-color:#d4dbde; }
					.TableHeader2 { font-family:'Siemens TIA Portal Basic'; font-size:10pt;  font-weight: bold;   height: 15pt; text-indent: 5pt; border-style: solid; border-color: #bfbfbf; border-width: 0.0pt 0.5pt 0.5pt 0.0pt; background-color:#e7ebed; }
					.TableContent { font-family:'Siemens TIA Portal Basic'; font-size:10pt;  font-weight: normal; height: 15pt; text-indent: 5pt; border-style: solid; border-color: #bfbfbf; border-width: 0.0pt 0.5pt 0.5pt 0.0pt; }
				</style>
			</head>
			<body>
				<p class="TitleText">
					<xsl:value-of select="$ProjectName"/>
				</p>
				<span class="Text">
					<xsl:value-of select="$DateText"/>
					&#160;
					<xsl:value-of select="$DateTime"/>
				</span>
				<table cellspacing="0" cellpadding="3" style="border-left: 1px solid #bfbfbf">
					<tr class="TableHeader">
						<td class="TableHeader" align="left" style="width: 32px; text-indent: 0;">
							<xsl:value-of select="$TypeColHeader"/>
						</td>
						<td class="TableHeader" align="left" style="width: 648px">
							<xsl:value-of select="$MessageColHeader"/>
						</td>
						<td class="TableHeader" align="left" style="width: 90px">
							<xsl:value-of select="$TimeColHeader"/>
						</td>
					</tr>
					<xsl:apply-templates select="LogEntry"/>
				</table>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="LogEntry" match="LogFile/LogEntry">
		<xsl:param name="Level" select="1"/>
		<xsl:choose>
			<!-- when element has a child element named 'LogEntry' -->
			<xsl:when test="LogEntry">
				<!-- call branch template on entry -->
				<xsl:call-template name="LogEntryBranch">
					<xsl:with-param name="Level" select="$Level"/>
				</xsl:call-template>
				<!-- recurse on children -->
				<xsl:for-each select="LogEntry">
					<xsl:call-template name="LogEntry">
						<xsl:with-param name="Level" select="$Level+1"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<!-- entry has no children, apply leaf style -->
				<xsl:call-template name="LogEntryLeaf">
					<xsl:with-param name="Level" select="$Level"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="LogEntryBranch">
		<xsl:param name="Level" select="1"/>
		<xsl:variable name="class" select="concat('TableHeader', $Level)"/>
		<tr class="{$class}">
			<td class="{$class}">&#160;</td>
			<td class="{$class}">
				<xsl:value-of select="Message"/>
				<!-- IE6 doesn't support empty-cells style so insert a non-breaking space where needed-->
				<xsl:if test="normalize-space(Message)=false()">&#160;</xsl:if>
			</td>
			<td class="{$class}">
				<xsl:value-of select="@dateTime"/>
				<!-- IE6 doesn't support empty-cells style so insert a non-breaking space where needed-->
				<xsl:if test="normalize-space(@dateTime)=false()">&#160;</xsl:if>
			</td>
		</tr>
	</xsl:template>

	<xsl:template name="LogEntryLeaf">
		<xsl:param name="Level" select="1"/>
		<tr class="TableContent">
			<td align="center" class="TableContent" style="text-indent:0;">
				<xsl:choose>
					<xsl:when test="contains($SupportedMessageTypes, concat('|', @type,'|') )">
						<xsl:element name="img">
							<xsl:attribute name="src">
								<xsl:choose>
									<xsl:when test="@type = 'Action'">ICO_PE_InfoActionRequest.ico</xsl:when>
									<xsl:when test="@type = 'CriticalError'">ICO_PE_InfoErrorCritical.ico</xsl:when>
									<xsl:when test="@type = 'CriticalDecision'">ICO_PE_InfoDecisionCritical.ico</xsl:when>
									<xsl:when test="@type = 'CriticalErrorDecision'">ICO_PE_InfoErrorCritical.ico</xsl:when>
									<xsl:when test="@type = 'Decision'">ICO_PE_InfoDecision.ico</xsl:when>
									<xsl:when test="@type = 'Error'">ICO_PE_InfoError.ico</xsl:when>
									<xsl:when test="@type = 'ErrorDecision'">ICO_PE_InfoError.ico</xsl:when>
									<xsl:when test="@type = 'Information'">ICO_PE_InfoInformation.ico</xsl:when>
									<xsl:when test="@type = 'Input'">ICO_PE_InfoInputRequired.ico</xsl:when>
									<xsl:when test="@type = 'Success'">ICO_PE_InfoSuccess.ico</xsl:when>
									<xsl:when test="@type = 'Warning'">ICO_PE_InfoWarning.ico</xsl:when>
								</xsl:choose>
							</xsl:attribute>
							<xsl:attribute name="height">16</xsl:attribute>
							<xsl:attribute name="width">16</xsl:attribute>
						</xsl:element>
					</xsl:when>
					<!-- IE6 doesn't support empty-cells style so insert a non-breaking space where needed-->
					<xsl:otherwise>&#160;</xsl:otherwise>
				</xsl:choose>
			</td>
			<td align="left" class="TableContent">
				<xsl:value-of select="Message"/>
				<!-- IE6 doesn't support empty-cells style so insert a non-breaking space where needed-->
				<xsl:if test="normalize-space(Message)=false()">&#160;</xsl:if>
			</td>
			<td align="left" class="TableContent">
				<xsl:value-of select="@dateTime"/>
				<!-- IE6 doesn't support empty-cells style so insert a non-breaking space where needed-->
				<xsl:if test="normalize-space(@dateTime)=false()">&#160;</xsl:if>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>