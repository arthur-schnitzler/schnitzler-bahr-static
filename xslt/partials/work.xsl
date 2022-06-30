<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:df="http://example.com/df"
    xmlns:mam="personalShit"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:import href="germandate.xsl"/>
    <xsl:param name="works"
        select="document('../../data/indices/listwork.xml')"/>
    <xsl:key name="work-lookup" match="tei:bibl" use="tei:relatedItem/@target"/>
    <xsl:template match="tei:bibl" name="work_detail">
        <xsl:param name="showNumberOfMentions" as="xs:integer" select="50000"/>
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <div class="card-body-tagebuch w-75">
            <div class="mt-2">
                <xsl:if test="tei:date">
                    <p><xsl:text>Erschienen: </xsl:text>
                    <xsl:value-of select="mam:normalize-date(tei:date)"/>
                    <xsl:if test="not(ends-with(tei:date[1], '.'))">
                        <xsl:text>.</xsl:text>
                    </xsl:if></p>
                </xsl:if>
                <span>
                    <xsl:for-each select="tei:author">
                        <xsl:variable name="autor-ref" select="@ref"/>
                        <xsl:choose>
                            <xsl:when test="$autor-ref='pmb2121'">
                                <a href="pmb2121.html"><xsl:text>Arthur Schnitzler</xsl:text></a>
                            </xsl:when>
                            <xsl:otherwise>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="concat($autor-ref,'.html')"/>
                                    </xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when test="child::tei:forename and child::tei:surname ">
                                            <xsl:value-of select="tei:persName/tei:forename"/><xsl:text> </xsl:text><xsl:value-of select="tei:persName/tei:surname"/>
                                        </xsl:when>
                                        <xsl:when test="child::tei:surname">
                                            <xsl:value-of select="child::tei:surname"/>
                                        </xsl:when>
                                        <xsl:when test="child::tei:forename">
                                            <xsl:value-of select="child::tei:forename"/>"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="."/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </a>
                                <xsl:if test="@role='editor'">
                                    <xsl:text> (Herausgabe)</xsl:text>
                                </xsl:if>
                                <xsl:if test="@role='translator'">
                                    <xsl:text> (Übersetzung)</xsl:text>
                                </xsl:if>
                                <xsl:if test="@role='illustrator'">
                                    <xsl:text> (Illustration)</xsl:text>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text> </xsl:text>
                        <xsl:if test="not(position() = last())">
                           <br/>
                        </xsl:if>
                    </xsl:for-each>
                </span>
            </div>
            <p/>
            <div>
                
                <xsl:for-each select="child::tei:idno[not(@type = 'schnitzler-bahr') and not(@type='pmb')]">
                    <xsl:text> </xsl:text>
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
                                            <xsl:when test="@type = 'bahrschnitzler'">
                                                <xsl:text>bahr-button</xsl:text>
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
                </xsl:for-each>
                <xsl:if test="starts-with(@xml:id, 'pmb')">
                    <xsl:text> </xsl:text>
                    <xsl:element name="a">
                        <xsl:attribute name="class">
                                    <xsl:text>pmb-button</xsl:text>
                        </xsl:attribute>
                    <xsl:attribute name="href">
                                <xsl:value-of
                                    select="concat('https://pmb.acdh.oeaw.ac.at/apis/entities/entity/work/', substring-after(@xml:id, 'pmb'), '/detail')"
                                />
                    </xsl:attribute>
                        <xsl:element name="span">
                            <xsl:attribute name="class">
                                <xsl:text>color-pmb</xsl:text>
                            </xsl:attribute>
                            <xsl:value-of select="mam:ahref-namen('pmb')"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:if>
            </div>
            <xsl:if test="tei:title/@type='bibliografische_angabe'">
                <div>
                    <p><xsl:value-of select="tei:title/@type='bibliografische_angabe'"/></p>
                </div>
            </xsl:if>
            <xsl:if test="tei:title/@type='uri_worklink'">
                <div>
                    <p><xsl:value-of select="tei:title/@type='uri_worklink'"/></p>
                </div>
            </xsl:if>
            <xsl:if test="tei:title/@type='uri_anno'">
                <div>
                    <p><xsl:value-of select="tei:title/@type='uri_anno'"/></p>
                </div>
            </xsl:if>
            <div id="mentions" class="mt-2">
                <span class="infodesc mr-2">Erwähnt am</span>
                
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
            <xsl:when test="$typityp = 'schnitzler-lektueren'">
                <xsl:text> Lektüren</xsl:text>
            </xsl:when>
            <xsl:when test="$typityp = 'schnitzler-briefe'">
                <xsl:text> Briefe</xsl:text>
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
            <xsl:when test="$typityp = 'bahrschnitzler'">
                <xsl:text> Bahr/Schnitzler</xsl:text>
            </xsl:when>
            <xsl:when test="$typityp = 'schnitzler-bahr'">
                <xsl:text> Bahr/Schnitzler</xsl:text>
            </xsl:when>
            <xsl:when test="$typityp = 'schnitzler-tagebuch'">
                <xsl:text> Tagebuch</xsl:text>
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
    
    <xsl:function name="mam:normalize-date">
        <xsl:param name="date-string-mit-spitze" as="xs:string?"/>
        <xsl:variable name="date-string" as="xs:string">
            <xsl:choose>
                <xsl:when test="contains($date-string-mit-spitze, '&lt;')">
                    <xsl:value-of select="substring-before($date-string-mit-spitze, '&lt;')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$date-string-mit-spitze"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:analyze-string select="$date-string" regex="^(\d{{4}})-(\d{{2}})-(\d{{2}})$">
            <xsl:matching-substring>
                <xsl:variable name="year" select="xs:integer(regex-group(1))"/>
                <xsl:variable name="month">
                    <xsl:choose>
                        <xsl:when test="starts-with(regex-group(2), '0')">
                            <xsl:value-of select="substring(regex-group(2), 2)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="regex-group(2)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="day">
                    <xsl:choose>
                        <xsl:when test="starts-with(regex-group(3), '0')">
                            <xsl:value-of select="substring(regex-group(3), 2)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="regex-group(3)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:value-of select="concat($day, '. ', $month, '. ', $year)"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring><!-- Hier noch Daten vom Typ 02.03.1923 säubern -->
                <xsl:choose>
                    <xsl:when test="starts-with($date-string,'0')">
                        <xsl:value-of select="replace(substring($date-string, 2), '.0','.')"/>
                    </xsl:when>
                    <xsl:when test="contains($date-string, '.0')">
                        <xsl:value-of select="replace($date-string, '.0','.')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$date-string"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:function>
</xsl:stylesheet>