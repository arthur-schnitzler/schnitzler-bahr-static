<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:local="http://dse-static.foo.bar"
    xmlns:foo="whateverWorksForMe" version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>
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
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@prev), '/')[last()], '.xml', '.html')"
        />
    </xsl:variable>
    <xsl:variable name="next">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@next), '/')[last()], '.xml', '.html')"
        />
    </xsl:variable>
    <xsl:variable name="teiSource">
        <xsl:value-of select="data(tei:TEI/@xml:id)"/>
    </xsl:variable>
    <xsl:variable name="link">
        <xsl:value-of select="replace($teiSource, '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="doc_title">
        <xsl:value-of select="descendant::tei:titleStmt/tei:title[@level = 'a'][1]"/>
    </xsl:variable>
    <xsl:variable name="entryDate">
        <xsl:value-of select="xs:date(//tei:title[@type = 'iso-date']/text())"/>
    </xsl:variable>
    <xsl:variable name="handle">
        <xsl:value-of
            select="descendant::tei:teiHeader[1]/tei:fileDesc[1]/tei:publicationStmt[1]/tei:idno[@type = 'handle'][1]/text()"
        />
    </xsl:variable>
    <!--
##################################
### Seitenlayout und -struktur ###
##################################
-->
    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select="descendant::tei:titleStmt[1]/tei:title[@level = 'a'][1]/text()"/>
        </xsl:variable>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html lang="de">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"/>
            </xsl:call-template>
            <body class="page">
                <link rel="stylesheet" href="css/cslink.css"/>
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <div class="container-fluid">
                        <div class="card">
                            <div class="card card-header">
                                <div class="row">
                                    <div class="col-md-2">
                                        <xsl:if test="ends-with($prev, '.html')">
                                            <h2>
                                                <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of select="$prev"/>
                                                  </xsl:attribute>
                                                  <i class="fas fa-chevron-left" title="prev"/>
                                                </a>
                                            </h2>
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
                            <div class="card-body-normalertext" data-index="true">
                                <xsl:apply-templates select=".//tei:body"/>
                                <xsl:if test="descendant::tei:footNote">
                                    <p/>
                                    <xsl:element name="ol">
                                        <xsl:attribute name="class">
                                            <xsl:text>list-for-footnotes</xsl:text>
                                        </xsl:attribute>
                                        <xsl:apply-templates select="descendant::tei:footNote"
                                            mode="footnote"/>
                                    </xsl:element>
                                </xsl:if>
                            </div>
                            <div class="card-body-anhang" id="bottom">
                                
                                <div class="card-footer text-muted">
                                    <div id="srcbuttons" style="text-align:center">
                                        <a data-toggle="tooltip" title="Zeige Register"
                                            onclick="toggleVisibility()"> ANHANG </a>
                                    </div>
                                    <div id="registerDiv" class="d-none">
                                        <nav>
                                            <div class="nav nav-tabs" id="nav-tab" role="tablist">
                                                <a class="nav-item nav-link" id="nav-kommentar-tab"
                                                  data-toggle="tab" href="#nav-kommentar" role="tab"
                                                  aria-controls="nav-kommentar" aria-selected="true"
                                                  >Kommentar</a>
                                                <a class="nav-item nav-link" id="nav-archiv-tab"
                                                  data-toggle="tab" href="#nav-archiv" role="tab"
                                                  aria-controls="nav-archiv" aria-selected="true"
                                                  >Archiv</a>
                                                <a class="nav-item nav-link" id="nav-person-tab"
                                                  data-toggle="tab" href="#nav-person" role="tab"
                                                  aria-controls="nav-person" aria-selected="true"
                                                  >Personen</a>
                                                <a class="nav-item nav-link" id="nav-werk-tab"
                                                  data-toggle="tab" href="#nav-werk" role="tab"
                                                  aria-controls="nav-werk" aria-selected="false"
                                                  >Werke</a>
                                                <a class="nav-item nav-link" id="nav-org-tab"
                                                  data-toggle="tab" href="#nav-org" role="tab"
                                                  aria-controls="nav-org" aria-selected="false"
                                                  >Institutionen</a>
                                                <a class="nav-item nav-link active" id="nav-ort-tab"
                                                  data-toggle="tab" href="#nav-ort" role="tab"
                                                  aria-controls="nav-ort" aria-selected="false"
                                                  >Orte</a>
                                                <a class="nav-item nav-link" id="nav-zitat-tab"
                                                  data-toggle="tab" href="#nav-zitat" role="tab"
                                                  aria-controls="nav-zitat" aria-selected="false"
                                                  >Zitieren</a>
                                                <a class="nav-item nav-link"
                                                  id="nav-verschiedenes-tab" data-toggle="tab"
                                                  href="#nav-verschiedenes" role="tab"
                                                  aria-controls="nav-verschiedenes"
                                                  aria-selected="false">Verschiedenes</a>
                                            </div>
                                        </nav>
                                        <div class="tab-content" id="nav-tabContent show active">
                                            <div class="tab-pane" id="nav-kommentar" role="tabpanel"
                                                aria-labelledby="nav-kommentar-tab">
                                                <div class="card-body-anhang">
                                                  <dl class="kommentarhang">
                                                      <xsl:variable name="bodydody" select="descendant::tei:body" as="node()"/>
                                                      
                                                  <xsl:for-each
                                                  select="$bodydody/descendant::tei:anchor[@type = 'commentary' or @type = 'textConst']/@xml:id">
                                                      <xsl:variable name="xmlid" select="."/>
                                                      <xsl:variable name="xmlidmith" select="concat(., 'h')"/>
                                                      <xsl:apply-templates select="$bodydody/descendant::tei:anchor[@xml:id=$xmlid]" mode="anhang"/>
                                                      <xsl:apply-templates select="$bodydody/descendant::tei:note[@xml:id=$xmlidmith]" mode="anhang"/>
                                                  </xsl:for-each>
                                                  </dl>
                                                </div>
                                            </div>
                                            <div class="tab-pane" id="nav-archiv" role="tabpanel"
                                                aria-labelledby="nav-archiv-tab">
                                                <div class="card-body-anhang">
                                                  <xsl:if
                                                  test="descendant::tei:teiHeader/descendant::tei:correspDesc">
                                                  <h3>Versand</h3>
                                                  <xsl:apply-templates
                                                  select="descendant::tei:teiHeader/descendant::tei:correspDesc"
                                                  />
                                                  </xsl:if>
                                                  <xsl:if
                                                  test="descendant::tei:teiHeader/descendant::tei:listWit">
                                                  <h3>Archivzeugen</h3>
                                                  <xsl:for-each
                                                  select="descendant::tei:teiHeader/descendant::tei:witness">
                                                  <h4>
                                                  <xsl:value-of select="position()"/>
                                                  </h4>
                                                  <xsl:apply-templates select="."/>
                                                  </xsl:for-each>
                                                  </xsl:if>
                                                  <xsl:if
                                                  test="descendant::tei:teiHeader/descendant::tei:listBibl">
                                                  <h3>Drucke</h3>
                                                  <xsl:for-each
                                                  select="descendant::tei:teiHeader/descendant::tei:listBibl/tei:biblStruct">
                                                  <h4>
                                                  <xsl:value-of select="position()"/>
                                                  </h4>
                                                  <xsl:apply-templates select="."/>
                                                  </xsl:for-each>
                                                  </xsl:if>
                                                </div>
                                            </div>
                                            <div class="tab-pane" id="nav-person" role="tabpanel"
                                                aria-labelledby="nav-person-tab">
                                                <legend>Personen</legend>
                                                <ul>
                                                  <xsl:for-each
                                                  select=".//tei:listPerson//tei:person">
                                                  <xsl:sort
                                                  select="concat(child::tei:persName[1]/tei:surname[1], child::tei:persName[1]/tei:forename[1])"/>
                                                  <xsl:variable name="naname" as="xs:string">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="child::tei:persName[1]/tei:surname[1] and child::tei:persName[1]/tei:forename[1]">
                                                  <xsl:value-of
                                                  select="concat(child::tei:persName[1]/tei:surname[1], ' ', child::tei:persName[1]/tei:forename[1])"
                                                  />
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="child::tei:persName[1]/tei:forename[1]">
                                                  <xsl:value-of select="child::tei:forename[1]"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of select="child::tei:surname[1]"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:variable>
                                                  <li>
                                                  <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="concat(data(@xml:id), '.html')"/>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="$naname"/>
                                                  </a>
                                                  </li>
                                                  </xsl:for-each>
                                                </ul>
                                            </div>
                                            <div class="tab-pane fade" id="nav-werk" role="tabpanel"
                                                aria-labelledby="nav-werk-tab">
                                                <legend>Werke</legend>
                                                <ul>
                                                  <xsl:for-each select=".//tei:listBibl//tei:bibl">
                                                  <xsl:sort select="child::tei:title[1]"/>
                                                  <li>
                                                  <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="concat(data(@xml:id), '.html')"/>
                                                  </xsl:attribute>
                                                  <xsl:if
                                                  test="child::tei:author[@role = 'hat-geschaffen' or @role = 'author']">
                                                  <xsl:for-each
                                                  select="child::tei:author[@role = 'hat-geschaffen' or @role = 'author']">
                                                  <xsl:sort
                                                  select="concat(., child::tei:surname[1], child::tei:forename[1])"/>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="child::tei:surname[1] or child::tei:forename[1]">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="child::tei:surname[1] and child::tei:forename[1]">
                                                  <xsl:value-of
                                                  select="concat(child::tei:surname[1], ' ', child::tei:forename[1])"
                                                  />
                                                  </xsl:when>
                                                  <xsl:when test="child::tei:forename[1]">
                                                  <xsl:value-of select="child::tei:forename[1]"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of select="child::tei:surname[1]"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  <xsl:if test="position() != last()">
                                                  <xsl:text>, </xsl:text>
                                                  </xsl:if>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of select="."/>
                                                  <xsl:if test="position() != last()">
                                                  <xsl:text>; </xsl:text>
                                                  </xsl:if>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  <xsl:if test="position() = last()">
                                                  <xsl:text>: </xsl:text>
                                                  </xsl:if>
                                                  </xsl:for-each>
                                                  </xsl:if>
                                                  <xsl:value-of select="./tei:title[1]"/>
                                                  </a>
                                                  </li>
                                                  </xsl:for-each>
                                                </ul>
                                            </div>
                                            <div class="tab-pane fade" id="nav-org" role="tabpanel"
                                                aria-labelledby="nav-org-tab">
                                                <legend>Institutionen</legend>
                                                <ul>
                                                  <xsl:for-each select=".//tei:listOrg//tei:org">
                                                  <xsl:sort select="child::tei:orgName[1]"/>
                                                  <li>
                                                  <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="concat(data(@xml:id), '.html')"/>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="./tei:orgName[1]"/>
                                                  </a>
                                                  </li>
                                                  </xsl:for-each>
                                                </ul>
                                            </div>
                                            <div class="tab-pane fade fade" id="nav-ort"
                                                role="tabpanel" aria-labelledby="nav-ort-tab">
                                                <legend>Orte</legend>
                                                <div class="row">
                                                  <div class="col-md-4">
                                                  <ul>
                                                  <xsl:for-each select=".//tei:listPlace/tei:place">
                                                  <xsl:sort select="child::tei:placeName[1]"/>
                                                  <li>
                                                  <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="concat(data(@xml:id), '.html')"/>
                                                  </xsl:attribute>
                                                  <xsl:value-of
                                                  select="child::tei:placeName[1]/text()"/>
                                                  </a>
                                                  <xsl:if
                                                  test="child::tei:placeName[@type = 'alternative-name'][1]">
                                                  <xsl:text> (</xsl:text>
                                                  <xsl:for-each
                                                  select="child::tei:placeName[@type = 'alternative-name']">
                                                  <xsl:value-of select="normalize-space(.)"/>
                                                  <xsl:if test="position() != last()">
                                                  <xsl:text>, </xsl:text>
                                                  </xsl:if>
                                                  </xsl:for-each>
                                                  <xsl:text>)</xsl:text>
                                                  </xsl:if>
                                                  </li>
                                                  </xsl:for-each>
                                                  </ul>
                                                  </div>
                                                  <div id="mapid" style="height: 400px;"
                                                  class="col-md-8"/>
                                                </div>
                                                <!-- Funktioniert nur, wenn das der active-tab ist.
                                                
                                                <link rel="stylesheet"
                                                href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css"
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
                                                    <xsl:for-each select=".//tei:listPlace/tei:place">
                                                        <xsl:variable name="laenge" as="xs:string" select="replace(tokenize(tei:location[@type = 'coords'][1]/tei:geo[1]/text(), ' ')[1], ',', '.')"/>
                                                        <xsl:variable name="breite" as="xs:string" select="replace(tokenize(tei:location[@type = 'coords'][1]/tei:geo[1]/text(), ' ')[2], ',', '.')"/>
                                                        <xsl:variable name="laengebreite" as="xs:string" select="concat($laenge, ', ', $breite)"/>
                                                        <xsl:value-of select="$laengebreite"/>
                                                        L.marker([<xsl:value-of select="$laengebreite"/>]).addTo(mymap)
                                                        .bindPopup("<b>
                                                            <xsl:value-of select="./tei:placeName[1]/text()"/>
                                                        </b>").openPopup();
                                                    </xsl:for-each>
                                                </script>-->
                                            </div>
                                            <div class="tab-pane fade" id="nav-zitat"
                                                role="tabpanel" aria-labelledby="nav-zitat-tab">
                                                <legend>Zitiervorschlag</legend>
                                                <p><xsl:value-of select="$doc_title"/>. In: Hermann
                                                  Bahr, Arthur Schnitzler: Briefwechsel,
                                                  Aufzeichnungen, Dokumente (1891–1931). Digitale
                                                  Edition Hg. Kurt Ifkovits, Martin Anton Müller,
                                                  (Stand <xsl:value-of select="$currentDate"/>),
                                                  <xsl:value-of select="$handle"/>.</p>
                                            </div>
                                            <div class="tab-pane fade" id="nav-verschiedenes"
                                                role="tabpanel"
                                                aria-labelledby="nav-verschiedenes-tab">
                                                <legend>Verschiedenes</legend>
                                                <h3>Quellcode</h3>
                                                <p>Code als <a class="ml-3" data-toggle="tooltip"
                                                  title="Link zur TEI-Datei">
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of select="$teiSource"/>
                                                  </xsl:attribute>
                                                  <i class="fa-lg far fa-file-code"/> TEI </a>
                                                </p>
                                                <h3>correspSearch</h3>
                                                <p>
                                                  <div id="csLink" data-correspondent-1-name=""
                                                  data-correspondent-1-id=""
                                                  data-correspondent-2-name=""
                                                  data-correspondent-2-id=""
                                                  data-start-date="{$entryDate}" data-end-date=""
                                                  data-range="50" data-selection-when="before-after"
                                                  data-selection-span="median-before-after"
                                                  data-result-max="4" data-exclude-edition=""/>
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal fade" id="exampleModal" tabindex="-1" role="dialog"
                        aria-labelledby="exampleModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-lg" role="document"
                            style="max-width: 2000px;">
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
                                            sequenceMode: true,
                                            showReferenceStrip: true,
                                            tileSources:[<xsl:for-each select=".//data(@url)">{
                                            type: 'image',
                                            url: '<xsl:value-of select="concat(., '?format=iiif')"/>'
                                            }
                                            <xsl:choose>
                                                <xsl:when test="position() != last()">,</xsl:when>
                                            </xsl:choose></xsl:for-each>
]
                                    });</script>
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
                        <div class="modal fade" tabindex="-1" role="dialog" aria-hidden="true"
                            id="{$xmlId}">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">
                                            <xsl:value-of
                                                select="normalize-space(string-join(.//tei:persName[1]//text()))"/>
                                            <xsl:text> </xsl:text>
                                            <a href="{concat($xmlId, '.html')}">
                                                <i class="fas fa-external-link-alt"/>
                                            </a>
                                        </h5>
                                    </div>
                                    <div class="modal-body">
                                        <xsl:call-template name="person_detail">
                                            <xsl:with-param name="showNumberOfMentions" select="5"/>
                                        </xsl:call-template>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                            data-dismiss="modal">Schließen</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </xsl:for-each>
                    <xsl:for-each select=".//tei:back//tei:place[@xml:id]">
                        <xsl:variable name="xmlId">
                            <xsl:value-of select="data(./@xml:id)"/>
                        </xsl:variable>
                        <div class="modal fade" tabindex="-1" role="dialog" aria-hidden="true"
                            id="{$xmlId}">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">
                                            <xsl:value-of
                                                select="normalize-space(string-join(.//tei:placeName[1]/text()))"/>
                                            <xsl:text> </xsl:text>
                                            <a href="{concat($xmlId, '.html')}">
                                                <i class="fas fa-external-link-alt"/>
                                            </a>
                                        </h5>
                                    </div>
                                    <div class="modal-body">
                                        <xsl:call-template name="place_detail">
                                            <xsl:with-param name="showNumberOfMentions" select="5"/>
                                        </xsl:call-template>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                            data-dismiss="modal">Schließen</button>
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
                <span class="italics">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="@rend = 'underline'">
                <xsl:choose>
                    <xsl:when test="@n = '1'">
                        <span class="underline">
                            <xsl:apply-templates/>
                        </span>
                    </xsl:when>
                    <xsl:when test="@n = '2'">
                        <span class="doubleUnderline">
                            <xsl:apply-templates/>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="tripleUnderline">
                            <xsl:apply-templates/>
                        </span>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="@rend = 'pre-print'">
                <span class="pre-print">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="@rend = 'bold'">
                <strong>
                    <xsl:apply-templates/>
                </strong>
            </xsl:when>
            <xsl:when test="@rend = 'stamp'">
                <span class="stamp">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="@rend = 'small_caps'">
                <span class="small_caps">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="@rend = 'capitals'">
                <span class="uppercase">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="@rend = 'spaced_out'">
                <span class="spaced_out">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="@rend = 'latintype'">
                <span class="latintype">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="@rend = 'antiqua'">
                <span class="antiqua">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span>
                    <xsl:attribute name="class">
                        <xsl:value-of select="@rend"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </span>
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
    <!--<xsl:template match="tei:head">
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
    </xsl:template>-->
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
                <xsl:value-of select="./@columns"/> Column(s) à <xsl:value-of
                    select="./@ruledLines | ./@writtenLines"/> ruled/written lines:
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
    <xsl:template match="tei:ptr">
        <xsl:variable name="targett">
            <xsl:choose>
                <xsl:when test="starts-with(@target, 'D041') or starts-with(@target, 'L041') or starts-with(@target, 'T03') or starts-with(@target, 'I041')">
                    <xsl:value-of select="concat(@target, '.html')"/>
                </xsl:when>
                <xsl:when test="starts-with(@target, 'LD')">
                   <xsl:variable name="dateiname" select="substring-before(substring(@target, 3), '-')"/>
                   <xsl:value-of select="concat('D041',$dateiname,'.html/#', @target)"/>
                </xsl:when>
                <xsl:when test="starts-with(@target, 'LL')">
                    <xsl:variable name="dateiname" select="substring-before(substring(@target, 3), '-')"/>
                    <xsl:value-of select="concat('L041',$dateiname,'.html/#', @target)"/>
                </xsl:when>
                <xsl:when test="starts-with(@target, 'LI')">
                    <xsl:variable name="dateiname" select="substring-before(substring(@target, 3), '-')"/>
                    <xsl:value-of select="concat('I041',$dateiname,'.html/#', @target)"/>
                </xsl:when>
                <xsl:when test="starts-with(@target, 'LT')">
                    <xsl:variable name="dateiname" select="substring-before(substring(@target, 3), '-')"/>
                    <xsl:value-of select="concat('T003',$dateiname,'.html/#', @target)"/>
                </xsl:when>
                <xsl:when test="starts-with(@target, 'KD')">
                    <xsl:variable name="dateiname" select="substring-before(substring(@target, 3), '-')"/>
                    <xsl:value-of select="concat('D041',$dateiname,'.html/#bottom')"/>
                </xsl:when>
                <xsl:when test="starts-with(@target, 'KK')">
                    <xsl:variable name="dateiname" select="substring-before(substring(@target, 3), '-')"/>
                    <xsl:value-of select="concat('L041',$dateiname,'.html/#bottom')"/>
                </xsl:when>
                <xsl:when test="starts-with(@target, 'KI')">
                    <xsl:variable name="dateiname" select="substring-before(substring(@target, 3), '-')"/>
                    <xsl:value-of select="concat('I041',$dateiname,'.html/#bottom')"/>
                </xsl:when>
                <xsl:when test="starts-with(@target, 'KT')">
                    <xsl:variable name="dateiname" select="substring-before(substring(@target, 3), '-')"/>
                    <xsl:value-of select="concat('T003',$dateiname,'.html/#bottom')"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <a href="{$targett}" class="fas fa-link"/>
    </xsl:template>
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
    <xsl:template match="tei:head">
        <xsl:choose>
            <xsl:when
                test="ancestor::tei:TEI/descendant::tei:listWit or ancestor::tei:TEI/descendant::tei:listBibl">
                <h3><span class="editionText">
                    <xsl:apply-templates/>
                </span></h3>
            </xsl:when>
            <xsl:otherwise>
                <h3><xsl:apply-templates/></h3>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#gemination-m']">
        <span class="gemination">mm</span>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#gemination-n']">
        <span class="gemination">nn</span>
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
    <xsl:template
        match="tei:p[ancestor::tei:body and not(ancestor::tei:note) and not(ancestor::tei:footNote) and not(ancestor::tei:caption) and not(parent::tei:bibl) and not(parent::tei:quote) and not(child::tei:space[@dim])] | tei:dateline | tei:closer">
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
    <xsl:template
        match="tei:p[not(parent::tei:quote) and (ancestor::tei:note or ancestor::tei:footNote or ancestor::tei:caption or parent::tei:bibl)]">
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
    <xsl:template match="tei:div[not(@type = 'address')] | tei:figure">
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
    <xsl:template match="tei:lg[@type = 'poem' and not(descendant::lg[@type = 'stanza'])]">
        <div class="poem editionText">
            <ul>
                <xsl:apply-templates/>
            </ul>
        </div>
    </xsl:template>
    <xsl:template match="tei:lg[@type = 'poem' and descendant::lg[@type = 'stanza']]">
        <div class="poem editionText">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:lg[@type = 'stanza']">
        <ul>
            <xsl:apply-templates/>
        </ul>
        <xsl:if test="not(position() = last())">
            <br/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:l">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    <xsl:template match="tei:back"/>
    <!-- PLAIN REINKOPIERT -->
    <xsl:variable name="currentDate">
        <xsl:value-of select="format-date(current-date(), '[D]. [M]. [Y]')"/>
    </xsl:variable>
    <xsl:function name="foo:analytic-angabe">
        <xsl:param name="gedruckte-quellen" as="node()"/>
        <!--  <xsl:param name="vor-dem-at" as="xs:boolean"/><!-\- Der Parameter ist gesetzt, wenn auch der Sortierungsinhalt vor dem @ ausgegeben werden soll -\-><xsl:param name="quelle-oder-literaturliste" as="xs:boolean"/><!-\- Ists Quelle, kommt der Titel kursiv und der Autor Vorname Name -\->-->
        <xsl:variable name="analytic" as="node()" select="$gedruckte-quellen/tei:analytic"/>
        <xsl:choose>
            <xsl:when test="$analytic/tei:author[2]">
                <xsl:value-of
                    select="foo:autor-rekursion($analytic, 1, count($analytic/tei:author))"/>
                <xsl:text>: </xsl:text>
            </xsl:when>
            <xsl:when test="$analytic/tei:author[1]">
                <xsl:value-of select="foo:vorname-vor-nachname($analytic/tei:author)"/>
                <xsl:text>: </xsl:text>
            </xsl:when>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="not($analytic/tei:title/@type = 'j')">
                <span class="italic">
                    <xsl:value-of select="normalize-space($analytic/tei:title)"/>
                    <xsl:choose>
                        <xsl:when test="ends-with(normalize-space($analytic/tei:title), '!')"/>
                        <xsl:when test="ends-with(normalize-space($analytic/tei:title), '?')"/>
                        <xsl:otherwise>
                            <xsl:text>.</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="normalize-space($analytic/tei:title)"/>
                <xsl:choose>
                    <xsl:when test="ends-with(normalize-space($analytic/tei:title), '!')"/>
                    <xsl:when test="ends-with(normalize-space($analytic/tei:title), '?')"/>
                    <xsl:otherwise>
                        <xsl:text>.</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="$analytic/tei:editor[1]">
            <xsl:text>. </xsl:text>
            <xsl:choose>
                <xsl:when test="$analytic/tei:editor[2]">
                    <xsl:text>Hg. </xsl:text>
                    <xsl:value-of
                        select="foo:editor-rekursion($analytic, 1, count($analytic/tei:editor))"/>
                </xsl:when>
                <xsl:when
                    test="$analytic/tei:editor[1] and contains($analytic/tei:editor[1], ', ') and not(count(contains($analytic/tei:editor[1], ' ')) &gt; 2) and not(contains($analytic/tei:editor[1], 'Hg') or contains($analytic/tei:editor[1], 'Hrsg'))">
                    <xsl:text>Hg. </xsl:text>
                    <xsl:value-of select="foo:vorname-vor-nachname($analytic/tei:editor/text())"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$analytic/tei:editor/text()"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>.</xsl:text>
        </xsl:if>
    </xsl:function>
    <xsl:function name="foo:monogr-angabe">
        <xsl:param name="monogr" as="node()"/>
        <xsl:choose>
            <xsl:when test="$monogr/tei:author[2]">
                <xsl:value-of select="foo:autor-rekursion($monogr, 1, count($monogr/tei:author))"/>
                <xsl:text>: </xsl:text>
            </xsl:when>
            <xsl:when test="$monogr/tei:author[1]">
                <xsl:value-of select="foo:vorname-vor-nachname($monogr/tei:author/text())"/>
                <xsl:text>: </xsl:text>
            </xsl:when>
        </xsl:choose>
        <xsl:value-of select="$monogr/tei:title"/>
        <xsl:if test="$monogr/tei:editor[1]">
            <xsl:text>. </xsl:text>
            <xsl:choose>
                <xsl:when test="$monogr/tei:editor[2]">
                    <!-- es gibt mehr als einen Herausgeber -->
                    <xsl:text>Hgg. </xsl:text>
                    <xsl:for-each select="$monogr/tei:editor">
                        <xsl:choose>
                            <xsl:when test="contains(., ', ')">
                                <xsl:value-of
                                    select="concat(substring-after(normalize-space(.), ', '), ' ', substring-before(normalize-space(.), ', '))"
                                />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="."/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="position() = last()"/>
                            <xsl:when test="position() = last() - 1">
                                <xsl:text> und </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>, </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when
                    test="contains($monogr/tei:editor, 'Hg.') or contains($monogr/tei:editor, 'Hrsg.') or contains($monogr/tei:editor, 'erausge') or contains($monogr/tei:editor, 'Edited')">
                    <xsl:value-of select="$monogr/tei:editor"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Hg. </xsl:text>
                    <xsl:choose>
                        <xsl:when test="contains($monogr/tei:editor, ', ')">
                            <xsl:value-of
                                select="concat(substring-after(normalize-space($monogr/tei:editor), ', '), ' ', substring-before(normalize-space($monogr/tei:editor), ', '))"
                            />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$monogr/tei:editor"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$monogr/tei:edition">
            <xsl:text>. </xsl:text>
            <xsl:value-of select="$monogr/tei:edition"/>
        </xsl:if>
        <xsl:choose>
            <!-- Hier Abfrage, ob es ein Journal ist -->
            <xsl:when test="$monogr/tei:title[@level = 'j']">
                <xsl:value-of select="foo:jg-bd-nr($monogr)"/>
            </xsl:when>
            <!-- Im anderen Fall müsste es ein 'm' für monographic sein -->
            <xsl:otherwise>
                <xsl:if test="$monogr[child::tei:imprint]">
                    <xsl:text>. </xsl:text>
                    <xsl:value-of select="foo:imprint-in-index($monogr)"/>
                </xsl:if>
                <xsl:if test="$monogr/tei:biblScope/@unit = 'vol'">
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$monogr/tei:biblScope[@unit = 'vol']"/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function name="foo:autor-rekursion">
        <xsl:param name="monogr" as="node()"/>
        <xsl:param name="autor-count"/>
        <xsl:param name="autor-count-gesamt"/>
        <!-- in den Fällen, wo ein Text unter einem Kürzel erschien, wird zum sortieren der key-Wert verwendet -->
        <xsl:value-of select="foo:vorname-vor-nachname($monogr/tei:author[$autor-count])"/>
        <xsl:if test="$autor-count &lt; $autor-count-gesamt">
            <xsl:text>, </xsl:text>
            <xsl:value-of
                select="foo:autor-rekursion($monogr, $autor-count + 1, $autor-count-gesamt)"/>
        </xsl:if>
    </xsl:function>
    <xsl:function name="foo:editor-rekursion">
        <xsl:param name="monogr" as="node()"/>
        <xsl:param name="autor-count"/>
        <xsl:param name="autor-count-gesamt"/>
        <!-- in den Fällen, wo ein Text unter einem Kürzel erschien, wird zum sortieren der key-Wert verwendet -->
        <xsl:value-of select="foo:vorname-vor-nachname($monogr/tei:editor[$autor-count])"/>
        <xsl:if test="$autor-count &lt; $autor-count-gesamt">
            <xsl:text>, </xsl:text>
            <xsl:value-of
                select="foo:autor-rekursion($monogr, $autor-count + 1, $autor-count-gesamt)"/>
        </xsl:if>
    </xsl:function>
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
    <xsl:function name="foo:jg-bd-nr">
        <xsl:param name="monogr"/>
        <!-- Ist Jahrgang vorhanden, stehts als erstes -->
        <xsl:if test="$monogr//tei:biblScope[@unit = 'jg']">
            <xsl:text>, Jg. </xsl:text>
            <xsl:value-of select="$monogr//tei:biblScope[@unit = 'jg']"/>
        </xsl:if>
        <!-- Ist Band vorhanden, stets auch -->
        <xsl:if test="$monogr//tei:biblScope[@unit = 'vol']">
            <xsl:text>, Bd. </xsl:text>
            <xsl:value-of select="$monogr//tei:biblScope[@unit = 'vol']"/>
        </xsl:if>
        <!-- Jetzt abfragen, wie viel vom Datum vorhanden: vier Stellen=Jahr, sechs Stellen: Jahr und Monat, acht Stellen: komplettes Datum
              Damit entscheidet sich, wo das Datum platziert wird, vor der Nr. oder danach, oder mit Komma am Schluss -->
        <xsl:choose>
            <xsl:when test="string-length($monogr/tei:imprint/tei:date/@when) = 4">
                <xsl:text> (</xsl:text>
                <xsl:value-of select="$monogr/tei:imprint/tei:date"/>
                <xsl:text>)</xsl:text>
                <xsl:if test="$monogr//tei:biblScope[@unit = 'nr']">
                    <xsl:text> Nr. </xsl:text>
                    <xsl:value-of select="$monogr//tei:biblScope[@unit = 'nr']"/>
                </xsl:if>
            </xsl:when>
            <xsl:when test="string-length($monogr/tei:imprint/tei:date/@when) = 6">
                <xsl:if test="$monogr//tei:biblScope[@unit = 'nr']">
                    <xsl:text>, Nr. </xsl:text>
                    <xsl:value-of select="$monogr//tei:biblScope[@unit = 'nr']"/>
                </xsl:if>
                <xsl:text> (</xsl:text>
                <xsl:value-of select="normalize-space(($monogr/tei:imprint/tei:date))"/>
                <xsl:text>)</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="$monogr//tei:biblScope[@unit = 'nr']">
                    <xsl:text>, Nr. </xsl:text>
                    <xsl:value-of select="$monogr//tei:biblScope[@unit = 'nr']"/>
                </xsl:if>
                <xsl:if test="$monogr/tei:imprint/tei:date">
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="normalize-space(($monogr/tei:imprint/tei:date))"/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function name="foo:imprint-in-index">
        <xsl:param name="monogr" as="node()"/>
        <xsl:variable name="imprint" as="node()" select="$monogr/tei:imprint"/>
        <xsl:choose>
            <xsl:when test="$imprint/tei:pubPlace != ''">
                <xsl:value-of select="$imprint/tei:pubPlace" separator=", "/>
                <xsl:choose>
                    <xsl:when test="$imprint/tei:publisher != ''">
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="$imprint/tei:publisher"/>
                        <xsl:choose>
                            <xsl:when test="$imprint/tei:date != ''">
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="$imprint/tei:date"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$imprint/tei:date != ''">
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="$imprint/tei:date"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$imprint/tei:publisher != ''">
                        <xsl:value-of select="$imprint/tei:publisher"/>
                        <xsl:choose>
                            <xsl:when test="$imprint/tei:date != ''">
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="$imprint/tei:date"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$imprint/tei:date != ''">
                        <xsl:text>(</xsl:text>
                        <xsl:value-of select="$imprint/tei:date"/>
                        <xsl:text>)</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:template match="anchor[@type = 'label']">
        <xsl:choose>
            <xsl:when test="ends-with(@id, 'v') or ends-with(@id, 'h')">
                <xsl:text>\label{</xsl:text>
                <xsl:value-of select="@id"/>
                <xsl:text>}</xsl:text>
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>\label{</xsl:text>
                <xsl:value-of select="@id"/>
                <xsl:text>v}</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>\label{</xsl:text>
                <xsl:value-of select="@id"/>
                <xsl:text>h}</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- anchors in Fussnoten, sehr seltener Fall-->
    <xsl:template
        match="anchor[(@type = 'textConst' or @type = 'commentary') and ancestor::footNote]">
        <xsl:variable name="xmlid" select="concat(@id, 'h')"/>
        <xsl:text>\label{</xsl:text>
        <xsl:value-of select="@id"/>
        <xsl:text>v}</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>\toendnotes[C]{\begin{minipage}[t]{4em}{\makebox[3.6em][r]{\tiny{Fußnote}}}\end{minipage}\begin{minipage}[t]{\dimexpr\linewidth-4em}\textit{</xsl:text>
        <xsl:for-each-group select="following-sibling::node()"
            group-ending-with="note[@type = 'commentary']">
            <xsl:if test="position() eq 1">
                <xsl:apply-templates select="current-group()[position() != last()]" mode="lemma"/>
                <xsl:text>}\,{]} </xsl:text>
                <xsl:apply-templates select="current-group()[position() = last()]" mode="text"/>
                <xsl:text>\end{minipage}\par}</xsl:text>
            </xsl:if>
        </xsl:for-each-group>
    </xsl:template>
    <!-- Normaler anchor, Inhalt leer -->
    <xsl:template
        match="tei:anchor[(@type = 'textConst' or @type = 'commentary') and not(ancestor::tei:footNote)]">
        <xsl:variable name="typ-i-typ" select="@type"/>
        <xsl:variable name="lemmatext" as="xs:string">
            <xsl:for-each-group select="following-sibling::node()"
                group-ending-with="tei:note[@type = $typ-i-typ]">
                <xsl:if test="position() eq 1">
                    <xsl:apply-templates select="current-group()[position() != last()]" mode="lemma"
                    />
                </xsl:if>
            </xsl:for-each-group>
        </xsl:variable>
        <span>
            <xsl:attribute name="id">
                <xsl:value-of select="concat(@xml:id, 'v')"/>
            </xsl:attribute>
        </span>
        <xsl:apply-templates/>
    </xsl:template>
    <!-- Kommentar und textConst -->
    <xsl:template match="tei:space[@unit = 'chars' and @quantity = '1']" mode="lemma">
        <xsl:text> </xsl:text>
    </xsl:template>
    <xsl:template match="tei:note[(@type = 'textConst' or @type = 'commentary')]"/>
    <xsl:template match="tei:anchor[@type = 'commentary' or @type = 'textConst']" mode="anhang">
        <dt>
            <xsl:variable name="lemma-start" as="xs:string"
                select="@xml:id"/>
            <xsl:variable name="lemma-end" as="xs:string" select="concat(@xml:id, 'h')"/>
            <xsl:variable name="lemmaganz">
                <xsl:for-each-group
                    select="ancestor::tei:body/descendant::tei:anchor[@xml:id = $lemma-start]/following-sibling::node()"
                    group-ending-with="tei:note[@xml:id = $lemma-end]">
                    <xsl:if test="position() eq 1">
                        <xsl:apply-templates select="current-group()[position() != last()]" mode="lemma"
                        />
                    </xsl:if>
                </xsl:for-each-group>
            </xsl:variable>
            <xsl:variable name="lemma" as="xs:string">
                <xsl:choose>
                    <xsl:when test="not(contains($lemmaganz, ' '))">
                        <xsl:value-of select="$lemmaganz"/>
                    </xsl:when>
                    <xsl:when test="string-length(normalize-space($lemmaganz)) &gt; 24">
                        <xsl:variable name="lemma-kurz"
                            select="concat(tokenize(normalize-space($lemmaganz), ' ')[1], ' … ', tokenize(normalize-space($lemmaganz), ' ')[last()])"/>
                        <xsl:choose>
                            <xsl:when
                                test="string-length(normalize-space($lemmaganz)) - string-length($lemma-kurz) &lt; 5">
                                <xsl:value-of select="normalize-space($lemmaganz)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$lemma-kurz"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$lemmaganz"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="string-length($lemma) &gt; 0">
                    <xsl:value-of select="$lemma"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>XXXX Lemmafehler</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>]&nbsp;</xsl:text>
        </dt>
    </xsl:template>
    
    
    <xsl:template match="tei:note[(@type = 'textConst' or @type = 'commentary')]" mode="anhang">
       <dd>
        <xsl:apply-templates select="tei:p/node() except Lemma"/>
        <span>
            <xsl:attribute name="id">
                <xsl:value-of select="concat(@xml:id, 'h')"/>
            </xsl:attribute>
        </span>
       </dd>
    </xsl:template>
    <xsl:template
        match="tei:note[(@type = 'textConst' or @type = 'commentary') and (ancestor::tei:footNote)]">
        <span>
            <xsl:attribute name="id">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
        </span>
    </xsl:template>
    <xsl:template match="tei:add[@place and not(parent::tei:subst)]">
        <span class="add">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:physDesc">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:msIdentifier">
        <h4>Signatur</h4>
        <p>
            <xsl:value-of select="concat(tei:settlement, ', ', tei:repository)"/>
            <xsl:if test="tei:idno and not(tei:idno = '') and not(empty(tei:idno))">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="tei:idno"/>
            </xsl:if>
        </p>
    </xsl:template>
    <!-- Streichung -->
    <xsl:template match="tei:del[not(ancestor::tei:physDesc)]"/>
    <xsl:template match="tei:del[(ancestor::tei:physDesc)]">
        <span class="del">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <!-- Substi -->
    <xsl:template match="tei:subst">
        <span class="subst-add">
            <xsl:apply-templates select="tei:add"/>
        </span>
    </xsl:template>
    <xsl:template match="tei:supplied">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:unclear">
        <xsl:apply-templates/>
    </xsl:template>
    <!-- Titel kursiv, wenn in Kommentar -->
    <xsl:template
        match="tei:rs[@type = 'work' and not(ancestor::tei:quote) and ancestor::tei:note and not(@subtype = 'implied')]/text()">
        <span class="italics">
            <xsl:value-of select="."/>
        </span>
    </xsl:template>
    <xsl:template match="tei:rs[(@ref or @key) and (ancestor::tei:rs)]">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:rs[(@ref or @key) and not(ancestor::tei:rs)]">
        <!-- das template macht aus allen @refs eine liste, die vorne den typ enthält, also beispielsweise
        so: data-keys="work:pmb33436 person:pmb2425 person:pmb2456"
        es gibt ein gemurkse mit den leerzeichen, die zuerst als ä gesetzt werden, damit sie nicht verloren gehen-->
        <xsl:variable name="unteres-element-liste">
            <xsl:for-each select="descendant::tei:rs">
                <xsl:variable name="type" select="concat(@type, ':')"/>
                <xsl:for-each select="tokenize(@ref, ' ')">
                    <xsl:value-of select="concat($type, substring(., 2))"/>
                </xsl:for-each>
                <xsl:text>ä</xsl:text>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="unteres-element" select="(replace($unteres-element-liste, 'ä', ' '))"/>
        <xsl:variable name="current-liste">
            <xsl:variable name="type" select="concat(@type, ':')"/>
            <xsl:for-each select="tokenize(@ref, ' ')">
                <xsl:value-of select="concat($type, substring(., 2), 'ä')"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="current" select="normalize-space(replace($current-liste, 'ä', ' '))"/>
        <xsl:variable name="data-keys" select="(concat($current, ' ', $unteres-element))"/>
        <xsl:element name="a">
            <xsl:attribute name="class">reference-black</xsl:attribute>
            <xsl:choose>
                <xsl:when
                    test="string-length($data-keys) - string-length(translate($data-keys, 'pmb', '')) = 3">
                    <xsl:attribute name="data-type">
                        <xsl:value-of
                            select="concat('list', substring-before($data-keys, ':'), '.xml')"/>
                    </xsl:attribute>
                    <xsl:attribute name="data-key">
                        <xsl:value-of select="normalize-space(substring-after($data-keys, ':'))"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="data-keys">
                        <xsl:value-of select="normalize-space($data-keys)"/>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </xsl:element>
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
    <xsl:template match="tei:body">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#langesS']" mode="lemma-k">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#langesS']" mode="lemma-t">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#langesS']">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#kaufmannsund']">
        <xsl:text>&amp;</xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#kaufmannsund']" mode="lemma-k">
        <xsl:text>&amp;</xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#kaufmannsund']" mode="lemma-t">
        <xsl:text>&amp;</xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#tilde']">~</xsl:template>
    <xsl:template match="tei:c[@rendition = '#tilde']" mode="lemma-k">~</xsl:template>
    <xsl:template match="tei:c[@rendition = '#tilde']" mode="lemma-t">~</xsl:template>
    <xsl:template match="tei:c[@rendition = '#geschwungene-klammer-auf']">
        <xsl:text>{</xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#geschwungene-klammer-zu']">
        <xsl:text>}</xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#geschwungene-klammer-auf']" mode="lemma-k">
        <xsl:text>{</xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#geschwungene-klammer-zu']" mode="lemma-k">
        <xsl:text>}</xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#geschwungene-klammer-auf']" mode="lemma-t">
        <xsl:text>{</xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#geschwungene-klammer-zu']" mode="lemma-t">
        <xsl:text>}</xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#gemination-m']" mode="lemma-k">
        <span class="gemination">mm</span>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#gemination-n']" mode="lemma-k">
        <span class="gemination">nn</span>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#prozent']" mode="lemma-k">
        <xsl:text>%</xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#gemination-m']" mode="lemma-t">
        <span class="gemination">mm</span>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#gemination-n']" mode="lemma-t">
        <span class="gemination">nn</span>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#prozent']" mode="lemma-t">
        <xsl:text>%</xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#prozent']">
        <xsl:text>%</xsl:text>
    </xsl:template>
    <xsl:template match="tei:space[@unit = 'chars' and @quantity = '1']" mode="lemma-k">
        <xsl:text> </xsl:text>
    </xsl:template>
    <xsl:template match="tei:space[@unit = 'chars' and @quantity = '1']" mode="lemma-t">
        <xsl:text> </xsl:text>
    </xsl:template>
    <xsl:function name="foo:spaci-space">
        <xsl:param name="anzahl"/>
        <xsl:param name="gesamt"/>
        <br/>
        <xsl:if test="$anzahl &lt; $gesamt">
            <xsl:value-of select="foo:spaci-space($anzahl, $gesamt)"/>
        </xsl:if>
    </xsl:function>
    <xsl:template match="tei:space[@unit = 'line']">
        <xsl:value-of select="foo:spaci-space(@quantity, @quantity)"/>
    </xsl:template>
    <xsl:function name="foo:dots">
        <xsl:param name="anzahl"/>
        <xsl:text> . </xsl:text>
        <xsl:if test="$anzahl &gt; 1">
            <xsl:value-of select="foo:dots($anzahl - 1)"/>
        </xsl:if>
    </xsl:function>
    <xsl:template match="tei:c[@rendition = '#dots']">
        <xsl:value-of select="foo:dots(@n)"/>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#dots']" mode="lemma-k">
        <xsl:value-of select="foo:dots(@n)"/>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#dots']" mode="lemma-t">
        <xsl:value-of select="foo:dots(@n)"/>
    </xsl:template>
    <xsl:function name="foo:gaps">
        <xsl:param name="anzahl"/>
        <xsl:text>×</xsl:text>
        <xsl:if test="$anzahl &gt; 1">
            <xsl:value-of select="foo:gaps($anzahl - 1)"/>
        </xsl:if>
    </xsl:function>
    <xsl:template match="tei:graphic">
        <div style="width:100%; text-align:center; padding-bottom: 1rem;">
            <img>
                <xsl:attribute name="src">
                    <xsl:value-of select="concat(@url, '.jpg')"/>
                </xsl:attribute>
                <xsl:attribute name="width">
                    <xsl:text>50%</xsl:text>
                </xsl:attribute>
            </img>
        </div>
    </xsl:template>
    <!-- Verweise auf andere Dokumente   -->
    <xsl:template match="tei:ref[not(@type = 'schnitzlerDiary') and not(@type = 'toLetter')]">
        <xsl:choose>
            <xsl:when test="@target[ends-with(., '.xml')]">
                <xsl:element name="a">
                    <xsl:attribute name="class">reference-black</xsl:attribute>
                    <xsl:attribute name="href"> show.html?ref=<xsl:value-of
                            select="tokenize(./@target, '/')[4]"/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:value-of select="@target"/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:ref[@type = 'schnitzlerDiary']">
        <xsl:if test="not(@subtype = 'date-only')">
            <xsl:choose>
                <xsl:when test="@subtype = 'See'">
                    <xsl:text>Siehe </xsl:text>
                </xsl:when>
                <xsl:when test="@subtype = 'Cf'">
                    <xsl:text>Vgl. </xsl:text>
                </xsl:when>
                <xsl:when test="@subtype = 'see'">
                    <xsl:text>siehe </xsl:text>
                </xsl:when>
                <xsl:when test="@subtype = 'cf'">
                    <xsl:text>vgl. </xsl:text>
                </xsl:when>
            </xsl:choose>
            <xsl:text>A. S.: Tagebuch, </xsl:text>
        </xsl:if>
        <a>
            <xsl:attribute name="class">reference-black</xsl:attribute>
            <xsl:attribute name="href">
                <xsl:value-of
                    select="concat('https://schnitzler-tagebuch.acdh.oeaw.ac.at/entry__', @target, '.html')"
                />
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="substring(@target, 9, 1) = '0'">
                    <xsl:value-of select="substring(@target, 10, 1)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring(@target, 9, 2)"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>. </xsl:text>
            <xsl:choose>
                <xsl:when test="substring(@target, 6, 1) = '0'">
                    <xsl:value-of select="substring(@target, 7, 1)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring(@target, 6, 2)"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>. </xsl:text>
            <xsl:value-of select="substring(@target, 1, 4)"/>
        </a>
    </xsl:template>
    <xsl:template match="tei:ref[@type = 'toLetter']">
        <xsl:choose>
            <xsl:when test="@subtype = 'date-only'">
                <a>
                    <xsl:attribute name="class">reference-black</xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of
                            select="concat('https://schnitzler-briefe.acdh.oeaw.ac.at/pages/show.html?document=', @target)"
                        />
                    </xsl:attribute>
                    <xsl:value-of select="tei:date/text()"/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="@subtype = 'See'">
                        <xsl:text>Siehe </xsl:text>
                    </xsl:when>
                    <xsl:when test="@subtype = 'Cf'">
                        <xsl:text>Vgl. </xsl:text>
                    </xsl:when>
                    <xsl:when test="@subtype = 'see'">
                        <xsl:text>siehe </xsl:text>
                    </xsl:when>
                    <xsl:when test="@subtype = 'cf'">
                        <xsl:text>vgl. </xsl:text>
                    </xsl:when>
                </xsl:choose>
                <a>
                    <xsl:attribute name="class">reference-black</xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of
                            select="concat('https://schnitzler-briefe.acdh.oeaw.ac.at/pages/show.html?document=', @target)"
                        />
                    </xsl:attribute>
                    <xsl:value-of select="tei:title/text()"/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- Ergänzungen für neues physDesc -->
    <xsl:template match="tei:incident/tei:desc/tei:stamp">
        <xsl:text>Stempel </xsl:text>
        <xsl:value-of select="@n"/>
        <xsl:text>:</xsl:text>
        <br/>
        <xsl:if test="tei:placeName"> Ort: <xsl:apply-templates select="./tei:placeName"/>
            <br/>
        </xsl:if>
        <xsl:if test="tei:date"> Datum: <xsl:apply-templates select="./tei:date"/>
            <br/>
        </xsl:if>
        <xsl:if test="tei:time"> Zeit: <xsl:apply-templates select="./tei:time"/>
            <br/>
        </xsl:if>
        <xsl:if test="tei:addSpan"> Vorgang: <xsl:apply-templates select="./tei:addSpan"/>
            <br/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:incident">
        <tr>
            <xsl:apply-templates select="tei:desc"/>
        </tr>
    </xsl:template>
    <xsl:template match="tei:additions">
        <xsl:apply-templates select="tei:incident[@type = 'supplement']"/>
        <xsl:apply-templates select="tei:incident[@type = 'postal']"/>
        <xsl:apply-templates select="tei:incident[@type = 'receiver']"/>
        <xsl:apply-templates select="tei:incident[@type = 'archival']"/>
        <xsl:apply-templates select="tei:incident[@type = 'additional-information']"/>
        <xsl:apply-templates select="tei:incident[@type = 'editorial']"/>
    </xsl:template>
    <xsl:template match="tei:incident[@type = 'supplement']/tei:desc">
        <tr>
            <xsl:variable name="poschitzion"
                select="count(parent::tei:incident/preceding-sibling::tei:incident[@type = 'supplement'])"/>
            <xsl:choose>
                <xsl:when test="$poschitzion &gt; 0">
                    <td/>
                    <td>
                        <xsl:value-of select="$poschitzion + 1"/>
                        <xsl:text>) </xsl:text>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
                <xsl:when
                    test="$poschitzion = 0 and not(parent::tei:incident/following-sibling::tei:incident[@type = 'supplement'])">
                    <th>Beilage</th>
                    <td>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
                <xsl:when
                    test="$poschitzion = 0 and parent::tei:incident/following-sibling::tei:incident[@type = 'supplement']">
                    <th>Beilagen</th>
                    <td>
                        <xsl:value-of select="$poschitzion + 1"/>
                        <xsl:text>) </xsl:text>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
            </xsl:choose>
        </tr>
    </xsl:template>
    <xsl:template match="tei:desc[parent::tei:incident[@type = 'postal']]">
        <xsl:variable name="poschitzion"
            select="count(parent::tei:incident/preceding-sibling::tei:incident[@type = 'postal'])"/>
        <xsl:choose>
            <xsl:when test="$poschitzion &gt; 0">
                <tr>
                    <th/>
                    <td>
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:when>
            <xsl:when
                test="$poschitzion = 0 and not(parent::tei:incident/following-sibling::tei:incident[@type = 'postal'])">
                <tr>
                    <th>
                        <xsl:text>Versand</xsl:text>
                    </th>
                    <td>
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:when>
            <xsl:when
                test="$poschitzion = 0 and parent::tei:incident/following-sibling::tei:incident[@type = 'postal']">
                <tr>
                    <th>
                        <xsl:text>Versand</xsl:text>
                    </th>
                    <td>
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:incident[@type = 'receiver']/tei:desc">
        <tr>
            <xsl:variable name="receiver"
                select="substring-before(ancestor::tei:teiHeader//tei:correspDesc/tei:correspAction[@type = 'received']/tei:persName[1], ',')"/>
            <xsl:variable name="poschitzion"
                select="count(parent::tei:incident/preceding-sibling::tei:incident[@type = 'receiver'])"/>
            <xsl:choose>
                <xsl:when test="$poschitzion &gt; 0">
                    <td/>
                    <td>
                        <xsl:value-of select="$poschitzion + 1"/>
                        <xsl:text>) </xsl:text>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
                <xsl:when
                    test="$poschitzion = 0 and parent::tei:incident/following-sibling::tei:incident[@type = 'receiver']">
                    <th>
                        <xsl:value-of select="$receiver"/>
                    </th>
                    <td>
                        <xsl:value-of select="$poschitzion + 1"/>
                        <xsl:text>) </xsl:text>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
                <xsl:otherwise>
                    <th>
                        <xsl:value-of select="$receiver"/>
                    </th>
                    <td>
                        <xsl:apply-templates/>
                    </td>
                </xsl:otherwise>
            </xsl:choose>
        </tr>
    </xsl:template>
    <xsl:template match="tei:desc[parent::tei:incident[@type = 'archival']]">
        <tr>
            <xsl:variable name="poschitzion"
                select="count(parent::tei:incident/preceding-sibling::tei:incident[@type = 'archival'])"/>
            <xsl:choose>
                <xsl:when test="$poschitzion &gt; 0">
                    <td/>
                    <td>
                        <xsl:value-of select="$poschitzion + 1"/>
                        <xsl:text>) </xsl:text>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
                <xsl:when
                    test="$poschitzion = 0 and not(parent::tei:incident/following-sibling::tei:incident[@type = 'archival'])">
                    <th>
                        <xsl:text>Ordnung</xsl:text>
                    </th>
                    <td>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
                <xsl:when
                    test="$poschitzion = 0 and parent::tei:incident/following-sibling::tei:incident[@type = 'archival']">
                    <th>
                        <xsl:text>Ordnung</xsl:text>
                    </th>
                    <td>
                        <xsl:value-of select="$poschitzion + 1"/>
                        <xsl:text>) </xsl:text>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
            </xsl:choose>
        </tr>
    </xsl:template>
    <xsl:template match="tei:desc[parent::tei:incident[@type = 'additional-information']]">
        <tr>
            <xsl:variable name="poschitzion"
                select="count(parent::tei:incident/preceding-sibling::tei:incident[@type = 'additional-information'])"/>
            <xsl:choose>
                <xsl:when test="$poschitzion &gt; 0">
                    <td/>
                    <td>
                        <xsl:value-of select="$poschitzion + 1"/>
                        <xsl:text>) </xsl:text>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
                <xsl:when
                    test="$poschitzion = 0 and not(parent::tei:incident/following-sibling::tei:incident[@type = 'additional-information'])">
                    <th>
                        <xsl:text>Zusatz</xsl:text>
                    </th>
                    <td>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
                <xsl:when
                    test="$poschitzion = 0 and parent::tei:incident/following-sibling::tei:incident[@type = 'additional-information']">
                    <th>
                        <xsl:text>Zusatz</xsl:text>
                    </th>
                    <td>
                        <xsl:value-of select="$poschitzion + 1"/>
                        <xsl:text>) </xsl:text>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
            </xsl:choose>
        </tr>
    </xsl:template>
    <xsl:template match="tei:desc[parent::tei:incident[@type = 'editorial']]">
        <tr>
            <xsl:variable name="poschitzion"
                select="count(parent::tei:incident/preceding-sibling::tei:incident[@type = 'editorial'])"/>
            <xsl:choose>
                <xsl:when test="$poschitzion &gt; 0">
                    <td/>
                    <td>
                        <xsl:value-of select="$poschitzion + 1"/>
                        <xsl:text>) </xsl:text>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
                <xsl:when
                    test="$poschitzion = 0 and not(parent::tei:incident/following-sibling::tei:incident[@type = 'editorial'])">
                    <th>Editorischer Hinweis</th>
                    <td>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
                <xsl:when
                    test="$poschitzion = 0 and parent::tei:incident/following-sibling::tei:incident[@type = 'editorial']">
                    <th>Editorischer Hinweise</th>
                    <td>
                        <xsl:value-of select="$poschitzion + 1"/>
                        <xsl:text>) </xsl:text>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
            </xsl:choose>
        </tr>
    </xsl:template>
    <xsl:template match="tei:typeDesc">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:typeDesc/tei:p">
        <tr>
            <xsl:choose>
                <xsl:when test="not(preceding-sibling::tei:p)">
                    <th>Typografie</th>
                </xsl:when>
                <xsl:otherwise>
                    <th/>
                </xsl:otherwise>
            </xsl:choose>
            <td>
                <xsl:apply-templates/>
            </td>
        </tr>
    </xsl:template>
    <xsl:template match="tei:handDesc">
        <xsl:choose>
            <!-- Nur eine Handschrift, diese demnach vom Autor/der Autorin: -->
            <xsl:when test="not(child::tei:handNote[2]) and not(tei:handNote/@corresp)">
                <tr>
                    <th>Handschrift</th>
                    <td>
                        <xsl:value-of select="foo:handNote(tei:handNote)"/>
                    </td>
                </tr>
            </xsl:when>
            <!-- Nur eine Handschrift, diese nicht vom Autor/der Autorin: -->
            <xsl:when test="not(child::tei:handNote[2]) and (tei:handNote/@corresp)">
                <xsl:choose>
                    <xsl:when test="handNote/@corresp = 'schreibkraft'">
                        <tr>
                            <th>Handschrift einer Schreibkraft</th>
                            <td>
                                <xsl:value-of select="foo:handNote(tei:handNote)"/>
                            </td>
                        </tr>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="sender"
                            select="ancestor::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[@type = 'sent']/tei:persName[@ref = tei:handNote/@corresp]"/>
                        <tr>
                            <th>Handschrift <xsl:value-of select="$sender"/>
                            </th>
                            <td>
                                <xsl:value-of select="foo:handNote(tei:handNote)"/>
                            </td>
                        </tr>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="handDesc-v" select="current()"/>
                <xsl:variable name="sender"
                    select="ancestor::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[@type = 'sent']"
                    as="node()"/>
                <xsl:for-each select="distinct-values(tei:handNote/@corresp)">
                    <xsl:variable name="corespi" select="."/>
                    <xsl:variable name="corespi-name" select="$sender/tei:persName[@ref = $corespi]"/>
                    <xsl:choose>
                        <xsl:when test="count($handDesc-v/tei:handNote[@corresp = $corespi]) = 1">
                            <tr>
                                <th>Handschrift <xsl:value-of
                                        select="foo:vorname-vor-nachname($corespi-name)"/>
                                </th>
                                <td>
                                    <xsl:value-of
                                        select="foo:handNote($handDesc-v/tei:handNote[@corresp = $corespi])"
                                    />
                                </td>
                            </tr>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select="$handDesc-v/tei:handNote[@corresp = $corespi]">
                                <tr>
                                    <xsl:choose>
                                        <xsl:when test="position() = 1">
                                            <th>Handschrift <xsl:value-of
                                                  select="foo:vorname-vor-nachname($corespi-name)"/>
                                            </th>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <th/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <td>
                                        <xsl:variable name="poschitzon" select="position()"/>
                                        <xsl:value-of select="$poschitzon"/>
                                        <xsl:text>) </xsl:text>
                                        <xsl:value-of select="foo:handNote(current())"/>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:function name="foo:handNote">
        <xsl:param name="entry" as="node()"/>
        <xsl:choose>
            <xsl:when test="$entry/@medium = 'bleistift'">
                <xsl:text>Bleistift</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'roter_buntstift'">
                <xsl:text>roter Buntstift</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'blauer_buntstift'">
                <xsl:text>blauer Buntstift</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'gruener_buntstift'">
                <xsl:text>grüner Buntstift</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'schwarze_tinte'">
                <xsl:text>schwarze Tinte</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'blaue_tinte'">
                <xsl:text>blaue Tinte</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'gruene_tinte'">
                <xsl:text>grüne Tinte</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'rote_tinte'">
                <xsl:text>rote Tinte</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'anderes'">
                <xsl:text>anderes Schreibmittel</xsl:text>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="not($entry/@style = 'nicht_anzuwenden')">
            <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="$entry/@style = 'deutsche-kurrent'">
                <xsl:text>deutsche Kurrentschrift</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@style = 'lateinische-kurrent'">
                <xsl:text>lateinische Kurrentschrift</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@style = 'gabelsberger'">
                <xsl:text>Gabelsberger Kurzschrift</xsl:text>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="string-length(normalize-space($entry/.)) &gt; 1">
            <xsl:text> (</xsl:text>
            <xsl:apply-templates select="($entry/.)"/>
            <xsl:text>)</xsl:text>
        </xsl:if>
    </xsl:function>
    <xsl:template match="tei:objectDesc/tei:desc[@type = '_blaetter']">
        <xsl:choose>
            <xsl:when test="parent::tei:objectDesc/tei:desc/@type = 'karte'">
                <xsl:choose>
                    <xsl:when test="@n = '1'">
                        <xsl:value-of select="concat(@n, ' Karte')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(@n, ' Karten')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="@n = '1'">
                        <xsl:value-of select="concat(@n, ' Blatt')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(@n, ' Blätter')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="string-length(.) &gt; 1">
            <xsl:text> (</xsl:text>
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:text>)</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = '_seiten']">
        <xsl:text>, </xsl:text>
        <xsl:choose>
            <xsl:when test="@n = '1'">
                <xsl:value-of select="concat(@n, ' Seite')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat(@n, ' Seiten')"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="string-length(.) &gt; 1">
            <xsl:text> (</xsl:text>
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:text>)</xsl:text>
        </xsl:if>
        <xsl:if
            test="preceding-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'entwurf' or @type = 'reproduktion'] or following-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'entwurf' or @type = 'reproduktion']">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc">
        <xsl:apply-templates
            select="tei:desc[@type = 'karte' or @type = 'bild' or @type = 'kartenbrief' or @type = 'brief' or @type = 'telegramm' or @type = 'widmung' or @type = 'anderes']"/>
        <xsl:apply-templates select="tei:desc[@type = '_blaetter']"/>
        <xsl:apply-templates select="tei:desc[@type = '_seiten']"/>
        <xsl:apply-templates select="tei:desc[@type = 'umschlag']"/>
        <xsl:apply-templates select="tei:desc[@type = 'reproduktion']"/>
        <xsl:apply-templates select="tei:desc[@type = 'entwurf']"/>
        <xsl:apply-templates select="tei:desc[@type = 'fragment']"/>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'karte']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:when test="@subtype = 'bildpostkarte'">
                <xsl:text>Bildpostkarte</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'postkarte'">
                <xsl:text>Postkarte</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'briefkarte'">
                <xsl:text>Briefkarte</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'visitenkarte'">
                <xsl:text>Visitenkarte</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Karte</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if
            test="(following-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf' or @type = '_blaetter' or @type = '_seiten']) or (preceding-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf' or @type = '_blaetter' or @type = '_seiten'])">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'reproduktion']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:when test="@subtype = 'fotokopie'">
                <xsl:text>Fotokopie</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'fotografische_vervielfaeltigung'">
                <xsl:text>Fotografische Vervielfältigung</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'ms_abschrift'">
                <xsl:text>maschinelle Abschrift</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'hs_abschrift'">
                <xsl:text>handschriftliche Abschrift</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'durchschlag'">
                <xsl:text>maschineller Durchschlag</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Reproduktion</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if
            test="(following-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf' or @type = '_blaetter' or @type = '_seiten']) or (preceding-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf' or @type = '_blaetter' or @type = '_seiten'])">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'widmung']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:when test="@subtype = 'widmung_vorsatzblatt'">
                <xsl:text>Widmung am Vorsatzblatt</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'widmung_titelblatt'">
                <xsl:text>Widmung am Titelblatt</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'widmung_vortitel'">
                <xsl:text>Widmung am Vortitel</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'widmung_schmutztitel'">
                <xsl:text>Widmung am Schmutztitel</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'widmung_umschlag'">
                <xsl:text>Widmung am Umschlag</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Widmung</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if
            test="(following-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf']) or (preceding-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf'])">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'brief']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Brief</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if
            test="(following-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf' or @type = '_blaetter']) or (preceding-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf' or @type = '_blaetter'])">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'bild']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:when test="@subtype = 'fotografie'">
                <xsl:text>Fotografie</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Bild</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if
            test="(following-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf']) or (preceding-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf'])">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'kartenbrief']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Kartenbrief</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if
            test="(following-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf']) or (preceding-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf'])">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'umschlag']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Umschlag</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if
            test="(following-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf']) or (preceding-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf'])">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'telegramm']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Telegramm</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if
            test="(following-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf']) or (preceding-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf'])">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'anderes']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>XXXXAnderes</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if
            test="(following-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf' or @type = '_blaetter' or @type = '_seiten']) or (preceding-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf'])">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'entwurf']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Entwurf</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if
            test="(following-sibling::tei:desc[@type = 'fragment']) or (preceding-sibling::tei:desc[@type = 'fragment'])">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'fragment']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Fragment</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[not(@type)]">
        <xsl:text>XXXX desc-Fehler</xsl:text>
    </xsl:template>
</xsl:stylesheet>
