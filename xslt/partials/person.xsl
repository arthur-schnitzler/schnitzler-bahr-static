<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:mam="personalShit" version="2.0" xmlns:df="http://example.com/df"
    exclude-result-prefixes="xsl tei xs">
    <xsl:import href="germandate.xsl"/>
    <xsl:param name="works" select="document('../../data/indices/listwork.xml')"/>
    <xsl:key name="authorwork-lookup" match="tei:bibl"
        use="tei:author/@ref"/>
    <xsl:template match="tei:person" name="person_detail">
        <xsl:param name="showNumberOfMentions" as="xs:integer" select="50000"/>
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <div class="card-body-index">
            <xsl:for-each select="tei:persName[not(position() = 1)]">
                <p class="personenname">
                    <xsl:choose>
                        <xsl:when test="./tei:forename/text() and ./tei:surname/text()">
                            <xsl:value-of
                                select="concat(./tei:forename/text(), ' ', ./tei:surname/text())"/>
                        </xsl:when>
                        <xsl:when test="./tei:forename/text()">
                            <xsl:value-of select="./tei:forename/text()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="./tei:surname/text()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </p>
            </xsl:for-each>
            <xsl:if test=".//tei:occupation">
                <xsl:variable name="entity" select="."/>
                <p>
                    <xsl:if test="$entity/descendant::tei:occupation">
                        <xsl:for-each
                            select="$entity/descendant::tei:occupation">
                            <xsl:variable name="beruf" as="xs:string">
                                <xsl:choose>
                                    <xsl:when test="contains(.,'&gt;&gt;')">
                                        <xsl:value-of select="tokenize(.,'&gt;&gt;')[last()]"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="."/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:choose>
                                <xsl:when test="$entity/tei:sex/@value = 'male'">
                                    <xsl:value-of select="tokenize($beruf, '/')[1]"/>
                                </xsl:when>
                                <xsl:when test="$entity/tei:sex/@value = 'female'">
                                    <xsl:value-of select="tokenize($beruf, '/')[2]"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$beruf"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:if test="not(position() = last())">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:if>
                </p>
            </xsl:if>
            <div id="mentions">
                <p class="buttonreihe">
                    <xsl:for-each
                        select="child::tei:idno[not(@type='schnitzler-bahr' or @type='gnd' or @type='pmb' or @type='bahrschnitzler')]">
                        <span class="button">
                            <xsl:choose>
                                <xsl:when test="not(@type = '')">
                                    <span>
                                        <xsl:element name="a">
                                            <xsl:attribute name="class">
                                                    <xsl:choose>
                                                        <xsl:when test="(@type= 'schnitzler-tagebuch')">
                                                            <xsl:text>tagebuch-button</xsl:text>
                                                        </xsl:when>
                                                        <xsl:when test="(@type= 'gnd')">
                                                            <xsl:text>wikipedia-button</xsl:text>
                                                        </xsl:when>
                                                        <xsl:when test="(@type= 'schnitzler-briefe')">
                                                            <xsl:text>briefe-button</xsl:text>
                                                        </xsl:when>
                                                        <xsl:when test="(@type=  'schnitzler-lektueren')">
                                                            <xsl:text>leseliste-button</xsl:text>
                                                        </xsl:when>
                                                        <xsl:when test="(@type= 'schnitzler-bahr')">
                                                            <xsl:text>bahr-button</xsl:text>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="substring-after(., '//')"/>
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
                    <xsl:if test="child::tei:idno[@type = 'gnd'][1]">
                        <xsl:text> </xsl:text>
                        <span class="button">
                            <xsl:element name="a">
                                <xsl:attribute name="class">
                                    <xsl:text>wikipedia-button</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="href">
                                    <xsl:value-of
                                        select="replace(child::tei:idno[@type = 'gnd'][1], 'https://d-nb.info/gnd/', 'http://tools.wmflabs.org/persondata/redirect/gnd/de/')"
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
            <div class="werke">
                <xsl:variable name="author-ref" select="@xml:id"/>
                <xsl:value-of select="$author-ref"/>
                <xsl:if
                    test="key('authorwork-lookup', $author-ref, $works)[1]">
                    <h2>Erwähnte Werke</h2>
                </xsl:if>
                <p/>
                <ul class="dashed">
                    <xsl:for-each
                        select="key('authorwork-lookup', $author-ref, $works)">
                        <li>
                            <xsl:if
                                test="@role = 'editor' or @role = 'hat-herausgegeben'">
                                <xsl:text> (Herausgabe)</xsl:text>
                            </xsl:if>
                            <xsl:if
                                test="@role = 'translator' or @role = 'hat-ubersetzt'">
                                <xsl:text> (Übersetzung)</xsl:text>
                            </xsl:if>
                            <xsl:if
                                test="@role = 'illustrator' or @role = 'hat-illustriert'">
                                <xsl:text> (Illustration)</xsl:text>
                            </xsl:if>
                            <xsl:choose>
                                <xsl:when test="tei:author[2]">
                                    <xsl:text>(mit </xsl:text>
                                    <xsl:for-each select="tei:author[not(@ref = $author-ref)]">
                                        <xsl:choose>
                                            <xsl:when
                                                test="tei:persName/tei:forename and tei:persName/tei:surname">
                                                <xsl:value-of select="tei:persName/tei:forename"/>
                                                <xsl:text> </xsl:text>
                                                <xsl:value-of select="tei:persName/tei:surname"/>
                                            </xsl:when>
                                            <xsl:when test="tei:persName/tei:surname">
                                                <xsl:value-of select="tei:persName/tei:surname"/>
                                            </xsl:when>
                                            <xsl:when test="tei:persName/tei:forename">
                                                <xsl:value-of select="tei:persName/tei:forename"/>"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="."/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:if
                                            test="@role = 'editor' or @role = 'hat-herausgegeben'">
                                            <xsl:text> [Herausgabe]</xsl:text>
                                        </xsl:if>
                                        <xsl:if
                                            test="@role = 'translator' or @role = 'hat-ubersetzt'">
                                            <xsl:text> [Übersetzung]</xsl:text>
                                        </xsl:if>
                                        <xsl:if
                                            test="@role = 'illustrator' or @role = 'hat-illustriert'">
                                            <xsl:text> [Illustration]</xsl:text>
                                        </xsl:if>
                                        <xsl:choose>
                                            <xsl:when test="position() = last()">
                                                <xsl:text>: </xsl:text>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:text>, </xsl:text>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each>
                                    <xsl:text>) </xsl:text>
                                </xsl:when>
                            </xsl:choose>
                           <xsl:element name="a">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="concat(@xml:id, '.html')"/>
                                </xsl:attribute>
                                <xsl:value-of select="normalize-space(tei:title[1])"/>
                            </xsl:element>
                            <xsl:if test="tei:date">
                                <xsl:text>, </xsl:text>
                                <xsl:value-of select="tei:date"/>
                                <xsl:if test="not(ends-with(tei:date, '.'))">
                                    <xsl:text>.</xsl:text>
                                </xsl:if>
                            </xsl:if>
                        </li>
                    </xsl:for-each>
                </ul>
            </div>
            <div id="mentions">
                <legend>Erwähnungen</legend>
                <ul>
                    <xsl:for-each select=".//tei:event">
                        <xsl:variable name="linkToDocument">
                            <xsl:value-of select="replace(tokenize(data(.//@target), '/')[last()], '.xml', '.html')"/>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="position() lt $showNumberOfMentions + 1">
                                <li>
                                    <xsl:value-of select=".//tei:title"/><xsl:text> </xsl:text>
                                    <a href="{$linkToDocument}">
                                        <i class="fas fa-external-link-alt"></i>
                                    </a>
                                </li>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                </ul>
                <xsl:if test="count(.//tei:event) gt $showNumberOfMentions + 1">
                    <p>Anzahl der Erwähnungen limitiert, klicke <a href="{$selfLink}">hier</a> für eine vollständige Auflistung</p>
                </xsl:if>
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
    <xsl:template match="tei:supplied">
        <xsl:text>[</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>]</xsl:text>
    </xsl:template>
</xsl:stylesheet>
