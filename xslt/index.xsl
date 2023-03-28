<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="tei xsl xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select="'Hermann Bahr – Arthur Schnitzler'"/>
        </xsl:variable>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"/>
            </xsl:call-template>
            <body class="page">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <div class="wrapper" id="wrapper-hero">
                        <!-- ******************* The Hero Area ******************* -->
                        <div class="wrapper" id="wrapper-hero-content"
                            style="background-image:url(https://shared.acdh.oeaw.ac.at/schnitzler-bahr/schnitzler-bahr.jpg);">
                            <div class="container-fluid-empty hero-light" id="wrapper-hero-inner"
                                tabindex="-1" >
                                <div>
                                    <h3 class="mt-3">Hermann Bahr – Arthur Schnitzler</h3>
                                    <h1 class="mt-3">Briefwechsel.  Aufzeichnungen, Dokumente (1891–1931)</h1>
                                    <h3 class="mt-3" style="margin-bottom: 3cm;">Herausgegeben von Kurt Ifkovits, Martin Anton
                                        Müller</h3>
                                       
                                </div>
                                <a
                                    href="D041003.html">
                                    <button class="btn btn-round">Lesen</button>
                                </a>
                                <span>&#160;&#160;</span>
                                <a
                                    href="korrespondenz.html">
                                    <button class="btn btn-round">Weiter</button>
                                </a>
                            </div>
                        </div></div>
                    <div class="container" style="margin-top:1em;">
                        <div class="row">
                            <div class="col-md-8" style="margin: 0 auto; ">
                                <p style="font-size:18px;line-heigth:27px;"/>
                                <p style="font-size:18px;line-heigth:27px;">Diese Website ist ein
                                    Begleitprodukt zur Buchedition »<hi rends="italics">Arthur
                                    Schnitzler, Hermann Bahr: Briefwechsel, Materialien, Dokumente
                                    1891–1931</hi>«. Auf die im Buch vorgenommenen
                                    Kürzungen von bereits publizierten Texten wie Schnitzlers
                                    Tagebuch und Bahrs Aufzeichnungen aber auch der Briefe von und
                                    an Dritte wird in der Online-Präsentation verzichtet. Das hat
                                    den großen Vorteil, ein größeres durchsuchbares Textkorpus zur
                                    Verfügung stellen zu können.</p>
                                <p style="font-size:18px;line-heigth:27px;">Die <a target="_blank"
                                        href="https://www.wallstein-verlag.de/9783835332287-hermann-bahr-arthur-schnitzler-briefwechsel-aufzeichnungen-dokumente-1891-1931.html"
                                        >Buchausgabe</a> erschien 2018 im Wallstein-Verlag.</p>
                                <p>Ein <a target="_blank"
                                        href="https://www.oapen.org/search?identifier=647851"
                                        >PDF</a> (Open Access) des Buches kann auf oapen.org
                                    heruntergeladen werden</p>
                                <p/>
                                <p><hi rend="italics">Warum ist diese Seite weiterhin aktuell?</hi> 
                                    Teile der vorliegenden Edition finden sich auch anderswo im Netz. Das <a target="_blank"
                                        href="https://schnitzler-tagebuch.acdh.oeaw.ac.at">Tagebuch</a> Schnitzlers ist vollständig online –
                                    doch nur bei den von uns herausgegebenen Daten sind indirekte Erwähnungen (»Bahr und Frau«)
                                    und Organisationen indiziert. Die Edition der beruflichen Korrespondenz Schnitzlers (<a target="_blank" href="https://schnitzler-briefe.acdh.oeaw.ac.at">Briefe</a>)
                                    enthält nicht nur den Briefwechsel
                                    Bahr – Schnitzler, sondern auch weitere Briefe, aus denen hier noch 
                                    aus Buchausgaben zitiert wird, dort aber nach den Originalen in Archiven (beispielsweise Hofmannsthal, Beer-Hofmann).
                                    Trotzdem enthält unsere Edition einige Briefe, die sich anderswo
                                    nicht finden, etwa von Schnitzler und seiner Frau oder von Dritten an Bahr. 
                                    Dazu kommen noch weitere Texte, wie Kritiken und Erinnerungen, die hier
                                exklusiv vorliegen.</p>
                            </div>
                        </div>
                    </div>
                    <div class="container" style="margin-top:1em;">
                        <div class="row">
                            <div class="col-md-4">
                                <a href="listperson.html" class="index-link">
                                    <div class="card index-card">
                                        <div class="card-body">
                                            <img
                                                src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/persons.jpg"
                                                class="d-block w-100" alt="..."/>
                                        </div>
                                        <div class="card-header">
                                            <h3>
                                                <i class="fa-solid fa-user-group"/> Personenregister
                                            </h3>
                                        </div>
                                    </div>
                                </a>
                            </div>
                            <div class="col-md-4">
                                <a href="listwork.html" class="index-link">
                                    <div class="card index-card">
                                        <div class="card-body">
                                            <img
                                                src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/werke.jpg"
                                                class="d-block w-100" alt="..."/>
                                        </div>
                                        <div class="card-header">
                                            <h3>
                                                <i class="fa-solid fa-user-group"/> Werkregister
                                            </h3>
                                        </div>
                                    </div>
                                </a>
                            </div>
                            <div class="col-md-4">
                                <a href="listplace.html" class="index-link">
                                    <div class="card index-card">
                                        <div class="card-body">
                                            <img
                                                src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/places.jpg"
                                                class="d-block w-100" alt="..."/>
                                        </div>
                                        <div class="card-header">
                                            <h3>
                                                <i class="fa-solid fa-user-group"/> Ortsregister
                                            </h3>
                                        </div>
                                    </div>
                                </a>
                            </div>
                            <div class="col-md-4">
                                <a href="listorg.html" class="index-link">
                                    <div class="card index-card">
                                        <div class="card-body">
                                            <img
                                                src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/org.jpg"
                                                class="d-block w-100" alt="..."/>
                                        </div>
                                        <div class="card-header">
                                            <h3>
                                                <i class="fa-solid fa-user-group"/>
                                                Institutionsregister </h3>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </div>
                    <xsl:call-template name="html_footer"/>
                </div>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="tei:div//tei:head">
        <h2 id="{generate-id()}">
            <xsl:apply-templates/>
        </h2>
    </xsl:template>
    <xsl:template match="tei:p">
        <p id="{generate-id()}">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:list">
        <ul id="{generate-id()}">
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    <xsl:template match="tei:item">
        <li id="{generate-id()}">
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    <xsl:template match="tei:ref">
        <xsl:choose>
            <xsl:when test="starts-with(data(@target), 'http')">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="@target"/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>