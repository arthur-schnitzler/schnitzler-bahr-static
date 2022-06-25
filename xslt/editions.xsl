<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    xmlns:foo="whateverWorksForMe"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:import href="./partials/shared.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/osd-container.xsl"/>
    <xsl:import href="./partials/tei-facsimile.xsl"/>
    <xsl:import href="./partials/person.xsl"/>
    <xsl:import href="./partials/place.xsl"/>
    
    <xsl:param name="quotationURL"/>
    
    

    <xsl:variable name="prev">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@prev), '/')[last()], '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="next">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@next), '/')[last()], '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="teiSource">
        <xsl:value-of select="data(tei:TEI/@xml:id)"/>
    </xsl:variable>
    <xsl:variable name="link">
        <xsl:value-of select="replace($teiSource, '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="doc_title">
        <xsl:value-of select=".//tei:title[@level='a'][1]/text()"/>
    </xsl:variable>
    
    <xsl:variable name="entryDate">
        <xsl:value-of select="xs:date(//tei:title[@type='iso-date']/text())"/>
    </xsl:variable>
    <xsl:variable name="doctitle">
        <xsl:value-of select="//tei:title[@type='main']/text()"/>
    </xsl:variable>
    <xsl:variable name="currentDate">
        <xsl:value-of select="format-date(current-date(), '[Y]-[M01]-[D01]')"/>
    </xsl:variable>
    <xsl:variable name="pid">
        <xsl:value-of select="//tei:publicationStmt//tei:idno[@type='URI']/text()"/>
    </xsl:variable>
        
    <xsl:variable name="source_volume">
        <xsl:value-of select="replace(//tei:monogr//tei:biblScope[@unit='volume']/text(), '-', '_')"/>
    </xsl:variable>
    <xsl:variable name="source_base_url">https://austriaca.at/buecher/files/arthur_schnitzler_tagebuch/Tagebuch1879-1931Einzelseiten/schnitzler_tb_</xsl:variable>
    <xsl:variable name="source_page_nr">
        <xsl:value-of select="format-number(//tei:monogr//tei:biblScope[@unit='page']/text(), '000')"/>
    </xsl:variable>
    <xsl:variable name="source_pdf">
        <xsl:value-of select="concat($source_base_url, $source_volume, 's', $source_page_nr, '.pdf')"/>
    </xsl:variable>
    <xsl:variable name="current-date">
        <xsl:value-of select="substring-after($doctitle, ': ')"/>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select="descendant::tei:titleStmt[1]/tei:title[@level='a'][1]/text()"/>
        </xsl:variable>
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
        <html lang="de">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
            </xsl:call-template>
            <body class="page">
                <link rel="stylesheet" href="css/cslink.css"/>
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    
                    <div class="container-fluid">                        
                        <div class="card">
                            <div class="card-header">
                                <div class="row">
                                    <div class="col-md-2">
                                        <xsl:if test="ends-with($prev,'.html')">
                                            <h1>
                                                <a>
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="$prev"/>
                                                    </xsl:attribute>
                                                    <i class="fas fa-chevron-left" title="prev"/>
                                                </a>
                                            </h1>
                                        </xsl:if>
                                    </div>
                                    <div class="col-md-8">
                                        <h1 align="center">
                                            <xsl:value-of select="$doc_title"/>
                                        </h1>
                                    </div>
                                    <div class="col-md-2" style="text-align:right">
                                        <xsl:if test="ends-with($next, '.html')">
                                            <h1>
                                                <a>
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="$next"/>
                                                    </xsl:attribute>
                                                    <i class="fas fa-chevron-right" title="next"/>
                                                </a>
                                            </h1>
                                        </xsl:if>
                                    </div>
                                </div>
                            </div>
                            <div class="card-body-tagebuch" data-index="true">                                
                                <xsl:apply-templates select=".//tei:body"></xsl:apply-templates>
                            </div>
                            <div class="card-footer text-muted">
                                <div id="srcbuttons" style="text-align:center">
                                    <a data-toggle="tooltip" title="Zeige Register" onclick="toggleVisibility()">
                                        <i class="fas fa-map-marked-alt"/> Register
                                    </a>
                                    <div class="res-act-button res-act-button-copy-url ml-3" id="res-act-button-copy-url">
                                        <span id="copy-url-button" data-toggle="modal" data-target="#quoteModal">
                                            <i class="fas fa-quote-right"/> Zitieren
                                        </span>
                                    </div>
                                    <xsl:if test=".//tei:facsimile/*">
                                        <a class="ml-3" title="Faksimile zu diesem Eintrag" data-toggle="modal" data-target="#exampleModal">
                                            <i class="fa-lg far fa-file-image"/> Faksimile
                                        </a>
                                    </xsl:if>
                                    <a class="ml-3" data-toggle="tooltip" title="Link zum PDF der Buchvorlage zu diesem Eintrag">
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="$source_pdf"/>
                                        </xsl:attribute>
                                        <i class="fa-lg far fa-file-pdf"/> PDF
                                    </a>
                                    <a class="ml-3" data-toggle="tooltip" title="Link zur TEI-Datei">
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="$teiSource"/>
                                        </xsl:attribute>
                                        <i class="fa-lg far fa-file-code"/> TEI 
                                    </a>
                                    <span class="nav-link">
                                        <div id="csLink" data-correspondent-1-name="Arthur Schnitzler"
                                            data-correspondent-1-id="http%3A%2F%2Fd-nb.info%2Fgnd%2F118609807"
                                            data-correspondent-2-name="" data-correspondent-2-id="" data-start-date="{$entryDate}"
                                            data-end-date="" data-range="50" data-selection-when="before-after" data-selection-span="median-before-after"
                                            data-result-max="4" data-exclude-edition=""
                                        />
                                    </span>
                                </div>
                                <div id="registerDiv" class="d-none">
                                    <nav>
                                        <div class="nav nav-tabs" id="nav-tab" role="tablist">
                                            <a class="nav-item nav-link" id="nav-person-tab" data-toggle="tab" href="#nav-person" role="tab" aria-controls="nav-person" aria-selected="true">Personen</a>
                                            <a class="nav-item nav-link" id="nav-werk-tab" data-toggle="tab" href="#nav-werk" role="tab" aria-controls="nav-werk" aria-selected="false">Werke</a>
                                            <a class="nav-item nav-link active" id="nav-ort-tab" data-toggle="tab" href="#nav-ort" role="tab" aria-controls="nav-ort" aria-selected="false">Orte</a>
                                        </div>
                                    </nav>
                                    <div class="tab-content" id="nav-tabContent">
                                        <div class="tab-pane" id="nav-person" role="tabpanel" aria-labelledby="nav-person-tab">
                                            <legend>Personen</legend>
                                            <ul>
                                                <xsl:for-each select=".//tei:listPerson//tei:person">
                                                    <li>
                                                        <a>
                                                            <xsl:attribute name="href"><xsl:value-of select="concat(data(@xml:id), '.html')"/></xsl:attribute>
                                                            <xsl:value-of select="./tei:persName"/>
                                                        </a>
                                                    </li>
                                                </xsl:for-each>
                                            </ul>
                                        </div>
                                        <div class="tab-pane fade" id="nav-werk" role="tabpanel" aria-labelledby="nav-werk-tab">
                                            <legend>Werke</legend>
                                            <ul>
                                                <xsl:for-each select=".//tei:listBibl//tei:bibl">
                                                    <li>
                                                        <a>
                                                            <xsl:attribute name="href"><xsl:value-of select="concat(data(@xml:id), '.html')"/></xsl:attribute>
                                                            <xsl:value-of select="./tei:title"/>
                                                        </a>
                                                    </li>
                                                </xsl:for-each>
                                            </ul>
                                        </div>
                                        <div class="tab-pane fade fade show active" id="nav-ort" role="tabpanel" aria-labelledby="nav-ort-tab">
                                            <legend>Orte</legend>
                                            <div class="row">
                                                <div class="col-md-4">
                                                    <ul>
                                                        <xsl:for-each select=".//tei:listPlace/tei:place">
                                                            <li>
                                                                <a>
                                                                    <xsl:attribute name="href"><xsl:value-of select="concat(data(@xml:id), '.html')"/></xsl:attribute>
                                                                    <xsl:value-of select="./tei:placeName[1]/text()"/>
                                                                </a>
                                                            </li>
                                                        </xsl:for-each>
                                                    </ul>
                                                </div>
                                                <div id="mapid" style="height: 400px;" class="col-md-8"/>
                                            </div>
                                            <link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css" integrity="sha512-xodZBNTC5n17Xt2atTPuE1HxjVMSvLVW9ocqUKLsCC5CXdbqCmblAshOMAS6/keqq/sMZMZ19scR4PsZChSR7A==" crossorigin=""/>
                                            <script src="https://unpkg.com/leaflet@1.7.1/dist/leaflet.js" integrity="sha512-XQoYMqMTK8LvdxXYG3nZ448hOEQiglfqkJs1NOQV44cWnUrBc8PkAOcXy20w0vlaXaVUearIOBhiXZ5V3ynxwA==" crossorigin=""/>
                                            <script>
                                                
                                                var mymap = L.map('mapid').setView([50, 12], 5);
                                                
                                                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                                                attribution: 'Map data &amp;copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="https://www.openstreetmap.org/">OpenStreetMap</a>',
                                                maxZoom: 18,
                                                zIndex: 1
                                                }).addTo(mymap);
                                                <xsl:for-each select=".//tei:listPlace/tei:place">
                                                    L.marker([<xsl:value-of select="substring-before(tei:location[1]/tei:geo[1]/text()[1], ' ')"/>, <xsl:value-of select="substring-after(tei:location[1]//tei:geo[1]/text(), ' ')"/>]).addTo(mymap)
                                                    .bindPopup("<b>
                                                        <xsl:value-of select="./tei:placeName[1]/text()"/>
                                                    </b>").openPopup();
                                                </xsl:for-each>
                                            </script>
                                            
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>                       
                    </div>
                    <div class="modal fade" id="quoteModal" tabindex="-1" role="dialog" aria-labelledby="quoteModalLabel" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="quoteModalLabel">Zitiervorschlag</h5>
                                </div>
                                <div class="modal-body">
                                    Arthur Schnitzler: Tagebuch. Digitale Edition, <xsl:value-of select="$doctitle"/>, https://schnitzler-tagebuch.acdh.oeaw.ac.at/entry__1894-03-18.html (Stand <xsl:value-of select="$currentDate"/>), PID: <xsl:value-of select="$pid"/>. 
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Schließen</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-lg" role="document" style="max-width: 2000px;">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h3>Faksimile</h3>
                                </div>
                                <div class="modal-body">
                                    <div id="openseadragon-photo" style="height: 850px;"/>
                                    <script src="https://cdnjs.cloudflare.com/ajax/libs/openseadragon/2.4.1/openseadragon.min.js"/>
                                    <script type="text/javascript">
                                        var viewer = OpenSeadragon({
                                        id: "openseadragon-photo",
                                        protocol: "http://iiif.io/api/image",
                                        prefixUrl: "https://cdnjs.cloudflare.com/ajax/libs/openseadragon/2.4.1/images/",
                                        sequenceMode : true,
                                        showReferenceStrip: true,
                                        tileSources: [
                                            <xsl:for-each select=".//data(@url)">{
                                                type: 'image',
                                                url: '<xsl:value-of select="concat(., '?format=iiif')"/>'
                                             }
                                            <xsl:choose>
                                            <xsl:when test="position() != last()">,</xsl:when>
                                        </xsl:choose></xsl:for-each>]
                                        });
                                    </script>
                                </div>
                                <div class="modal-footer" style="justify-content: flex-start;">
                                    <ul style="list-style-type: none;">
                                        <xsl:for-each select=".//data(@url)">
                                            <li>
                                                <a>
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="concat(., '?format=gui')"/>
                                                    </xsl:attribute>
                                                    <xsl:value-of select="."/>
                                                </a>
                                            </li>
                                        </xsl:for-each>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <xsl:for-each select=".//tei:back//tei:person[@xml:id]">
                        <xsl:variable name="xmlId">
                            <xsl:value-of select="data(./@xml:id)"/>
                        </xsl:variable>
                        
                        <div class="modal fade" tabindex="-1" role="dialog" aria-hidden="true" id="{$xmlId}">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">
                                            <xsl:value-of select="normalize-space(string-join(.//tei:persName[1]//text()))"/>
                                            <xsl:text> </xsl:text>
                                            <a href="{concat($xmlId, '.html')}">
                                                <i class="fas fa-external-link-alt"></i>
                                            </a>
                                        </h5>
                                        
                                    </div>
                                    <div class="modal-body">
                                        <xsl:call-template name="person_detail">
                                            <xsl:with-param name="showNumberOfMentions" select="5"/>
                                        </xsl:call-template>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Schließen</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </xsl:for-each>
                    <xsl:for-each select=".//tei:back//tei:place[@xml:id]">
                        <xsl:variable name="xmlId">
                            <xsl:value-of select="data(./@xml:id)"/>
                        </xsl:variable>
                        
                        <div class="modal fade" tabindex="-1" role="dialog" aria-hidden="true" id="{$xmlId}">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">
                                            <xsl:value-of select="normalize-space(string-join(.//tei:placeName[1]/text()))"/>
                                            <xsl:text> </xsl:text>
                                            <a href="{concat($xmlId, '.html')}">
                                                <i class="fas fa-external-link-alt"></i>
                                            </a>
                                        </h5>
                                    </div>
                                    <div class="modal-body">
                                        <xsl:call-template name="place_detail">
                                            <xsl:with-param name="showNumberOfMentions" select="5"/>
                                        </xsl:call-template>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Schließen</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </xsl:for-each>
                    <xsl:call-template name="html_footer"/>
                    <script src="js/cslink.js"/>
                    <script>
                        function toggleVisibility() {
                            document.getElementById("registerDiv").classList.toggle("d-none");
                            document.getElementById("registerDiv").classList.toggle("d-block");
                            mymap.invalidateSize();
                        } 
                    </script>
                </div>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="tei:fw"/>

    <xsl:template match="tei:p">
        <p id="{local:makeId(.)}">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:div">
        <div id="{local:makeId(.)}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:date[@*]">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:term">
        <span>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:hi">
        <xsl:choose>
            <xsl:when test="@rend = 'subscript'">
                <span class="subscript">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="@rend = 'superscript'">
                <span class="superscript">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="@rend = 'italics'">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="@rend = 'underline'">
                <xsl:choose>
                    <xsl:when test="@n = '1'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:when test="@n = '2'">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="@rend = 'pre-print'">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="@rend = 'bold'">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="@rend = 'stamp'">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="@rend = 'small_caps'">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="@rend = 'capitals'">
                <span class="uppercase">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="@rend = 'spaced_out'">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="@rend = 'latintype'">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="@rend = 'antiqua'">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--    footnotes -->
    <xsl:template match="tei:note">
        <xsl:element name="a">
            <xsl:attribute name="name">
                <xsl:text>fna_</xsl:text>
                <xsl:number level="any" format="1" count="tei:note"/>
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:text>#fn</xsl:text>
                <xsl:number level="any" format="1" count="tei:note"/>
            </xsl:attribute>
            <xsl:attribute name="title">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:attribute>
            <sup>
                <xsl:number level="any" format="1" count="tei:note[./tei:p]"/>
            </sup>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:div">
        <xsl:choose>
            <xsl:when test="@type = 'regest'">
                <div>
                    <xsl:attribute name="class">
                        <text>regest</text>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <!-- transcript -->
            <xsl:when test="@type = 'transcript'">
                <div>
                    <xsl:attribute name="class">
                        <text>transcript</text>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <!-- Anlagen/Beilagen  -->
            <xsl:when test="@xml:id">
                <xsl:element name="div">
                    <xsl:attribute name="id">
                        <xsl:value-of select="@xml:id"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- Verweise auf andere Dokumente   -->
    <!-- resp -->
    <xsl:template match="tei:respStmt/tei:resp">
        <xsl:apply-templates/>  </xsl:template>
    <xsl:template match="tei:respStmt/tei:name">
        <xsl:for-each select=".">
            <li>
                <xsl:apply-templates/>
            </li>
        </xsl:for-each>
    </xsl:template>
    <!-- Tabellen -->
    <xsl:template match="tei:table">
        <xsl:element name="table">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="data(@xml:id)"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="class">
                <xsl:text>table editionText</xsl:text>
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
    <!-- Überschriften -->
    <xsl:template match="tei:head">
        <xsl:if test="@xml:id[starts-with(., 'org') or starts-with(., 'ue')]">
            <a>
                <xsl:attribute name="name">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
                <xsl:text> </xsl:text>
            </a>
        </xsl:if>
        <a>
            <xsl:attribute name="name">
                <xsl:text>hd</xsl:text>
                <xsl:number level="any"/>
            </xsl:attribute>
            <xsl:text> </xsl:text>
        </a>
        <h3>
            <div>
                <xsl:apply-templates/>
            </div>
        </h3>
    </xsl:template>
    <!--  Quotes / Zitate -->
    <xsl:template match="tei:q">
        <xsl:element name="i">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:quote">
        <xsl:apply-templates/>
    </xsl:template>
    <!-- Zeilenumbürche   -->
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    <!-- Durchstreichungen -->
    <xsl:template match="tei:origDate[@notBefore and @notAfter]">
        <xsl:variable name="dates">
            <xsl:value-of select="./@*" separator="-"/>
        </xsl:variable>
        <abbr title="{$dates}">
            <xsl:value-of select="."/>
        </abbr>
    </xsl:template>
    <xsl:template match="tei:extent">
        <xsl:apply-templates select="./tei:measure"/>
        <xsl:apply-templates select="./tei:dimensions"/>
    </xsl:template>
    <xsl:template match="tei:measure">
        <xsl:variable name="x">
            <xsl:value-of select="./@type"/>
        </xsl:variable>
        <xsl:variable name="y">
            <xsl:value-of select="./@quantity"/>
        </xsl:variable>
        <abbr title="type: {$x}, quantity: {$y}">Measure</abbr>: <xsl:value-of select="./text()"/>
        <br/>
    </xsl:template>
    <xsl:template match="tei:dimensions">
        <xsl:variable name="x">
            <xsl:value-of select="./@type"/>
        </xsl:variable>
        <xsl:variable name="y">
            <xsl:value-of select="./@unit"/>
        </xsl:variable>
        <abbr title="type: {$x}">Dimensions:</abbr> h: <xsl:value-of select="./tei:height/text()"/>
        <xsl:value-of select="$y"/>, w: <xsl:value-of select="./tei:width/text()"/>
        <xsl:value-of select="$y"/>
        <br/>
    </xsl:template>
    <xsl:template match="tei:layoutDesc">
        <xsl:for-each select="tei:layout">
            <div>
                <xsl:value-of select="./@columns"/> Column(s) à <xsl:value-of select="./@ruledLines | ./@writtenLines"/> ruled/written lines:
                <xsl:apply-templates/>
            </div>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="tei:locus">
        <xsl:variable name="folio-from-id">
            <xsl:value-of select="./@from"/>
        </xsl:variable>
        <xsl:variable name="folio-to-id">
            <xsl:value-of select="./@to"/>
        </xsl:variable>
        <xsl:variable name="url-from-facs">
            <xsl:value-of select="./ancestor::tei:TEI//tei:graphic[@n = $folio-from-id]/@url"/>
        </xsl:variable>
        <xsl:variable name="url-to-facs">
            <xsl:value-of select="./ancestor::tei:TEI//tei:graphic[@n = $folio-to-id]/@url"/>
        </xsl:variable>
        <a href="{$url-from-facs}">
            <xsl:value-of select="$folio-from-id"/>
        </a>-<a href="{$url-to-facs}">
            <xsl:value-of select="./@to"/>
        </a>
    </xsl:template>
    <xsl:template match="tei:handDesc">
        <xsl:for-each select="./tei:handNote">
            <div>
                <xsl:apply-templates/>
            </div>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="tei:title">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:title[ancestor::tei:fileDesc[1]/tei:titleStmt[1] and @level = 'a']">
        <div id="titleForNavigation">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:scriptDesc">
        <xsl:for-each select="./tei:scriptNote">
            <div> Type: <xsl:value-of select="./@script"/>
                <xsl:apply-templates/>
            </div>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="tei:bindingDesc">
        <xsl:for-each select="./tei:binding">
            <div> Date: <xsl:value-of select="./@notBefore"/>-<xsl:value-of select="./@notAfter"/>
                <xsl:apply-templates/>
            </div>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="tei:list">
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    <xsl:template match="tei:item">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    <xsl:template match="tei:listBibl">
        <xsl:for-each select=".//tei:bibl">
            <li>
                <xsl:apply-templates/>
            </li>
        </xsl:for-each>
    </xsl:template>
    <!--    <xsl:template match="tei:ptr"><xsl:variable name="x"><xsl:value-of select="./@target"/></xsl:variable><a href="{$x}" class="fas fa-link"/></xsl:template>
-->
    <xsl:template match="tei:msPart">
        <xsl:variable name="x">
            <xsl:number count="." level="any"/>
        </xsl:variable>
        <div class="card-header" id="mspart_{$x}">
            <div class="card-header">
                <p align="center">
                    <xsl:value-of select="./tei:msIdentifier"/>
                    <xsl:value-of select="./tei:head"/>
                </p>
            </div>
            <div class="card-body">
                <xsl:apply-templates select=".//tei:msContents"/>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="tei:msContents">
        <xsl:for-each select=".//tei:msItem">
            <xsl:apply-templates select="."/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="tei:gi">
        <code>
            <xsl:apply-templates/>
        </code>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#kaufmannsund']"> &amp; </xsl:template>
    <xsl:template match="tei:c[@rendition = '#geschwungene-klammer-auf']"> { </xsl:template>
    <xsl:template match="tei:c[@rendition = '#geschwungene-klammer-zu']"> } </xsl:template>
    <xsl:template match="tei:c[@rendition = '#gemination-m']">
        <span class="gemination">mm</span>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#gemination-n']">
        <span class="gemination">nn</span>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#prozent']"> % </xsl:template>
    <xsl:function name="foo:dots">
        <xsl:param name="anzahl"/> . <xsl:if test="$anzahl &gt; 1">
            <xsl:value-of select="foo:dots($anzahl - 1)"/>
        </xsl:if>
    </xsl:function>
    <xsl:function name="foo:gaps">
        <xsl:param name="anzahl"/>
        <xsl:text>×</xsl:text>
        <xsl:if test="$anzahl &gt; 1">
            <xsl:value-of select="foo:gaps($anzahl - 1)"/>
        </xsl:if>
    </xsl:function>
    <xsl:template match="tei:c[@rendition = '#dots']">
        <xsl:value-of select="foo:dots(@n)"/>
    </xsl:template>
    <xsl:template match="tei:gap[@unit = 'chars' and @reason = 'illegible']">
        <span class="illegible">
            <xsl:value-of select="foo:gaps(@quantity)"/>
        </span>
    </xsl:template>
    <xsl:template match="tei:gap[@unit = 'lines' and @reason = 'illegible']">
        <div class="illegible">
            <xsl:text> [</xsl:text>
            <xsl:value-of select="@quantity"/>
            <xsl:text> Zeilen unleserlich] </xsl:text>
        </div>
    </xsl:template>
    <xsl:template match="tei:gap[@reason = 'outOfScope']">
        <span class="outOfScope">[…]</span>
    </xsl:template>
    <xsl:template match="tei:p[child::tei:space[@dim] and not(child::*[2]) and empty(text())]">
        <br/>
    </xsl:template>
    <xsl:template match="tei:p[parent::tei:quote]">
        <xsl:apply-templates/>
        <xsl:if test="not(position() = last())">
            <xsl:text> / </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:space[@dim = 'vertical']">
        <xsl:element name="div">
            <xsl:attribute name="style">
                <xsl:value-of select="concat('padding-bottom:', @quantity, 'em;')"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:space[@unit = 'chars' and @quantity = 1]">
        <xsl:text> </xsl:text>
    </xsl:template>
    <xsl:template match="tei:space[@unit = 'chars' and not(@quantity = 1)]">
        <xsl:text> </xsl:text>
    </xsl:template>
    <xsl:template match="tei:opener">
        <div class="opener">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <!--<xsl:template match="tei:add[@place and not(parent::tei:subst)]"><span class="steuerzeichen">↓</span><span class="add"><xsl:apply-templates/></span><span class="steuerzeichen">↓</span></xsl:template>
    -->
    <!-- Streichung -->
    <!--<xsl:template match="tei:del[not(parent::tei:subst)]"><span class="del"><xsl:apply-templates/></span></xsl:template><xsl:template match="tei:del[parent::tei:subst]"><xsl:apply-templates/></xsl:template>
    -->
    <!-- Substi -->
    <!--<xsl:template match="tei:subst"><span class="steuerzeichen">↑</span><span class="superscript"><xsl:apply-templates select="tei:del"/></span><span class="subst-add"><xsl:apply-templates select="tei:add"/></span><span class="steuerzeichen">↓</span></xsl:template>
    -->
    <!-- Wechsel der Schreiber <handShift -->
    <!--<xsl:template match="tei:handShift[not(@scribe)]"><xsl:choose><xsl:when test="@medium = 'typewriter'"><xsl:text>[ms.:] </xsl:text></xsl:when><xsl:otherwise><xsl:text>[hs.:] </xsl:text></xsl:otherwise></xsl:choose></xsl:template><xsl:template match="tei:handShift[@scribe]"><xsl:variable name="scribe"><xsl:value-of select="@scribe"/></xsl:variable><xsl:text>[hs. </xsl:text><xsl:value-of select="foo:vorname-vor-nachname(//tei:correspDesc//tei:persName[@ref  = $scribe])"/><xsl:text>:] </xsl:text></xsl:template>
    -->
    <xsl:function name="foo:vorname-vor-nachname">
        <xsl:param name="autorname"/>
        <xsl:choose>
            <xsl:when test="contains($autorname, ', ')">
                <xsl:value-of select="substring-after($autorname, ', ')"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="substring-before($autorname, ', ')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$autorname"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:template match="tei:salute[parent::tei:opener]">
        <p>
            <div class="editionText salute">
                <xsl:apply-templates/>
            </div>
        </p>
    </xsl:template>
    <xsl:template match="tei:signed">
        <div class="signed editionText">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:p[ancestor::tei:body and not(ancestor::tei:note) and not(ancestor::tei:footNote) and not(ancestor::tei:caption) and not(parent::tei:bibl) and not(parent::tei:quote) and not(child::tei:space[@dim])] | tei:dateline | tei:closer">
        <xsl:choose>
            <xsl:when test="child::tei:seg">
                <div class="editionText">
                    <span class="seg-left">
                        <xsl:apply-templates select="tei:seg[@rend = 'left']"/>
                    </span>
                    <xsl:text> </xsl:text>
                    <span class="seg-right">
                        <xsl:apply-templates select="tei:seg[@rend = 'right']"/>
                    </span>
                </div>
            </xsl:when>
            <xsl:when test="@rend = 'right'">
                <p align="right" class="editionText">
                    <xsl:apply-templates/>
                </p>
            </xsl:when>
            <xsl:when test="@rend = 'left'">
                <p align="left" class="editionText">
                    <xsl:apply-templates/>
                </p>
            </xsl:when>
            <xsl:when test="@rend = 'center'">
                <p align="center" class="editionText">
                    <xsl:apply-templates/>
                </p>
            </xsl:when>
            <xsl:when test="@rend = 'inline'">
                <p class="inline editionText">
                    <xsl:apply-templates/>
                </p>
            </xsl:when>
            
            <xsl:otherwise>
                <div class="editionText">
                    <xsl:apply-templates/>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:p[not(parent::tei:quote) and (ancestor::tei:note or ancestor::tei:footNote or ancestor::tei:caption or parent::tei:bibl)]">
        <xsl:choose>
            <xsl:when test="@rend = 'right'">
                <p align="right">
                    <xsl:apply-templates/>
                </p>
            </xsl:when>
            <xsl:when test="@rend = 'left'">
                <p align="left">
                    <xsl:apply-templates/>
                </p>
            </xsl:when>
            <xsl:when test="@rend = 'center'">
                <p align="center">
                    <xsl:apply-templates/>
                </p>
            </xsl:when>
            <xsl:when test="@rend = 'inline'">
                <p style="inline">
                    <xsl:apply-templates/>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <xsl:apply-templates/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:div[not(@type = 'address')]">
        <div class="div">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:div[@type = 'address']">
        <div class="address-div">
            <xsl:apply-templates/>
        </div>
        <br/>
    </xsl:template>
    <xsl:template match="tei:address">
        <div class="column">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:addrLine">
        <div class="addrLine">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:damage">
        <span class="damage">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <!--<xsl:template match="tei:pb"><span class="steuerzeichenUnten">|</span></xsl:template>
   -->
    <xsl:template match="tei:unclear">
        <span class="unsicher">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:lg[@type = 'poem' and not(descendant::lg[@type='stanza'])]">
        <div class="poem editionText">
            <ul>
                <xsl:apply-templates/>
            </ul>
        </div>
    </xsl:template>
    <xsl:template match="tei:lg[@type = 'poem' and descendant::lg[@type='stanza']]">
        <div class="poem editionText">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:lg[@type = 'stanza']">
        <ul>
            <xsl:apply-templates/>
        </ul>
        <xsl:if test="not(position()=last())">
            <br/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:l">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    
    <xsl:template match="tei:back"/>
    
    
</xsl:stylesheet>