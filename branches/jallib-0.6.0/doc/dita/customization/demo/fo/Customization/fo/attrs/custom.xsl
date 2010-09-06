<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="1.0">

    <!-- beautify prolog -->
    <xsl:attribute-set name="prolog">
        <xsl:attribute name="start-indent">300pt</xsl:attribute>
        <xsl:attribute name="font-size"><xsl:value-of select="$default-font-size"/></xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <!--
        <xsl:attribute name="border-style">solid</xsl:attribute>
        <xsl:attribute name="border-color">black</xsl:attribute>
        <xsl:attribute name="border-width">thin</xsl:attribute>
        <xsl:attribute name="background-color">#f0f0d0</xsl:attribute>
        -->
        <xsl:attribute name="color">#000037</xsl:attribute>
        <xsl:attribute name="text-align">right</xsl:attribute>
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

    <!-- mini toc within chapters -->
    <xsl:attribute-set name="__toc__mini">
        <xsl:attribute name="font-size">9pt</xsl:attribute>
        <xsl:attribute name="font-family">Sans</xsl:attribute>
        <xsl:attribute name="end-indent">5pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__mini__table__column_1">
        <xsl:attribute name="column-number">1</xsl:attribute>
        <xsl:attribute name="column-width">25%</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__mini__table__column_2">
        <xsl:attribute name="column-number">2</xsl:attribute>
        <xsl:attribute name="column-width">75%</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note__table__column_1">
        <xsl:attribute name="column-number">1</xsl:attribute>
        <xsl:attribute name="column-width">10%</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note__table__column_2">
        <xsl:attribute name="column-number">2</xsl:attribute>
        <xsl:attribute name="column-width">90%</xsl:attribute>
    </xsl:attribute-set>

	<xsl:attribute-set name="fig.title">
		<xsl:attribute name="font-family">Sans</xsl:attribute>
		<xsl:attribute name="font-size">8pt</xsl:attribute>
		<xsl:attribute name="space-before.optimum">5pt</xsl:attribute>
		<xsl:attribute name="space-after.optimum">10pt</xsl:attribute>
		<xsl:attribute name="keep-with-previous.within-page">always</xsl:attribute>
	</xsl:attribute-set>

    <xsl:attribute-set name="fn__body">
        <xsl:attribute name="provisional-distance-between-starts">8mm</xsl:attribute>
        <xsl:attribute name="provisional-label-separation">2mm</xsl:attribute>
        <xsl:attribute name="line-height">1.2</xsl:attribute>
        <xsl:attribute name="font-size">8pt</xsl:attribute>
        <xsl:attribute name="start-indent">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="screen">
        <xsl:attribute name="space-before">1.2em</xsl:attribute>
        <xsl:attribute name="space-after">0.8em</xsl:attribute>
        <xsl:attribute name="white-space-treatment">preserve</xsl:attribute>
        <xsl:attribute name="white-space-collapse">false</xsl:attribute>
        <xsl:attribute name="linefeed-treatment">preserve</xsl:attribute>
        <xsl:attribute name="wrap-option">wrap</xsl:attribute>
        <xsl:attribute name="background-color">#f0f0f0</xsl:attribute>
        <xsl:attribute name="font-family">Monospaced</xsl:attribute>
        <xsl:attribute name="line-height">106%</xsl:attribute>
        <xsl:attribute name="font-size">8pt</xsl:attribute>
    </xsl:attribute-set>

</xsl:stylesheet>
