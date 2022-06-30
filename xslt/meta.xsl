<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>
    <xsl:import href="partials/osd-container.xsl"/>
    <xsl:import href="partials/tei-facsimile.xsl"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select="descendant::tei:titleStmt/tei:title[@level='a'][1]/text()"/>
        </xsl:variable>
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
        <html>
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
            </xsl:call-template>
            
            <body class="page">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    
                    <div class="container-fluid">                        
                        <div class="card">
                            <div class="card-header">
                                <h2 align="center"><xsl:value-of select="$doc_title"/></h2>
                            </div>
                            <div class="card-body-index">                                
                                <xsl:apply-templates select=".//tei:body"></xsl:apply-templates>
                            </div>
                            <xsl:if test="descendant::tei:footNote">
                                <div class="card-body-index">
                                <p/>
                                <xsl:element name="ol">
                                    <xsl:attribute name="class">
                                        <xsl:text>list-for-footnotes-meta</xsl:text>
                                    </xsl:attribute>
                                    <xsl:apply-templates select="descendant::tei:footNote"
                                        mode="footnote"/>
                                </xsl:element>
                                </div>
                            </xsl:if>
                        </div>                       
                    </div>
                    <xsl:call-template name="html_footer"/>
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="tei:p">
        <p id="{generate-id()}"><xsl:apply-templates/></p>
    </xsl:template>
    <xsl:template match="tei:div">
        <div id="{generate-id()}"><xsl:apply-templates/></div>
    </xsl:template>
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    <xsl:template match="tei:unclear">
        <abbr title="unclear"><xsl:apply-templates/></abbr>
    </xsl:template>
    <xsl:template match="tei:del">
        <del><xsl:apply-templates/></del>
    </xsl:template>
    <xsl:template match="tei:table">
        <xsl:element name="table">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="data(@xml:id)"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="class">
                <xsl:text>table</xsl:text>
            </xsl:attribute>
            <xsl:element name="tbody">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:row">
        <xsl:element name="tr">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:cell">
        <xsl:element name="td">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:head[not(@type='sub')]">
        <h2>
            <xsl:apply-templates/>
            </h2>
    </xsl:template>
    <xsl:template match="tei:head[(@type='sub')]">
        <h3>
            <xsl:apply-templates/>
        </h3>
    </xsl:template>
    <xsl:template match="tei:footNote">
        <xsl:if test="preceding-sibling::*[1][name() = 'footNote']">
            <!-- Sonderregel für zwei Fußnoten in Folge -->
            <sup>
                <xsl:text>,</xsl:text>
            </sup>
        </xsl:if>
        <xsl:element name="a">
            <xsl:attribute name="class">
                <xsl:text>reference-black</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:text>#footnote</xsl:text>
                <xsl:number level="any" count="tei:footNote" format="1"/>
            </xsl:attribute>
            <sup>
                <xsl:number level="any" count="tei:footNote" format="1"/>
            </sup>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:footNote" mode="footnote">
        <xsl:element name="li">
            <xsl:attribute name="id">
                <xsl:text>footnote</xsl:text>
                <xsl:number level="any" count="tei:footNote" format="1"/>
            </xsl:attribute>
            <sup>
                <xsl:number level="any" count="tei:footNote" format="1"/>
            </sup>
            <xsl:text> </xsl:text>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:rs[@type='work']/text()">
        <i><xsl:value-of select="."/></i>
    </xsl:template>
    <xsl:template match="tei:supplied">
        <xsl:text>[</xsl:text><xsl:value-of select="."/><xsl:text>]</xsl:text>
    </xsl:template>
    <xsl:template match="tei:ptr">
        <xsl:variable name="targett">
            <xsl:choose>
                <xsl:when
                    test="starts-with(@target, 'D041') or starts-with(@target, 'L041') or starts-with(@target, 'T03') or starts-with(@target, 'I041')">
                    <xsl:value-of select="concat(@target, '.html')"/>
                </xsl:when>
                <xsl:when test="starts-with(@target, 'LD')">
                    <xsl:variable name="dateiname"
                        select="substring-before(substring(@target, 3), '-')"/>
                    <xsl:value-of select="concat('D041', $dateiname, '.html/#', @target)"/>
                </xsl:when>
                <xsl:when test="starts-with(@target, 'LL')">
                    <xsl:variable name="dateiname"
                        select="substring-before(substring(@target, 3), '-')"/>
                    <xsl:value-of select="concat('L041', $dateiname, '.html/#', @target)"/>
                </xsl:when>
                <xsl:when test="starts-with(@target, 'LI')">
                    <xsl:variable name="dateiname"
                        select="substring-before(substring(@target, 3), '-')"/>
                    <xsl:value-of select="concat('I041', $dateiname, '.html/#', @target)"/>
                </xsl:when>
                <xsl:when test="starts-with(@target, 'LT')">
                    <xsl:variable name="dateiname"
                        select="substring-before(substring(@target, 3), '-')"/>
                    <xsl:value-of select="concat('T003', $dateiname, '.html/#', @target)"/>
                </xsl:when>
                <xsl:when test="starts-with(@target, 'KD')">
                    <xsl:variable name="dateiname"
                        select="substring-before(substring(@target, 3), '-')"/>
                    <xsl:value-of select="concat('D041', $dateiname, '.html/#bottom')"/>
                </xsl:when>
                <xsl:when test="starts-with(@target, 'KK')">
                    <xsl:variable name="dateiname"
                        select="substring-before(substring(@target, 3), '-')"/>
                    <xsl:value-of select="concat('L041', $dateiname, '.html/#bottom')"/>
                </xsl:when>
                <xsl:when test="starts-with(@target, 'KI')">
                    <xsl:variable name="dateiname"
                        select="substring-before(substring(@target, 3), '-')"/>
                    <xsl:value-of select="concat('I041', $dateiname, '.html/#bottom')"/>
                </xsl:when>
                <xsl:when test="starts-with(@target, 'KT')">
                    <xsl:variable name="dateiname"
                        select="substring-before(substring(@target, 3), '-')"/>
                    <xsl:value-of select="concat('T003', $dateiname, '.html/#bottom')"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <a href="{$targett}" class="fas fa-link"/>
    </xsl:template>
    <xsl:template match="tei:list[@type='simple-gloss']">
        <ul class="list list_simple-gloss">
            <xsl:variable name="listinhalt" select="." as="node()"/>
            <xsl:for-each select="child::tei:label">
                <xsl:variable name="postion" select="position()"/>
                <li>
                    <span class="tei_label"><xsl:apply-templates/></span>
                    <span class="item"><xsl:apply-templates select="$listinhalt/tei:item[$postion]"/></span>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>
    
    <xsl:template match="tei:label[parent::tei:list[@type='simple-gloss']]">
        <li>
            <span class="list_simple-gloss">
                <xsl:apply-templates/></span>
        </li>
    </xsl:template>
    <xsl:template match="tei:item[parent::tei:list[@type='simple-gloss']]">
        <li>
            <span class="list_simple-gloss">
                <xsl:apply-templates/></span>
        </li>
    </xsl:template>
    


</xsl:stylesheet>