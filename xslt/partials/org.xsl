<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mam="whatever"
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:template match="tei:org" name="org_detail">
        <xsl:param name="showNumberOfMentions" as="xs:integer" select="50000"/>
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <div class="card-body-tagebuch w-75">
            <xsl:variable name="ersterName" select="tei:orgName[1]"/>
            <xsl:if test="tei:orgName[2]">
                <p>
                    <xsl:for-each select="distinct-values(tei:orgName[@type = 'alternative-name'])">
                        <xsl:if test=". != $ersterName">
                            <xsl:value-of select="."/>
                        </xsl:if>
                        <xsl:if test="not(position() = last())">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </p>
            </xsl:if>
            <xsl:if test="tei:location">
                <div>
                    <p>
                        <xsl:for-each select="distinct-values(tei:location/tei:placeName[1])">
                            <xsl:value-of select="."/>
                            <xsl:if test="not(position() = last())">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </p>
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
                                        select="concat('https://pmb.acdh.oeaw.ac.at/apis/entities/entity/institution/', $pmb-path-ende)"
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
            <div id="mentions" class="mt-2"><span class="infodesc mr-2">
                <legend>Erwähnungen</legend>
                <ul>
                    <xsl:for-each select=".//tei:note[@type='mentions']">
                        <xsl:variable name="linkToDocument">
                            <xsl:value-of
                                select="replace(tokenize(data(.//@target), '/')[last()], '.xml', '.html')"
                            />
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="position() lt $showNumberOfMentions + 1">
                                <li>
                                    <xsl:value-of select="."/>
                                    <xsl:text> </xsl:text>
                                    <a href="{$linkToDocument}">
                                        <i class="fas fa-external-link-alt"/>
                                    </a>
                                </li>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                </ul>
                <xsl:if test="count(.//tei:note[@type='mentions']) gt $showNumberOfMentions + 1">
                    <p>Anzahl der Erwähnungen limitiert, klicke <a href="{$selfLink}">hier</a> für
                        eine vollständige Auflistung</p>
                </xsl:if></span>
            </div>
        </div>
    </xsl:template>
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
