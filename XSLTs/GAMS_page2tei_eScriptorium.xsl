<?xml version="1.0" encoding="UTF-8"?>

<!-- 
    Project: Projektname
    Author: Bernhard Bauer, Sina Krottmaier
    Company: DDH (Department of Digital Humanities, University of Graz) 
 -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:p="http://schema.primaresearch.org/PAGE/gts/pagecontent/2019-07-15"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://schema.primaresearch.org/PAGE/gts/pagecontent/2019-07-15 http://schema.primaresearch.org/PAGE/gts/pagecontent/2019-07-15/pagecontent.xsd"
    xmlns:mets="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map" xmlns:local="local"
    xmlns:xstring="https://github.com/dariok/XStringUtils" exclude-result-prefixes="#all"
    version="3.0">
    <xsl:output indent="0"/>
    <xd:doc>
        <xd:desc>Entry point: start at the top of METS.xml
                 The teiHeader is based on the Gams Template version from 2021 with the new department name
        </xd:desc>
    </xd:doc>
    <xsl:template match="/mets:mets">
        <TEI xmlns="http://www.tei-c.org/ns/1.0">
            <!-- es ist sinnvoll, die verwendete sprache möglichst weit oben in der hierarchie zu deklarieren und dann nur mehr abweichungen festzulegen -->
            <!-- aus den Guidelines:The xml:lang value will be inherited from the immediately enclosing element, or from its parent, and so on up the document hierarchy. It is generally good practice to specify xml:lang at the highest appropriate level, noticing that a different default may be needed for the teiHeader from that needed for the associated resource element or elements, and that a single TEI document may contain texts in many languages.
        The authoritative list of registered language subtags is maintained by IANA and is available at http://www.iana.org/assignments/language-subtag-registry. -->
            <teiHeader xml:lang="en">
                <fileDesc>
                    <!-- The key words must, must not, required, shall, shall not, should, should not, recommended, may, and optional in this document are to be interpreted as described in RFC 2119. -->
                    <!-- 
            Research team head [rth]   A person who directed or managed a research project
            Research team member [rtm]   A person who participated in a research project but whose role did not involve direction or management of it
            Researcher [res]   A person or organization responsible for performing research  UF Performer of research  
            Project director [pdr]   A person or organization with primary responsibility for all essential aspects of a project, has overall responsibility for managing projects, or provides overall direction to a project manager
            Repository [rps]   An organization that hosts data or material culture objects and provides services to promote long term, consistent and shared use of those data or objects
            Funder [fnd]   A person or organization that furnished financial support for the production of the work
            Author [aut]
            Editor [edt]
            Editor of compilation [edc] A person, family, or organization contributing to a collective or aggregate work by selecting and putting together works, or parts of works, by one or more creators. For compilations of data, information, etc., that result in new works, see compiler
            Markup editor [mrk] A person or organization performing the coding of SGML, HTML, or XML markup of metadata, text, etc.
            Publisher [pbl] A person or organization responsible for publishing, releasing, or issuing a resource
            Creator [cre] A person or organization responsible for the intellectual or artistic content of a resource
            Distribution place [dbp] A place from which a resource, e.g., a serial, is distributed
            Host institution [his] An organization hosting the event, exhibit, conference, etc., which gave rise to a resource, but having little or no responsibility for the content of the resource
            Publication place [pup] The place where a resource is published
            für Kofler: Writer of added commentary [wac] A person, family, or organization contributing to an expression of a work by providing an interpretation or critical explanation of the original work

            für weitere: https://www.loc.gov/marc/relators/relaterm.html
            -->
                    <!-- wenn nicht surname und forename dann  <persName>Nachname, Vorname</persName> -->
                    <titleStmt>
                        <!-- REQUIRED -->
                        <title>
                            <xsl:variable name="docNum">
                                <xsl:analyze-string select="base-uri()" regex="doc\d+_">
                                    <xsl:matching-substring>
                                        <xsl:value-of select="."/>
                                    </xsl:matching-substring>
                                </xsl:analyze-string>
                            </xsl:variable>
                            <xsl:variable name="docName">
                                <xsl:value-of
                                    select="translate(substring-before(substring-after(base-uri(), $docNum), '_pagexml'), '_', ' ')"
                                />
                            </xsl:variable>
                            <xsl:value-of
                                select="concat(upper-case(substring($docName, 1, 1)), substring($docName, 2))"
                            />
                        </title>
                        <!-- abhängig von der Benennung des Dokuments in eScriptorium -->
                        <author ana="marcrelator:aut">
                            <persName ref=""></persName>
                        </author>
                        <!-- oder <persName>Nachname, Vorname</persName>-->
                        <!-- autor der quelle -->
                        <!-- einer der Marcrelator (edt oder trc oder mrk) sollte zumindest vorhanden sein- hier alle 3 nur als Beipiel vorhanden -->
                        <!-- RECOMMENDED aber Beispiel   -->
                        <editor ana="marcrelator:edt">
                            <persName>
                                <forename></forename>
                                <surname></surname>
                            </persName>
                        </editor>
                        <!-- RECOMMENDED aber Beispiel -->
                        <respStmt ana="marcrelator:trc">
                            <resp> Transcription from Original MS</resp>
                            <persName>
                                <forename>Max</forename>
                                <surname>Mustermann</surname>
                            </persName>
                        </respStmt>
                        <!-- RECOMMENDED aber Beispiel -->
                        <respStmt ana="marcrelator:mrk">
                            <resp> XML encoding</resp>
                            <persName>
                                <forename>Max</forename>
                                <surname>Mustermann</surname>
                            </persName>
                        </respStmt>
                        <!-- RECOMMENDED -->
                        <funder ana="marcrelator:fnd">
                            <orgName ref="https://erc.europa.eu/homepage/"></orgName>
                            <num></num>
                            <name type="award"></name>
                        </funder>
                    </titleStmt>
                    <publicationStmt>
                        <!-- publicationStmt sollte unverändert übernommen werden, fixer platz für projektpartner, zim und gams -->
                        <!-- REQUIRED -->
                        <publisher>
                            <orgName ref="http://d-nb.info/gnd/1137284463"
                                corresp="https://digital-humanities.uni-graz.at/de"
                                ><!-- anpassen -->Institut für Digitale Geisteswissenschaften, Universität Graz</orgName>
                        </publisher>
                        <!-- REQUIRED -->
                        <authority ana="marcrelator:his">
                            <orgName ref="http://d-nb.info/gnd/1137284463"
                                corresp="https://digital-humanities.uni-graz.at/en">Department of Digital Humanities, University of Graz</orgName>
                        </authority>
                        <!-- REQUIRED -->
                        <distributor ana="marcrelator:rps">
                            <orgName ref="https://gams.uni-graz.at">GAMS - Geisteswissenschaftliches
                                Asset Management System</orgName>
                        </distributor>
                        <!-- REQUIRED -->
                        <availability>
                            <licence target="https://creativecommons.org/licenses/by-nc/4.0"
                                >Creative Commons BY-NC 4.0</licence>
                            <!-- richtige lizenz auswählen -->
                        </availability>
                        <!-- RECOMMENDED -->
                        <date when="2024" ana="dcterms:issued">2024</date>
                        <!-- Publikationsdatum anpassen-->
                        <!-- dcterms:issued = wann das digitale objekt publiziert wurde-->
                        <!-- REQUIRED -->
                        <pubPlace ana="marcrelator:pup">Graz</pubPlace>
                        <!-- REQUIRED -->
                        <idno type="PID">o:pid.1</idno>
                    </publicationStmt>
                    <seriesStmt>
                        <!-- RECOMMENDED -->
                        <!-- im ref darf nicht der context url stehen also zb http://gams.uni-graz.at/context:fercan  sondern immer der ohne context!!!! -->
                        <title ref=""><!-- link ohne context --><!-- anpassen-->  </title>
                        <title ref="" xml:lang="de"
                            ><!-- link ohne context --><!-- anpassen--></title>
                        <!-- deutsch und englisch angeben -->
                        <!-- übergeordnetes Projekt mit Link angeben -->
                        <!--
               Research team head [rth]   A person who directed or managed a research project
               Research team member [rtm]   A person who participated in a research project but whose role did not involve direction or management of it 
               Project director [pdr]   A person or organization with primary responsibility for all essential aspects of a project, has overall responsibility for managing projects, or provides overall direction to a project manager
       -->
                        <!-- REQUIRED -->
                        <respStmt ana="marcrelator:pdr">
                            <resp>Principal Investigator</resp>
                            <persName>
                                <forename></forename>
                                <surname></surname>
                            </persName>
                        </respStmt>
                        <!-- RECOMMENDED -->
                        <respStmt ana="marcrelator:res">
                            <!--  Researcher-->
                            <resp>ZIM Mitarbeiter</resp>
                            <persName>
                                <forename>Renate</forename>
                                <surname>Musterfrau</surname>
                            </persName>
                        </respStmt>
                    </seriesStmt>
                    <sourceDesc>
                        <msDesc>
                            <msIdentifier>
                                <idno>
                                    <!--Comes from the filename in eScriptorium-->
                                    <xsl:variable name="docNum">
                                        <xsl:analyze-string select="base-uri()" regex="doc\d+_">
                                            <xsl:matching-substring>
                                                <xsl:value-of select="."/>
                                            </xsl:matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:variable>
                                    <xsl:variable name="docName">
                                        <xsl:value-of
                                            select="translate(substring-before(substring-after(base-uri(), $docNum), '_pagexml'), '_', ' ')"
                                        />
                                    </xsl:variable>
                                    <xsl:value-of
                                        select="concat(upper-case(substring($docName, 1, 1)), substring($docName, 2))"
                                    />
                                </idno>
                            </msIdentifier>
                        </msDesc>
                        <bibl>
                            <!-- Optional für Datacite/RECOMMENDED für uns  -->
                            <!-- dcterms:created = wann die quelle entstanden ist -->
                            <date when="" ana="dcterms:created"></date>
                            <!-- RECOMMENDED -->
                            <placeName ref="" ana="marcrelator:prp"
                                ></placeName>
                            <!-- cirilo:normalizedPlaceNames -->
                        </bibl>
                        <!-- wenn Handschrift und <msDesc> verwendet wird dann dort bei ort und Datum ana="dcterms:created" und ana="marcrelator:prp" hinzufügen 
                <msDesc>
                    <msIdentifier></msIdentifier>
                </msDesc>-->
                    </sourceDesc>
                </fileDesc>
                <!-- RECOMMENDED wegen Projektbeschreibung -->
                <encodingDesc>
                    <editorialDecl>
                        <p>was über die editionsregeln und kodierungsrichtlinien</p>
                    </editorialDecl>
                    <projectDesc>
                        <ab>
                            <ref target="context:PROJEKTKÜRZEL" type="context">Projekt Context</ref>
                            <!-- Wurzelkontext -->
                        </ab>
                        <!-- RECOMMENDED -->
                        <p>Projektbeschreibung</p>
                    </projectDesc>
                    <listPrefixDef>
                        <!-- Personen -->
                        <prefixDef ident="marcrelator" matchPattern="([a-z]+)"
                            replacementPattern="http://id.loc.gov/vocabulary/relators/$1">
                            <p>Taxonomie Rollen MARC</p>
                        </prefixDef>
                        <!-- Möglichkeit 1 https://tei-c.org/release/doc/tei-p5-doc/en/html/SA.html#SAPU-->
                        <!-- datum dcterms -->
                        <prefixDef ident="dcterms" matchPattern="([a-z]+)"
                            replacementPattern="http://purl.org/dc/terms/$1">
                            <p>DCterms</p>
                        </prefixDef>
                    </listPrefixDef>
                </encodingDesc>
                <profileDesc>
                    <langUsage>
                        <language ident="la">Latin</language>
                        <!-- sprache des originals, iana code -->
                    </langUsage>
                    <textClass>
                        <!--  <keywords scheme="cirilo:normalizedPlaceNames">
                </keywords>-->
                        <keywords scheme="#">
                            <list>
                                <item>
                                    <term>Digital Humanities</term>
                                </item>
                            </list>
                        </keywords>
                    </textClass>
                </profileDesc>
            </teiHeader>
            <xsl:text>
            </xsl:text>
            
<!--        Here we are creating the template-->
            <facsimile>
                <xsl:apply-templates select="//mets:fileGrp[@USE = 'export']/mets:file"
                    mode="facsimile"/>
                <xsl:text>
            </xsl:text>
            </facsimile>
            <xsl:text>
            </xsl:text>
            
            
<!--            Here we are creating the text with the hierarchy of the page-xml-->
            <text>
                <xsl:text>
            </xsl:text>
                <body>
                    <xsl:text>
            </xsl:text>
                    <div>
                        <xsl:apply-templates select="//mets:fileGrp[@USE = 'export']/mets:file"
                            mode="text"/>
                    </div>
                </body>
                <xsl:text>
            </xsl:text>
            </text>
            <xsl:text>
            </xsl:text>
        </TEI>
    </xsl:template>
          
    <xd:doc>
        <xd:desc>
            <xd:p>Here we are creating the t:facsimile/t:surface for the TEI</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="mets:fileGrp[@USE = 'export']/mets:file" mode="facsimile">
        <xsl:variable name="file" select="document(mets:FLocat/@xlink:href, /)"/>
        <xsl:variable name="numCurr" select="substring-after(@ID, 't')"/>
        <xsl:apply-templates select="$file//p:Page" mode="facsimile">
            <xsl:with-param name="numCurr" select="$numCurr" tunnel="true"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Here we are creating the t:text for the TEI</xd:desc>
    </xd:doc>
    <xsl:template match="mets:fileGrp[@USE = 'export']/mets:file" mode="text">
        <xsl:variable name="file" select="document(mets:FLocat/@xlink:href, /)"/>
        <xsl:variable name="numCurr" select="substring-after(@ID, 't')"/>
        <xsl:apply-templates select="$file//p:Page" mode="text">
            <xsl:with-param name="numCurr" select="$numCurr" tunnel="true"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <!--    START OF THE FACSIMILE TEMPLATES-->
    <xd:doc>
        <xd:desc>Here we are creating the facsimile for each Page in the Page-XML</xd:desc>
        <xd:param name="numCurr">
            <xd:p>Numerus currens of the parent facsimile</xd:p>
        </xd:param>
    </xd:doc>
    <xsl:template match="p:Page" mode="facsimile">
        <xsl:param name="numCurr" tunnel="true"/>
        <xsl:variable name="imageWidth" select="@imageWidth"/>
        <xsl:variable name="imageHeight" select="@imageHeight"/>
        <xsl:variable name="ImageID" select="concat('IMAGE.', $numCurr)"/>
        <xsl:variable name="URL" select="preceding-sibling::p:Metadata/@externalRef"/>
        <xsl:text>
        </xsl:text>
        <surface ulx="0" uly="0" lrx="{$imageWidth}" lry="{$imageHeight}" xml:id="facs_{$numCurr}">
            <xsl:text>
            </xsl:text>
            <graphic url="{$URL}" height="{concat($imageHeight, 'px')}"
                width="{concat($imageWidth, 'px')}" xml:id="{$ImageID}"/>
            <xsl:apply-templates select="p:TextRegion" mode="facsimile"/>
        </surface>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Here we are creating the zones for the TextRegions within the
            facsimile/surface</xd:desc>
        <xd:param name="numCurr">Numerus currens of the current page</xd:param>
    </xd:doc>
    <xsl:template match="p:TextRegion" mode="facsimile">
        <xsl:param name="numCurr" tunnel="true"/>
        <xsl:call-template name="coords"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Here we are creating the zones for the Lines within the TextRegions</xd:desc>
        <xd:param name="numCurr">Numerus currens of the current page</xd:param>
    </xd:doc>
    <xsl:template match="p:TextLine" mode="facsimile">
        <xsl:param name="numCurr" tunnel="true"/>
        <xsl:call-template name="coords"/>
        <!-- x, rx, ry, y -->
    </xsl:template>
    
    <!--    START OF THE TEXT TEMPLATES-->
   
    <xd:doc>
        <xd:desc>Here we are creating the text for each Page in the Page-XML</xd:desc>
        <xd:param name="numCurr">Numerus currens of the current page</xd:param>
    </xd:doc>
    <xsl:template match="p:Page" mode="text">
        <xsl:param name="numCurr" tunnel="true"/>
        <xsl:variable name="ImageID" select="concat('#IMAGE.', $numCurr)"/>
        <xsl:text>
        </xsl:text>
        <pb facs="{$ImageID}">
            <xsl:attribute name="n">
                <xsl:value-of select="$numCurr"/>
            </xsl:attribute>
        </pb>
        <xsl:apply-templates select="descendant::p:TextRegion" mode="text">
            <xsl:with-param name="numCurr" select="$numCurr" tunnel="true"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Here we are creating the text for each TextRegion in the Page-XML</xd:desc>
        <xd:param name="numCurr">Numerus currens of the current page</xd:param>
    </xd:doc>
    <xsl:template match="p:TextRegion" mode="text">
        <xsl:param name="numCurr" tunnel="true"/>
        <xsl:variable name="type" select="substring-before(substring-after(@custom, 'type:'), ';')"/>
        <xsl:text>
            </xsl:text>
        <div type="{$type}">
            <xsl:apply-templates select="descendant::p:TextLine" mode="text">
                <xsl:with-param name="numCurr" select="$numCurr"
                    tunnel="true"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>
        
    <xd:doc>
        <xd:desc>Here we are creating the text for each TextLine in the Page-XML</xd:desc>
    </xd:doc>
    <xsl:template match="p:TextLine" mode="text">
        <xsl:variable name="ID" select="@id"/>
        <xsl:text>            
        </xsl:text>
        <lb facs="{concat('#',$ID)}"/>
        <xsl:apply-templates select="descendant::p:Unicode" mode="text"/>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>Here we change the coordinate points to 4 points (x, rx, ry, y) for the Textregions
            and TextLines. var coords: changes the points to follow this pattern -X,Y-X,Y-... var
            xmin: sorts all the x coordinates lowest to highest; var ymin: sorts all the y
            coordinates from lowest to highest; var xmax: sorts all the x coordinates from highest
            to lowest; var ymax: sorts all the y coordinates from highest to lowest; var XYmin2:
            creates the coordinates for the left upper point; var XmaxYmin: creates the coordinates
            for the right upper point; var XYmax2: creates the coordinates for the right lower
            point; var XminYmax: creates the coordinates for the left lower point; </xd:desc>
    </xd:doc>
    <xsl:template name="coords">
        <xsl:variable name="coords"
            select="concat('-', translate(translate(./p:Coords/@points, ' ', '-'), '-', '- '), '- ')"/>
        <xsl:variable name="Xmin">
            <x>
                <xsl:for-each select="tokenize(translate($coords, '-', ' '))">
                    <xsl:sort select="number(substring-before(., ','))" order="ascending"
                        data-type="number"/>
                    <xsl:value-of select="number(substring-before(., ','))"/>
                    <xsl:if test="not(position() = last())">
                        <xsl:text>,</xsl:text>
                    </xsl:if>
                    <!--    <xsl:value-of select="substring-after(substring-before(., ','), '-')"/>-->
                </xsl:for-each>
            </x>
        </xsl:variable>
        <xsl:variable name="Ymin">
            <y>
                <xsl:for-each select="tokenize(translate($coords, '-', ' '))">
                    <xsl:sort select="number(substring-after(., ','))" order="ascending"
                        data-type="number"/>
                    <xsl:value-of select="number(substring-after(., ','))"/>
                    <xsl:if test="not(position() = last())">
                        <xsl:text>,</xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </y>
        </xsl:variable>
        <xsl:variable name="Xmax">
            <x>
                <xsl:for-each select="tokenize(translate($coords, '-', ' '))">
                    <xsl:sort select="number(substring-before(., ','))" order="descending"
                        data-type="number"/>
                    <xsl:value-of select="number(substring-before(., ','))"/>
                    <xsl:if test="not(position() = last())">
                        <xsl:text>,</xsl:text>
                    </xsl:if>
                    <!--    <xsl:value-of select="substring-after(substring-before(., ','), '-')"/>-->
                </xsl:for-each>
            </x>
        </xsl:variable>
        <xsl:variable name="Ymax">
            <y>
                <xsl:for-each select="tokenize(translate($coords, '-', ' '))">
                    <xsl:sort select="number(substring-after(., ','))" order="descending"
                        data-type="number"/>
                    <xsl:value-of select="number(substring-after(., ','))"/>
                    <xsl:if test="not(position() = last())">
                        <xsl:text>,</xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </y>
        </xsl:variable>
        <xsl:variable name="XYmin2"
            select="concat(substring-before($Xmin, ','), ',', substring-before($Ymin, ','))"/>
        <xsl:variable name="XmaxYmin"
            select="concat(substring-before($Xmax, ','), ',', substring-before($Ymin, ','))"/>
        <xsl:variable name="XYmax2"
            select="concat(substring-before($Xmax, ','), ',', substring-before($Ymax, ','))"/>
        <xsl:variable name="XminYmax"
            select="concat(substring-before($Xmin, ','), ',', substring-before($Ymax, ','))"/>
        <xsl:variable name="ID" select="@id"/>
        <xsl:text>
        </xsl:text>
        <xsl:choose>
            <xsl:when test="name(.) = 'TextRegion'">
                <zone points="{concat($XYmin2, ' ', $XmaxYmin, ' ', $XYmax2, ' ', $XminYmax)}"
                    rendition="{name(.)}" rotate="0" xml:id="{$ID}">
                    <xsl:apply-templates select="p:TextLine" mode="facsimile"/>
                </zone>
            </xsl:when>
            <xsl:otherwise>
                <zone points="{concat($XYmin2, ' ', $XmaxYmin, ' ', $XYmax2, ' ', $XminYmax)}"
                    rendition="{name(.)}" rotate="0" xml:id="{$ID}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
