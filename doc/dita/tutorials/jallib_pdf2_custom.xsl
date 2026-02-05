<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:jallib="urn:jallib:pdf2"
  version="2.0"
  exclude-result-prefixes="xs jallib">

  <!--
    Customization for DITA-OT pdf2 output.

    Support manual page breaks via outputclass="page-break-before" on
    section/title (or the parent section). DITA-OT pdf2 does not interpret
    this outputclass by default.
  -->

  <!-- Pull in the standard pdf2 pipeline, then override specific templates. -->
  <xsl:import href="plugin:org.dita.pdf2:xsl/fo/topic2fo_shell.xsl"/>

  <xsl:function name="jallib:has-class" as="xs:boolean">
    <xsl:param name="node" as="node()?"/>
    <xsl:param name="cls" as="xs:string"/>
    <xsl:sequence
      select="exists($node) and contains(concat(' ', normalize-space(string($node/@outputclass)), ' '),
                                         concat(' ', $cls, ' '))"/>
  </xsl:function>

  <!-- Force page break before section titles when requested via outputclass. -->
  <xsl:template match="*[contains(@class,' topic/section ')]/*[contains(@class,' topic/title ')]">
    <fo:block xsl:use-attribute-sets="section.title">
      <xsl:call-template name="commonattributes"/>

      <xsl:if test="jallib:has-class(., 'page-break-before') or jallib:has-class(.., 'page-break-before')">
        <xsl:attribute name="break-before">page</xsl:attribute>
      </xsl:if>

      <xsl:apply-templates select="." mode="customTitleAnchor"/>
      <xsl:apply-templates select="." mode="getTitle"/>
    </fo:block>
  </xsl:template>

</xsl:stylesheet>

