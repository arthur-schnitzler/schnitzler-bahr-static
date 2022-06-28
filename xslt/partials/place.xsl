<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mam="whatever"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:template match="tei:place" name="place_detail">
        <xsl:param name="showNumberOfMentions" as="xs:integer" select="50000"/>
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <div class="container-fluid">
        <div class="card-body">
            <xsl:if test="count(.//tei:placeName) gt 1">
                <small>Namensvarianten:</small>
                <ul>
                    <xsl:for-each select=".//tei:placeName[@type = 'alternative-name']">
                        <li>
                            <xsl:value-of select="./text()"/>
                        </li>
                    </xsl:for-each>
                </ul>
            </xsl:if>
            <xsl:if test="count(.//tei:idno) gt 0">
                <small>Normdaten IDs</small>
                <ul>
                    <xsl:for-each select=".//tei:idno">
                        <xsl:if test="./@type">
                            <li>
                                <small><xsl:value-of select="data(./@type)"/>:</small>
                                <xsl:text> </xsl:text>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="./text()"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="./text()"/>
                                </a>
                            </li>
                        </xsl:if>
                    </xsl:for-each>
                </ul>
            </xsl:if>
            <xsl:if test=".//tei:geo/text()">
                
                <div id="mapid" style="height: 400px; width:100%; clear: both;"/>
                <link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css"
                    integrity="sha512-xodZBNTC5n17Xt2atTPuE1HxjVMSvLVW9ocqUKLsCC5CXdbqCmblAshOMAS6/keqq/sMZMZ19scR4PsZChSR7A=="
                    crossorigin=""/>
                <script src="https://unpkg.com/leaflet@1.7.1/dist/leaflet.js" integrity="sha512-XQoYMqMTK8LvdxXYG3nZ448hOEQiglfqkJs1NOQV44cWnUrBc8PkAOcXy20w0vlaXaVUearIOBhiXZ5V3ynxwA==" crossorigin=""/>
                <script>
                                                    
                                                    var mymap = L.map('mapid').setView([50, 12], 5);
                                                    
                                                    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                                                    attribution: 'Map data &amp;copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="https://www.openstreetmap.org/">OpenStreetMap</a>',
                                                    maxZoom: 18,
                                                    zIndex: 1
                                                    }).addTo(mymap);
                                                    <xsl:variable name="laenge" as="xs:string" select="replace(tokenize(descendant::tei:geo[1]/text(), ' ')[1], ',', '.')"/>
                                                    <xsl:variable name="breite" as="xs:string" select="replace(tokenize(descendant::tei:geo[1]/text(), ' ')[2], ',', '.')"/>
                                                        <xsl:variable name="laengebreite" as="xs:string" select="concat($laenge, ', ', $breite)"/>
                                                        <xsl:value-of select="$laengebreite"/>
                                                        L.marker([<xsl:value-of select="$laengebreite"/>]).addTo(mymap)
                                                        .bindPopup("<b>
                                                            <xsl:value-of select="./tei:placeName[1]/text()"/>
                                                        </b>").openPopup();
                                                </script>
                
                <div class="card">
                <p>
                <xsl:value-of select=".//tei:geo/text()"/></p>
                </div>
            </xsl:if>
            <div id="mentions">
                <p class="buttonreihe">
                    <xsl:for-each
                        select="child::tei:idno[not(@type = 'schnitzler-bahr') and not(@type = 'gnd') and not(@type = 'pmb')]">
                        <span class="button">
                            <xsl:choose>
                                <xsl:when test="not(. = '')">
                                    <span>
                                        <xsl:element name="a">
                                            <xsl:attribute name="class">
                                                <xsl:choose>
                                                    <xsl:when test="@type = 'schnitzler-tagebuch'">
                                                        <xsl:text>tagebuch-button</xsl:text>
                                                    </xsl:when>
                                                    <xsl:when test="@type = 'gnd'">
                                                        <xsl:text>wikipedia-button</xsl:text>
                                                    </xsl:when>
                                                    <xsl:when test="@type = 'schnitzler-briefe'">
                                                        <xsl:text>briefe-button</xsl:text>
                                                    </xsl:when>
                                                    <xsl:when test="@type = 'schnitzler-lektueren'">
                                                        <xsl:text>leseliste-button</xsl:text>
                                                    </xsl:when>
                                                    <xsl:when test="@type = 'schnitzler-bahr'">
                                                        <xsl:text>bahr-button</xsl:text>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="@type"/>
                                                        <xsl:text>XXXX</xsl:text>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:attribute>
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="."/>
                                            </xsl:attribute>
                                            <xsl:attribute name="target">
                                                <xsl:text>_blank</xsl:text>
                                            </xsl:attribute>
                                            <xsl:element name="span">
                                                <xsl:attribute name="class">
                                                    <xsl:value-of select="concat('color-', @type)"/>
                                                </xsl:attribute>
                                                <xsl:value-of select="mam:ahref-namen(@type)"/>
                                            </xsl:element>
                                        </xsl:element>
                                    </span>
                                    <xsl:text> </xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="span">
                                        <xsl:attribute name="class">
                                            <xsl:text>color-inactive</xsl:text>
                                        </xsl:attribute>
                                        <xsl:value-of select="mam:ahref-namen(@type)"/>
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:if test="position() = last()">
                                <xsl:text> </xsl:text>
                            </xsl:if>
                        </span>
                    </xsl:for-each>
                    <xsl:if test="child::tei:idno[@type = 'pmb']">
                        <span class="button">
                            <xsl:element name="a">
                                <xsl:attribute name="class">
                                    <xsl:text>PMB-button</xsl:text>
                                </xsl:attribute>
                                <xsl:variable name="pmb-path-ende"
                                    select="concat(substring-after(child::tei:idno[@type = 'pmb'][1], 'https://pmb.acdh.oeaw.ac.at/entity/'), '/detail')"/>
                                <xsl:attribute name="href">
                                    <xsl:value-of
                                        select="concat('https://pmb.acdh.oeaw.ac.at/apis/entities/entity/person/', $pmb-path-ende)"
                                    />
                                </xsl:attribute>
                                <xsl:attribute name="target">
                                    <xsl:text>_blank</xsl:text>
                                </xsl:attribute>
                                <xsl:element name="span">
                                    <xsl:attribute name="class">
                                        <xsl:text>color-PMB</xsl:text>
                                    </xsl:attribute>
                                    <xsl:text>PMB</xsl:text>
                                </xsl:element>
                            </xsl:element>
                        </span>
                    </xsl:if>
                    <xsl:if test="child::tei:idno[@type = 'gnd']">
                        <xsl:text> </xsl:text>
                        <span class="button">
                            <xsl:element name="a">
                                <xsl:attribute name="class">
                                    <xsl:text>wikipedia-button</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="href">
                                    <xsl:value-of
                                        select="replace(child::tei:idno[@type = 'gnd'], 'https://d-nb.info/gnd/', 'http://tools.wmflabs.org/persondata/redirect/gnd/de/')"
                                    />
                                </xsl:attribute>
                                <xsl:attribute name="target">
                                    <xsl:text>_blank</xsl:text>
                                </xsl:attribute>
                                <xsl:element name="span">
                                    <xsl:attribute name="class">
                                        <xsl:text>wikipedia-color</xsl:text>
                                    </xsl:attribute>
                                    <xsl:value-of select="mam:ahref-namen('gnd')"/>
                                </xsl:element>
                            </xsl:element>
                        </span>
                    </xsl:if>
                </p>
            </div>
            

            <hr/>
            <div id="mentions">
                <h3>Erwähnungen</h3>
                <ul>
                    <xsl:for-each select=".//tei:event">
                        <xsl:variable name="linkToDocument">
                            <xsl:value-of
                                select="replace(tokenize(data(.//@target), '/')[last()], '.xml', '.html')"
                            />
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="position() lt $showNumberOfMentions + 1">
                                <li>
                                    <xsl:value-of select=".//tei:title"/>
                                    <xsl:text> </xsl:text>
                                    <a href="{$linkToDocument}">
                                        <i class="fas fa-external-link-alt"/>
                                    </a>
                                </li>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                </ul>
                <xsl:if test="count(.//tei:event) gt $showNumberOfMentions + 1">
                    <p>Anzahl der Erwähnungen limitiert, klicke <a href="{$selfLink}">hier</a> für
                        eine vollständige Auflistung</p>
                </xsl:if>
            </div>
        </div>
        </div>
    </xsl:template>
    
    <xsl:function name="mam:pmbChange">
        <xsl:param name="url" as="xs:string"/>
        <xsl:param name="entitytyp" as="xs:string"/>
        <xsl:value-of select="
            concat('https://pmb.acdh.oeaw.ac.at/apis/entities/entity/', $entitytyp, '/',
            substring-after($url, 'https://pmb.acdh.oeaw.ac.at/entity/'), '/detail')"/>
    </xsl:function>
    <xsl:function name="mam:ahref-namen">
        <xsl:param name="typityp" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="$typityp = 'schnitzler-tagebuch'">
                <xsl:text> Tagebuch</xsl:text>
            </xsl:when>
            <xsl:when test="$typityp = 'schnitzler-briefe'">
                <xsl:text> Briefe</xsl:text>
            </xsl:when>
            <xsl:when test="$typityp = 'schnitzler-lektueren'">
                <xsl:text> Lektüren</xsl:text>
            </xsl:when>
            <xsl:when test="$typityp = 'PMB'">
                <xsl:text> PMB</xsl:text>
            </xsl:when>
            <xsl:when test="$typityp = 'pmb'">
                <xsl:text> PMB</xsl:text>
            </xsl:when>
            <xsl:when test="$typityp = 'briefe_i'">
                <xsl:text> Briefe 1875–1912</xsl:text>
            </xsl:when>
            <xsl:when test="$typityp = 'briefe_ii'">
                <xsl:text> Briefe 1913–1931</xsl:text>
            </xsl:when>
            <xsl:when test="$typityp = 'DLAwidmund'">
                <xsl:text> Widmungsexemplar Deutsches Literaturarchiv</xsl:text>
            </xsl:when>
            <xsl:when test="$typityp = 'jugend-in-wien'">
                <xsl:text> Jugend in Wien</xsl:text>
            </xsl:when>
            <xsl:when test="$typityp = 'gnd'">
                <xsl:text> Wikipedia?</xsl:text>
            </xsl:when>
            <xsl:when test="$typityp = 'schnitzler-bahr'">
                <xsl:text> Bahr/Schnitzler</xsl:text>
            </xsl:when>
            <xsl:when test="$typityp = 'widmungDLA'">
                <xsl:text> Widmung DLA</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$typityp"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
</xsl:stylesheet>
