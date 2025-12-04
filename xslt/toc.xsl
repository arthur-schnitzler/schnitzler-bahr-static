<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes"/>

    <xsl:import href="./partials/params.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Inhaltsverzeichnis'"/>
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
            </xsl:call-template>
            
            <body class="page">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    
                    <div class="container-fluid">
                        <div class="card">
                            <div class="card-header">
                                <h1>Inhaltsverzeichnis</h1>
                            </div>
                            <div class="card-body">
                                <table class="table table-striped display" id="tocTable" style="width:100%">
                                    <thead>
                                        <tr>
                                            <th scope="col">Titel</th>
                                            <th scope="col">Typ</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <xsl:for-each select="collection('../data/editions/?select=*.xml')/tei:TEI">
                                            <xsl:variable name="full_path">
                                                <xsl:value-of select="document-uri(/)"/>
                                            </xsl:variable>
                                            <tr>
                                                <td>
                                                    <sortdate hidden="true">
                                                    <xsl:value-of select="descendant::tei:titleStmt/tei:title[@type='iso-date']/text()"/>
                                                    </sortdate>
                                                    <a>
                                                        <xsl:attribute name="href">                                                
                                                            <xsl:value-of select="replace(tokenize($full_path, '/')[last()], '.xml', '.html')"/>
                                                        </xsl:attribute>
                                                        <xsl:value-of select="descendant::tei:titleStmt/tei:title[@level='a'][1]/text()"/>
                                                    </a>
                                                </td>
                                                <td>
                                                    <xsl:variable name="typityp" select="substring(tokenize($full_path, '/')[last()],1,1)"/>
                                                    <xsl:choose>
                                                        <xsl:when test="$typityp='D'">
                                                            <xsl:text>Tagebuch</xsl:text>
                                                        </xsl:when>
                                                        <xsl:when test="$typityp='L'">
                                                            <xsl:text>Brief</xsl:text>
                                                        </xsl:when>
                                                        <xsl:when test="$typityp='T'">
                                                            <xsl:text>Text</xsl:text>
                                                        </xsl:when>
                                                        <xsl:when test="$typityp='I'">
                                                            <xsl:text>Bild</xsl:text>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="tokenize($full_path, '/')[last()]"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </td>  
                                            </tr>
                                        </xsl:for-each>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    
                    <xsl:call-template name="html_footer"/>
                    <script>
                        $(document).ready(function () {
                        createDataTable('tocTable')
                        });
                    </script>
                </div>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="tei:div//tei:head">
        <h2 id="{generate-id()}"><xsl:apply-templates/></h2>
    </xsl:template>
    
    <xsl:template match="tei:p">
        <p id="{generate-id()}"><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="tei:list">
        <ul id="{generate-id()}"><xsl:apply-templates/></ul>
    </xsl:template>
    
    <xsl:template match="tei:item">
        <li id="{generate-id()}"><xsl:apply-templates/></li>
    </xsl:template>
    <xsl:template match="tei:ref">
        <xsl:choose>
            <xsl:when test="starts-with(data(@target), 'http')">
                <a>
                    <xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
                    <xsl:value-of select="."/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>