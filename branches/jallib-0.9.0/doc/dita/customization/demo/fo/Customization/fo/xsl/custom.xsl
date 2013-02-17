<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="1.1">

    <!-- Remove text on links "on page XX" -->
    <xsl:template name="insertPageNumberCitation">
        <xsl:param name="isTitleEmpty"/>
        <xsl:param name="destination"/>
        <xsl:param name="element"/>

        <xsl:choose>
            <xsl:when test="not($element) or ($destination = '')"/>
            <xsl:when test="$isTitleEmpty">
                <fo:inline>
                    <xsl:call-template name="insertVariable">
                        <xsl:with-param name="theVariableID" select="'Page'"/>
                        <xsl:with-param name="theParameters">
                            <pagenum>
                                <fo:inline>
                                    <fo:page-number-citation ref-id="{$destination}"/>
                                </fo:inline>
                            </pagenum>
                        </xsl:with-param>
                    </xsl:call-template>
                </fo:inline>
            </xsl:when>
            <!-- following tutorial on customization, removing "on page XX"
            <xsl:otherwise>
                <fo:inline>
                    <xsl:call-template name="insertVariable">
                        <xsl:with-param name="theVariableID" select="'On the page'"/>
                        <xsl:with-param name="theParameters">
                            <pagenum>
                                <fo:inline>
                                    <fo:page-number-citation ref-id="{$destination}"/>
                                </fo:inline>
                            </pagenum>
                        </xsl:with-param>
                    </xsl:call-template>
                </fo:inline>
            </xsl:otherwise>
            -->
        </xsl:choose>
    </xsl:template>


    <!-- print authorship at each beginning of topic -->
    <xsl:template match="*[contains(@class,' topic/prolog ')]">
        <fo:block xsl:use-attribute-sets="prolog">
            <xsl:apply-templates/>
        </fo:block>
        <!--xsl:copy-of select="node()"/-->
        <!-- edited by William on 2009-07-02 for indexterm bug:2815485 start -->
        <!--xsl:apply-templates select="descendant::opentopic-index:index.entry[not(parent::opentopic-index:index.entry)]"/-->
        <!-- edited by William on 2009-07-02 for indexterm bug:2815485 end -->
    </xsl:template>

    <!-- This template is commented in DITA-OT 1.5 M21. Uncommenting it
         makes appear book summary, owner, ... on front page.
         I don't know how...
    -->
    <xsl:template match="*[contains(@class, ' topic/data ')]">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- adjust note width -->
    <xsl:template match="*[contains(@class,' topic/note ')]">
        <xsl:variable name="noteType">
            <xsl:choose>
                <xsl:when test="@type">
                    <xsl:value-of select="@type"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'note'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="noteImagePath">
            <xsl:call-template name="insertVariable">
                <xsl:with-param name="theVariableID" select="concat($noteType, ' Note Image Path')"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="not($noteImagePath = '')">
                <fo:table xsl:use-attribute-sets="note__table">

                    <!-- Seb: this is here... -->
                    <fo:table-column xsl:use-attribute-sets="note__table__column_1"/>
                    <fo:table-column xsl:use-attribute-sets="note__table__column_2"/>

                    <fo:table-body>
                        <fo:table-row>
                                <fo:table-cell xsl:use-attribute-sets="note__image__entry">
                                    <fo:block>
                                        <fo:external-graphic src="url({concat($artworkPrefix, $noteImagePath)})" xsl:use-attribute-sets="image" content-width="21"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell xsl:use-attribute-sets="note__text__entry">
                                    <xsl:call-template name="placeNoteContent"/>
                                </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="placeNoteContent"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="placeImage">
        <xsl:param name="imageAlign"/>
        <xsl:param name="href"/>
        <xsl:param name="height"/>
        <xsl:param name="width"/>
<!--Using align attribute set according to image @align attribute-->
        <xsl:call-template name="processAttrSetReflection">
                <xsl:with-param name="attrSet" select="concat('__align__', $imageAlign)"/>
                <xsl:with-param name="path" select="'../../cfg/fo/attrs/commons-attr.xsl'"/>
            </xsl:call-template>
        <fo:external-graphic src="url({$href})" xsl:use-attribute-sets="image">
            <!--Setting image height if defined-->
            <xsl:if test="$height">
                <xsl:attribute name="content-height">
                <!--The following test was commented out because most people found the behavior
                 surprising.  It used to force images with a number specified for the dimensions
                 *but no units* to act as a measure of pixels, *if* you were printing at 72 DPI.
                 Uncomment if you really want it. -->
                    <!--<xsl:choose>
                        <xsl:when test="not(string(number($height)) = 'NaN')">
                            <xsl:value-of select="concat($height div 72,'in')"/>
                        </xsl:when>
                        <xsl:when test="$height">-->
                            <xsl:value-of select="$height div 1.53"/>
                        <!--</xsl:when>
                    </xsl:choose>-->
                </xsl:attribute>
            </xsl:if>
            <!--Setting image width if defined-->
            <xsl:if test="$width">
                <xsl:attribute name="content-width">
                    <!--<xsl:choose>
                        <xsl:when test="not(string(number($width)) = 'NaN')">
                            <xsl:value-of select="concat($width div 72,'in')"/>
                        </xsl:when>
                        <xsl:when test="$width">-->
                            <xsl:value-of select="$width div 1.53"/>
                        <!--</xsl:when>
                    </xsl:choose>-->
                </xsl:attribute>
            </xsl:if>
        </fo:external-graphic>
    </xsl:template>


</xsl:stylesheet>
