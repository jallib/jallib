<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="1.0">

    <!-- beautify prolog -->
    <xsl:attribute-set name="prolog">
        <xsl:attribute name="start-indent">300pt</xsl:attribute>
        <xsl:attribute name="font-size"><xsl:value-of select="$default-font-size"/></xsl:attribute>
        <xsl:attribute name="border-style">solid</xsl:attribute>
        <xsl:attribute name="border-color">black</xsl:attribute>
        <xsl:attribute name="border-width">thin</xsl:attribute>
        <xsl:attribute name="text-align">right</xsl:attribute>
        <xsl:attribute name="background-color">#f0f0d0</xsl:attribute>
        <xsl:attribute name="padding">6pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="topic.title">
        <xsl:attribute name="font-family">Sans</xsl:attribute>
		<xsl:attribute name="border-bottom">5pt solid black</xsl:attribute>
        <xsl:attribute name="margin-top">0pc</xsl:attribute>
        <xsl:attribute name="margin-bottom">1.4pc</xsl:attribute>
        <xsl:attribute name="font-size">18pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="padding-top">1.4pc</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="topic.topic.title">
        <xsl:attribute name="font-family">Sans</xsl:attribute>
		<xsl:attribute name="border-bottom">3pt solid black</xsl:attribute>
        <!--xsl:attribute name="space-before.optimum">15pt</xsl:attribute-->
        <xsl:attribute name="margin-top">1pc</xsl:attribute>
        <xsl:attribute name="margin-bottom">5pt</xsl:attribute>
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="padding-top">1pc</xsl:attribute>
        <!--xsl:attribute name="keep-with-next.within-column">always</xsl:attribute-->
        <xsl:attribute name="page-break-before">always</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="topic.topic.topic.title">
        <xsl:attribute name="font-family">Sans</xsl:attribute>
		<xsl:attribute name="border-bottom">1pt solid black</xsl:attribute>
        <xsl:attribute name="margin-top">1pc</xsl:attribute>
        <xsl:attribute name="margin-bottom">2pt</xsl:attribute>
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <!--xsl:attribute name="keep-with-next.within-column">always</xsl:attribute-->
        <xsl:attribute name="page-break-before">always</xsl:attribute>
    </xsl:attribute-set>

    <!-- add more space above title -->
    <xsl:attribute-set name="section.title">
        <xsl:attribute name="font-family">Sans</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="space-before">15pt</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>
</xsl:stylesheet>
