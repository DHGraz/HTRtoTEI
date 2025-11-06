<?xml version="1.0" encoding="UTF-8"?>

<!-- PagetoTEI used in the Arithmetik Project.
    - based on the pagetotei base file by github@dariok without the additional xslts
    - modified by Bernhard Bauer for the Arithmetic Project
    - worked on by Thomas Zangl, Carina Koch
    - Updated 16.11.2025 by Sina Krottmaier to fix the mapping issue 
    - Current toDos - fix unnessecary Code lines --> 
    
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:p="http://schema.primaresearch.org/PAGE/gts/pagecontent/2013-07-15"
    xmlns:mets="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map" xmlns:local="local"
    exclude-result-prefixes="#all" version="3.0">
    <xsl:output indent="0"/>
    <xd:doc>
        <xd:desc>Whether to create `rs type="..."` for person/place/org (default) or `persName` etc.
            (false())</xd:desc>
    </xd:doc>
    <xsl:param name="rs" select="true()"/>
    <xd:doc>
        <xd:desc>Whether to run white space tokenization</xd:desc>
    </xd:doc>
    <xsl:param name="tokenize" select="false()"/>
    <xd:doc>
        <xd:desc>Whether to combine entities over line breaks</xd:desc>
    </xd:doc>
    <xsl:param name="combine" select="false()"/>
    <xd:doc>
        <xd:desc>If false(), region types that correspond to valid TEI elements will be returned as
            this element; types that do not correspond to a TEI element will be returned as
            tei:ab[@type]. If set to true(), all region types (except for paragraph, heading) will
            be returned as tei:ab.</xd:desc>
    </xd:doc>
    <xsl:param name="ab" select="false()"/>
    <xd:doc>
        <xd:desc>If true(), export the (estimated) word coordinates to the facsimile section.
            Default: false().</xd:desc>
    </xd:doc>
    <xsl:param name="word-coordinates" select="false()"/>
    <xd:doc>
        <xd:desc>Whether to create bounding rectangles from polygons (default: true())</xd:desc>
    </xd:doc>
    <xsl:param name="bounding-rectangles" select="true()"/>
    <xd:doc>
        <xd:desc>Whether to export lines without baseline (true()) or not (false(),
            default)</xd:desc>
    </xd:doc>
    <xsl:param name="withoutBaseline" select="false()"/>
    <xd:doc>
        <xd:desc>Whether to export regions without text lines (true()) or not (false(),
            default)</xd:desc>
    </xd:doc>
    <xsl:param name="withoutTextline" select="false()"/>
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Author:</xd:b> Dario Kampkaspar, dario.kampkaspar@oeaw.ac.at |
                dario.kampkaspar@tu-darmstadt.de</xd:p>
            <xd:p>Austrian Centre for Digital Humanities http://acdh.oeaw.ac.at | University and
                State Library Darmstadt https://ulb.tu-darmstadt.de</xd:p>
            <xd:p/>
            <xd:p>This stylesheet, when applied to mets.xml of the PAGE output, will create (valid)
                TEI</xd:p>
            <xd:p>While this XSLT is designed to run on many different flavours of PAGE-XMLs
                described by a common mets.xml file, some special care was taken to include meta
                data provided by Transkribus; other meta data providers may be included if examples
                are provided.</xd:p>
            <xd:p/>
            <xd:p><xd:b>Contributor</xd:b> Matthias Boenig, github:@tboenig</xd:p>
            <xd:p>OCR-D, Berlin-Brandenburg Academy of Sciences and Humanities
                http://ocr-d.de/eng</xd:p>
            <xd:p>extend the original XSL-Stylesheet by specific elements based on the @typing of
                the text region</xd:p>
            <xd:p/>
            <xd:p><xd:b>Contributor</xd:b> Peter Stadler, github:@peterstadler</xd:p>
            <xd:p>Carl-Maria-von-Weber-Gesamtausgabe</xd:p>
            <xd:p>Added corrections to tei:sic/tei:corr</xd:p>
            <xd:p/>
            <xd:p><xd:b>Contributor</xd:b> Till Grallert, github:@tillgrallert</xd:p>
            <xd:p>Orient-Institut Beirut</xd:p>
            <xd:p>Use tei:ab as fallback instead of tei:p</xd:p>
            <xd:p/>
            <xd:p>The base pagetotei was modified by DDH Uni Graz to fit the needs of the Arithmetic project: </xd:p>
            <xd:p><xd:b>Contributor</xd:b> Bernhard Bauer, github:@BernBa</xd:p>
            <xd:p>DDH</xd:p>
            <xd:p>add structural tags for tables and lines and nodes in the header</xd:p>
            <xd:p/>
            <xd:p><xd:b>Contributor</xd:b> Thomas Zangl</xd:p>
            <xd:p>DDH</xd:p>
            <xd:p></xd:p>
            <xd:p/>
            <xd:p><xd:b>Contributor</xd:b> Carina Koch</xd:p>
            <xd:p>DDH</xd:p>
            <xd:p>excluded additional XSLTs; fixed Bug concerning newest Transkribus Export; </xd:p>
            <xd:p/>
            <xd:p><xd:b>Contributor</xd:b> Sina Krottmaier, github:@krottmas</xd:p>
            <xd:p>DDH</xd:p>
            <xd:p>excluded additional XSLTs; fixed Bug concerning newest Transkribus Export; </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="debug" select="false()"/>
    <xd:doc>
        <xd:desc>helper: gather page contents</xd:desc>
    </xd:doc>
    <xsl:variable name="make_div">
        <div>
            <xsl:apply-templates select="//mets:fileSec//mets:fileGrp[@ID = 'PAGEXML']/mets:file"
                mode="text"/>
        </div>
    </xsl:variable>
    <xd:doc>
        <xd:desc>Entry point: start at the top of METS.xml</xd:desc>
    </xd:doc>
    <xsl:template match="/mets:mets">
        <TEI>
            <xsl:text>
   </xsl:text>
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
                            <xsl:value-of select="mets:amdSec/descendant::trpDocMetadata/title"/>
                            <xsl:variable name="docNum">
                                <xsl:analyze-string select="base-uri()" regex="doc\d_">
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
                            <persName ref=""/>
                        </author>
                        <!-- oder <persName>Nachname, Vorname</persName> -->
                        <!-- autor der quelle -->
                        <!-- einer der Marcrelator (edt oder trc oder mrk) sollte zumindest vorhanden sein- hier alle 3 nur als Beipiel vorhanden -->
                        <!-- RECOMMENDED aber Beispiel   -->
                        <!-- 
                    <editor ana="marcrelator:edt">
                     <persName>
                        <forename></forename>
                        <surname></surname>
                     </persName>
                  </editor> 
                 -->
                        <!-- Projektleitung -->
                        <principal ana="marcrelator:pdr">
                            <persName>
                                <forename>Michaela</forename>
                                <surname>Wiesinger</surname>
                            </persName>
                        </principal>
                        <!-- RECOMMENDED aber Beispiel -->
                        <respStmt ana="marcrelator:trc">
                            <resp>Transcription from Original MS</resp>
                            <persName>
                                <forename>Max</forename>
                                <surname>Mustermann</surname>
                            </persName>
                        </respStmt>
                        <!-- RECOMMENDED aber Beispiel -->
                        <respStmt ana="marcrelator:mrk">
                            <resp>XML encoding</resp>
                            <persName>
                                <forename>Carina</forename>
                                <surname>Koch</surname>
                            </persName>
                        </respStmt>
                        <respStmt ana="marcrelator:mrk">
                            <resp>XML encoding</resp>
                            <persName>
                                <forename>Thomas</forename>
                                <surname>Zangl</surname>
                            </persName>
                        </respStmt>
                        <respStmt ana="marcrelator:mrk">
                            <resp>XML encoding</resp>
                            <persName>
                                <forename>Bernhard</forename>
                                <surname>Bauer</surname>
                            </persName>
                        </respStmt>
                        <!-- RECOMMENDED -->
                        <funder ana="marcrelator:fnd">
                            <orgName ref="https://erc.europa.eu/homepage/"/>
                            <num>101039572</num>
                            <name type="award">ERC Starting-Grant</name>
                        </funder>
                    </titleStmt>
                    <publicationStmt>
                        <!-- publicationStmt sollte unverändert übernommen werden, fixer platz für projektpartner, zim und gams -->
                        <!-- REQUIRED -->
                        <publisher ana="marcrelator:pbl">
                            <orgName ref="http://d-nb.info/gnd/1137284463"
                                corresp="https://digital-humanities.uni-graz.at/de"
                                ><!-- anpassen -->Institut für Digitale Geisteswissenschaften,
                                Universität Graz</orgName>
                        </publisher>
                        <!-- REQUIRED -->
                        <authority ana="marcrelator:his">
                            <orgName ref="http://d-nb.info/gnd/1137284463"
                                corresp="https://digital-humanities.uni-graz.at/en">Department of
                                Digital Humanities, University of Graz</orgName>
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
                        <date when="2025" ana="dcterms:issued">2025</date>
                        <!-- Publikationsdatum anpassen-->
                        <!-- dcterms:issued = wann das digitale objekt publiziert wurde-->
                        <!-- REQUIRED -->
                        <pubPlace ana="marcrelator:pup">Graz</pubPlace>
                        <!-- REQUIRED -->
                        <idno type="PID">
                            <xsl:value-of
                                select="mets:amdSec/descendant::trpDocMetadata/attributes/value"/>
                        </idno>
                    </publicationStmt>
                    <seriesStmt>
                        <!-- RECOMMENDED -->
                        <!-- im ref darf nicht der context url stehen also zb http://gams.uni-graz.at/context:fercan  sondern immer der ohne context!!!! -->
                        <title ref=""><!-- link ohne context --><!-- anpassen-->
                        </title>
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
                                <forename>Michaela</forename>
                                <surname>Wiesinger</surname>
                            </persName>
                        </respStmt>
                        <!-- RECOMMENDED -->
                        <respStmt ana="marcrelator:res">
                            <!--  Researcher-->
                            <resp>DDH staff</resp>
                            <persName>
                                <forename>Bernhard</forename>
                                <surname>Bauer</surname>
                            </persName>
                        </respStmt>
                        <respStmt ana="marcrelator:res">
                            <!--  Researcher-->
                            <resp>DDH staff</resp>
                            <persName>
                                <forename>Carina</forename>
                                <surname>Koch</surname>
                            </persName>
                        </respStmt>
                        <respStmt ana="marcrelator:res">
                            <!--  Researcher-->
                            <resp>DDH staff</resp>
                            <persName>
                                <forename>Thomas</forename>
                                <surname>Zangl</surname>
                            </persName>
                        </respStmt>
                        <respStmt ana="marcrelator:res">
                            <!--  Researcher-->
                            <resp>Universität Innsbruck staff</resp>
                            <persName>
                                <forename>Katharina Maria</forename>
                                <surname>Hofer</surname>
                            </persName>
                        </respStmt>
                        <respStmt ana="marcrelator:res">
                            <!--  Researcher-->
                            <resp>ÖAW staff</resp>
                            <persName>
                                <forename>Christina</forename>
                                <surname>Jackel</surname>
                            </persName>
                        </respStmt>
                        <respStmt ana="marcrelator:res">
                            <!--  Researcher-->
                            <resp>Universität Innsbruck staff</resp>
                            <persName>
                                <forename>Norbert</forename>
                                <surname>Orbán</surname>
                            </persName>
                        </respStmt>
                        <respStmt ana="marcrelator:res">
                            <!--  Researcher-->
                            <resp>Universität Innsbruck staff</resp>
                            <persName>
                                <forename>Franziska</forename>
                                <surname>Putz</surname>
                            </persName>
                        </respStmt>
                        <respStmt ana="marcrelator:res">
                            <!--  Researcher-->
                            <resp>Universität Innsbruck staff</resp>
                            <persName>
                                <forename>Gregor</forename>
                                <surname>Kodym</surname>
                            </persName>
                        </respStmt>
                    </seriesStmt>
                    <sourceDesc>
                        <msDesc>
                            <msIdentifier>
                                <idno>
                                    <!--Comes from the filename in eScriptorium-->
                                    <xsl:variable name="docNum">
                                        <xsl:analyze-string select="base-uri()" regex="doc\d_">
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
                            <date when="" ana="dcterms:created"/>
                            <!-- RECOMMENDED -->
                            <placeName ref="" ana="marcrelator:prp"/>
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
                            <ref target="context:arithmetic" type="context">Arithmetic</ref>
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
                        <language ident="de">German</language>
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
            <facsimile>
                <xsl:apply-templates select="mets:fileSec//mets:fileGrp[@ID = 'PAGEXML']/mets:file"
                    mode="facsimile"/>
                <xsl:text>
   </xsl:text>
            </facsimile>
            <xsl:text>
   </xsl:text>
            <text>
                <xsl:text>
      </xsl:text>
                <body>
                    <xsl:for-each-group select="$make_div//*[local-name() = 'div']/*"
                        group-starting-with="
                     *[local-name() = 'pb' and following-sibling::*[1][local-name() = 'head']]
                     | *[local-name() = 'head' and not(preceding-sibling::*[1][local-name() = 'pb'])]">
                        <xsl:text>
         </xsl:text>
                        <div xmlns="http://www.tei-c.org/ns/1.0">
                            <xsl:variable name="combined">
                                <xsl:choose>
                                    <xsl:when test="$combine">
                                        <xsl:apply-templates select="current-group()"
                                            mode="continued"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:copy-of select="current-group()"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:variable name="combined-hi">
                                <xsl:apply-templates select="$combined" mode="combine-hi"/>
                            </xsl:variable>
                            <xsl:variable name="tokenized">
                                <xsl:choose>
                                    <xsl:when test="$tokenize">
                                        <xsl:apply-templates select="$combined" mode="tokenize"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:copy-of select="$combined"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:for-each select="$tokenized/*">
                                <xsl:text>
            </xsl:text>
                                <xsl:sequence select="."/>
                            </xsl:for-each>
                            <xsl:text>
         </xsl:text>
                        </div>
                    </xsl:for-each-group>
                    <xsl:text>
      </xsl:text>
                </body>
                <xsl:text>
   </xsl:text>
            </text>
            <xsl:text>
</xsl:text>
        </TEI>
    </xsl:template>
    <!-- create teiHeader from METS and (if present) included Transkribus Meta data -->
    <xd:doc>
        <xd:desc>Contents for titleStmt</xd:desc>
    </xd:doc>
    <xsl:template match="mets:amdSec" mode="titleStmt">
        <xsl:apply-templates select="descendant::trpDocMetadata/title"/>
        <xsl:apply-templates select="descendant::trpDocMetadata/author"/>
    </xsl:template>
    <xd:doc>
        <xd:desc>Contents for publicationStmt</xd:desc>
    </xd:doc>
    <xsl:template match="mets:amdSec" mode="publicationStmt">
        <idno type="PID">
            <xsl:value-of select="descendant::trpDocMetadata/attributes/value"/>
        </idno>
        <xsl:apply-templates/>
    </xsl:template>
    <xd:doc>
        <xd:desc>Contents for seriesStmt</xd:desc>
    </xd:doc>
    <xsl:template match="mets:amdSec" mode="seriesStmt">
        <xsl:apply-templates select="descendant::trpDocMetadata//colList[1]/colName"/>
    </xsl:template>
    <xd:doc>
        <xd:desc>Contents for sourceDesc</xd:desc>
    </xd:doc>
    <xsl:template match="mets:amdSec" mode="sourceDesc">
        <xsl:apply-templates select="descendant::trpDocMetadata/title"/>
        <xsl:apply-templates
            select="descendant::trpDocMetadata/author | descendant::trpDocMetadata/writer"/>
        <idno type="Transkribus">
            <xsl:value-of select="descendant::trpDocMetadata/docId"/>
        </idno>
        <xsl:apply-templates select="descendant::trpDocMetadata/externalId"/>
        <xsl:apply-templates select="descendant::trpDocMetadata/desc"/>
    </xsl:template>
    <xd:doc>
        <xd:desc>Contents for editionStmt</xd:desc>
    </xd:doc>
    <xsl:template match="mets:amdSec" mode="editionStmt">
        <p>TRP document creator: <xsl:value-of select="descendant::trpDocMetadata/uploader"/></p>
        <xsl:apply-templates select="mets:amdSec//trpDocMetadata/desc"/>
    </xsl:template>
    <!-- Templates for trpMetaData -->
    <xd:doc>
        <xd:desc>
            <xd:p>The title within the Transkribus meta data</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="title">
        <title>
            <xsl:if test="position() = 1">
                <xsl:attribute name="type">main</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </title>
    </xsl:template>
    <xd:doc>
        <xd:desc>The author as stated in Transkribus meta data. Will be used in the teiHeader as
            titleStmt/author</xd:desc>
    </xd:doc>
    <xsl:template match="author">
        <author>
            <xsl:apply-templates/>
        </author>
    </xsl:template>
    <xd:doc>
        <xd:desc>The author as stated in Transkribus meta data. Will be used in the teiHeader as
            titleStmt/respStmt</xd:desc>
    </xd:doc>
    <xsl:template match="writer">
        <respStmt>
            <resp>Writer</resp>
            <name>
                <xsl:apply-templates/>
            </name>
        </respStmt>
    </xsl:template>
    <xd:doc>
        <xd:desc>The description as given in Transkribus meta data. Will be used in
            sourceDesc</xd:desc>
    </xd:doc>
    <xsl:template match="desc">
        <note>
            <xsl:apply-templates/>
        </note>
    </xsl:template>
    <xd:doc>
        <xd:desc>The name of the collection from which this document was exported. Will be used as
            seriesStmt/title</xd:desc>
    </xd:doc>
    <xsl:template match="colName">
        <title>
            <xsl:apply-templates/>
        </title>
    </xsl:template>
    <xd:doc>
        <xd:desc>Transkribus meta data: external ID</xd:desc>
    </xd:doc>
    <xsl:template match="externalId">
        <idno type="external">
            <xsl:value-of select="."/>
        </idno>
    </xsl:template>
    <!-- Templates for METS -->
    <xd:doc>
        <xd:desc>Create tei:facsimile with @xml:id</xd:desc>
    </xd:doc>
    <xsl:template match="mets:file" mode="facsimile">
        <xsl:variable name="file" select="document(mets:FLocat/@xlink:href, /)"/>
        <xsl:variable name="numCurr" select="@SEQ"/>
        <xsl:apply-templates select="$file//p:Page" mode="facsimile">
            <xsl:with-param name="imageName"
                select="substring-after(concat('/page', mets:FLocat/@xlink:href), '/')"/>
            <xsl:with-param name="numCurr" select="$numCurr" tunnel="true"/>
        </xsl:apply-templates>
    </xsl:template>
    <xd:doc>
        <xd:desc>Apply by-page</xd:desc>
    </xd:doc>
    <xsl:template match="mets:file" mode="text">
        <xsl:variable name="file" select="document(mets:FLocat/@xlink:href, .)"/>
        <xsl:variable name="numCurr" select="@SEQ"/>
        <xsl:apply-templates select="$file//p:Page" mode="text">
            <xsl:with-param name="numCurr" select="$numCurr" tunnel="true"/>
        </xsl:apply-templates>
    </xsl:template>
    <!-- Templates for PAGE, facsimile -->
    <xd:doc>
        <xd:desc>
            <xd:p>Create tei:facsimile/tei:surface</xd:p>
        </xd:desc>
        <xd:param name="imageName">
            <xd:p>the file name of the image</xd:p>
        </xd:param>
        <xd:param name="numCurr">
            <xd:p>Numerus currens of the parent facsimile</xd:p>
        </xd:param>
    </xd:doc>
    <xsl:template match="p:Page" mode="facsimile">
        <xsl:param name="imageName"/>
        <xsl:param name="numCurr" tunnel="true"/>
        <xsl:variable name="coords" select="tokenize(p:PrintSpace/p:Coords/@points, ' ')"/>
        <xsl:variable name="type" select="substring-after(@imageFilename, '.')"/>
        <xsl:text>
      </xsl:text>
        <surface ulx="0" uly="0" lrx="{@imageWidth}" lry="{@imageHeight}" xml:id="facs_{$numCurr}">
            <xsl:text>
         </xsl:text>
            <graphic url="{encode-for-uri(@imageFilename)}" width="{@imageWidth}px"
                height="{@imageHeight}px">
                <!--<xsl:attribute name="xml:id" select="concat('IMAGE.', $numCurr)"></xsl:attribute>-->
            </graphic>
            <!-- include Transkribus image link as second graphic element for later evaluation -->
            <xsl:apply-templates select="preceding-sibling::p:Metadata/*:TranskribusMetadata"/>
            <xsl:apply-templates
                select="p:PrintSpace | p:TextRegion | p:SeparatorRegion | p:GraphicRegion | p:TableRegion | p:MathsRegion"
                mode="facsimile"/>
            <xsl:text>
      </xsl:text>
        </surface>
    </xsl:template>
    <xd:doc>
        <xd:desc>create the zones within facsimile/surface</xd:desc>
        <xd:param name="numCurr">Numerus currens of the current page</xd:param>
    </xd:doc>
    <xsl:template
        match="p:PrintSpace | p:TextRegion | p:SeparatorRegion | p:GraphicRegion | p:TextLine | p:MathsRegion"
        mode="facsimile">
        <xsl:param name="numCurr" tunnel="true"/>
        <xsl:variable name="renditionValue">
            <xsl:choose>
                <xsl:when test="local-name(parent::*) = 'TableCell'">TableCell</xsl:when>
                <xsl:when test="local-name() = 'TextRegion'">TextRegion</xsl:when>
                <xsl:when test="local-name() = 'SeparatorRegion'">Separator</xsl:when>
                <xsl:when test="local-name() = 'GraphicRegion'">Graphic</xsl:when>
                <xsl:when test="local-name() = 'TextLine'">Line</xsl:when>
                <xsl:when test="local-name() = 'MathsRegion'">MathsRegion</xsl:when>
                <xsl:otherwise>printspace</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="custom" as="map(xs:string, xs:string)">
            <xsl:map>
                <xsl:for-each-group select="tokenize(@custom || ' lfd {' || $numCurr, '\} ')"
                    group-by="substring-before(., ' ')">
                    <xsl:map-entry key="substring-before(., ' ')"
                        select="string-join(substring-after(., '{'), '–')"/>
                </xsl:for-each-group>
            </xsl:map>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="self::p:TextLine">
                <xsl:text>
            </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>
         </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <zone points="{p:Coords/@points}" rendition="{$renditionValue}">
            <xsl:if test="$renditionValue != 'printspace'">
                <xsl:attribute name="xml:id">
                    <xsl:value-of select="'facs_' || $numCurr || '_' || @id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@type">
                <xsl:attribute name="subtype">
                    <xsl:value-of select="@type"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="map:contains($custom, 'structure') and not(@type)">
                <xsl:attribute name="subtype"
                    select="substring-after(substring-before(map:get($custom, 'structure'), ';'), ':')"
                />
            </xsl:if>
            <xsl:apply-templates select="p:TextLine" mode="facsimile"/>
            <xsl:if test="$word-coordinates">
                <xsl:apply-templates select="p:Word" mode="facsimile"/>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="self::p:TextLine and p:Word and $word-coordinates">
                    <xsl:text>
            </xsl:text>
                </xsl:when>
                <xsl:when test="self::p:TextRegion">
                    <xsl:text>
         </xsl:text>
                </xsl:when>
            </xsl:choose>
        </zone>
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
    <xd:doc>
        <xd:desc>create a zone for each word within facsimile/surface</xd:desc>
        <xd:param name="numCurr">Numerus currens of the current page</xd:param>
    </xd:doc>
    <xsl:template match="p:Word" mode="facsimile">
        <xsl:param name="numCurr" tunnel="true"/>
        <xsl:text>
               </xsl:text>
        <zone points="{p:Coords/@points}" type="word">
            <xsl:attribute name="xml:id">
                <xsl:value-of select="'facs_' || $numCurr || '_' || @id"/>
            </xsl:attribute>
        </zone>
    </xsl:template>
    <xd:doc>
        <xd:desc>Here we are creating the zones for the Maths within the facsimile/surface</xd:desc>
        <xd:param name="numCurr">Numerus currens of the current page</xd:param>
    </xd:doc>
    <xsl:template match="p:MathsRegion" mode="facsimile">
        <xsl:param name="numCurr" tunnel="true"/>
        <xsl:call-template name="coords"/>
    </xsl:template>
    <xd:doc>
        <xd:desc>Create the zone for a table</xd:desc>
        <xd:param name="numCurr">Numerus currens of the current page</xd:param>
    </xd:doc>
    <xsl:template match="p:TableRegion" mode="facsimile">
        <xsl:param name="numCurr" tunnel="true"/>
        <zone points="{p:Coords/@points}" rendition="Table">
            <xsl:attribute name="xml:id">
                <xsl:value-of select="'facs_' || $numCurr || '_' || @id"/>
            </xsl:attribute>
            <xsl:apply-templates select="p:TableCell//p:TextLine" mode="facsimile"/>
        </zone>
    </xsl:template>
    <xd:doc>
        <xd:desc>create the page content</xd:desc>
        <xd:param name="numCurr">Numerus currens of the current page</xd:param>
    </xd:doc>
    <!-- Templates for PAGE, text -->
    <xsl:template match="p:Page" mode="text">
        <xsl:param name="numCurr" tunnel="true"/>
        <pb facs="#facs_{$numCurr}" n="{$numCurr}" xml:id="img_{format-number($numCurr, '0000')}"/>
        <xsl:apply-templates
            select="p:TextRegion | p:SeparatorRegion | p:GraphicRegion | p:TableRegion | p:MathsRegion"
            mode="text">
            <xsl:with-param name="center" tunnel="true" select="number(@imageWidth) div 2"
                as="xs:double"/>
        </xsl:apply-templates>
    </xsl:template>
    <xd:doc>
        <xd:desc>
            <xd:p>create specific elements based on the @typing of the text region</xd:p>
            <xd:p>PAGE labels for text region see: https://www.primaresearch.org/tools/PAGELibraries
                caption observed header observed footer observed page-number observed drop-capital
                ignored credit ignored floating ignored signature-mark observed catch-word observed
                marginalia observed footnote observed footnote-continued observed endnote ignored
                TOC-entry ignored list-label ignored other observed </xd:p>
        </xd:desc>
        <xd:param name="numCurr"/>
        <xd:param name="center"/>
    </xd:doc>
    <xsl:template match="p:TextRegion" mode="text">
        <xsl:param name="numCurr" tunnel="true"/>
        <xsl:param name="center" tunnel="true" as="xs:double"/>
        <xsl:variable name="custom" as="map(*)">
            <xsl:apply-templates select="@custom"/>
        </xsl:variable>
        <xsl:variable name="regionType" as="xs:string*" select="(@type, $custom?structure?type)"/>
        <xsl:choose>
            <!--         This is ARITHMETIC-specific to set up figures for the icons in the edition -->
            <xsl:when test="not(p:TextLine or $withoutTextline)"> --> <!--            <xsl:variable name="id">
               <xsl:value-of select="concat($ms_id, $numCurr, '_', position())"/>
            </xsl:variable>-->
                <figure facs="#facs_{$numCurr}_{@id}" type="{$regionType}"/>
            </xsl:when>
            <!--         This is general-->
            <xsl:when test="'heading' = $regionType">
                <head facs="#facs_{$numCurr}_{@id}">
                    <xsl:apply-templates select="p:TextLine"/>
                </head>
            </xsl:when>
            <xsl:when test="'caption' = $regionType and not($ab)">
                <figure>
                    <head facs="#facs_{$numCurr}_{@id}">
                        <xsl:apply-templates select="p:TextLine"/>
                    </head>
                </figure>
            </xsl:when>
            <xsl:when test="'header' = $regionType and not($ab)">
                <fw type="header" place="top" facs="#facs_{$numCurr}_{@id}">
                    <xsl:apply-templates select="p:TextLine"/>
                </fw>
            </xsl:when>
            <xsl:when test="'catch-word' = $regionType and not($ab)">
                <fw type="catch" place="bottom" facs="#facs_{$numCurr}_{@id}">
                    <xsl:apply-templates select="p:TextLine"/>
                </fw>
            </xsl:when>
            <xsl:when test="'signature-mark' = $regionType and not($ab)">
                <fw place="bottom" type="sig" facs="#facs_{$numCurr}_{@id}">
                    <xsl:apply-templates select="p:TextLine"/>
                </fw>
            </xsl:when>
            <xsl:when test="'marginalia' = $regionType and not($ab)">
                <xsl:variable name="side">
                    <xsl:choose>
                        <xsl:when test="number(substring-before(p:Coords/@points, ',')) gt $center"
                            >margin-right</xsl:when>
                        <xsl:otherwise>margin-left</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <note place="{$side}" facs="#facs_{$numCurr}_{@id}">
                    <xsl:apply-templates select="p:TextLine"/>
                </note>
            </xsl:when>
            <xsl:when test="'footnote' = $regionType and not($ab)">
                <note place="foot" n="[footnote reference]" facs="#facs_{$numCurr}_{@id}">
                    <xsl:apply-templates select="p:TextLine"/>
                </note>
            </xsl:when>
            <xsl:when test="'footnote-continued' = $regionType and not($ab)">
                <note place="foot" n="[footnote-continued reference]" facs="#facs_{$numCurr}_{@id}">
                    <xsl:apply-templates select="p:TextLine"/>
                </note>
            </xsl:when>
            <xsl:when test="'endnote' = $regionType and not($ab)">
                <note type="endnote" n="[footnote reference]" facs="#facs_{$numCurr}_{@id}">
                    <xsl:apply-templates select="p:TextLine"/>
                </note>
            </xsl:when>
            <xsl:when test="'footer' = $regionType and not($ab)">
                <fw type="footer" place="bottom" facs="#facs_{$numCurr}_{@id}">
                    <xsl:apply-templates select="p:TextLine"/>
                </fw>
            </xsl:when>
            <xsl:when test="'page-number' = $regionType and not($ab)">
                <fw type="page-number" facs="#facs_{$numCurr}_{@id}">
                    <xsl:attribute name="place">
                        <xsl:variable name="verticalPosition"
                            select="p:Coords/@points => substring-before(' ') => substring-after(',') => number()"/>
                        <xsl:choose>
                            <xsl:when
                                test="$verticalPosition div number(parent::p:Page/@imageHeight) lt .33">
                                <xsl:text>top</xsl:text>
                            </xsl:when>
                            <xsl:when
                                test="$verticalPosition div number(parent::p:Page/@imageHeight) lt .66">
                                <xsl:text>centre</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>bottom</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:apply-templates select="p:TextLine"/>
                </fw>
            </xsl:when>
            <xsl:when test="'paragraph' = $regionType">
                <xsl:text>
            </xsl:text>
                <p facs="#facs_{$numCurr}_{@id}">
                    <xsl:apply-templates select="p:TextLine"/>
                </p>
            </xsl:when>
            <!-- the fallback option should be a semantically open element such as <ab> -->
            <xsl:otherwise>
                <xsl:text>
            </xsl:text>
                <ab facs="#facs_{$numCurr}_{@id}"
                    type="{(@type,$custom?structure?type)[normalize-space() != ''][1]}">
                    <xsl:apply-templates select="p:TextLine"/>
                    <xsl:text>
            </xsl:text>
                </ab>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xd:doc>
        <xd:desc>create a figure element for calculations encoded in the MathsRegion</xd:desc>
        <xd:param name="numCurr"/>
    </xd:doc>
    <xsl:template match="p:MathsRegion" mode="text">
        <xsl:param name="numCurr" tunnel="true"/>
        <xsl:variable name="custom" as="map(*)">
            <xsl:apply-templates select="@custom"/>
        </xsl:variable>
        <xsl:variable name="regionType" as="xs:string*" select="(@type, $custom?structure?type)"/>
        <figure facs="#facs_{$numCurr}_{@id}" type="{$regionType}"/>
    </xsl:template>
    <xd:doc>
        <xd:desc>create a table</xd:desc>
        <xd:param name="numCurr"/>
    </xd:doc>
    <xsl:template match="p:TableRegion" mode="text">
        <xsl:param name="numCurr" tunnel="true"/>
        <!--      This adds the structural tags used by ARITHMETIC to the table-->
        <xsl:variable name="custom" as="map(*)">
            <xsl:apply-templates select="@custom"/>
        </xsl:variable>
        <xsl:variable name="regionType" as="xs:string*" select="(@type, $custom?structure?type)"/>
        <xsl:text>
      </xsl:text>
        <table facs="#facs_{$numCurr}_{@id}" type="{$regionType}">
            <xsl:for-each-group select="p:TableCell" group-by="@row">
                <xsl:sort select="@col"/>
                <xsl:text>
        </xsl:text>
                <row n="{@row}">
                    <xsl:apply-templates select="current-group()"/>
                </row>
            </xsl:for-each-group>
        </table>
    </xsl:template>
    <xd:doc>
        <xd:desc>create table cells</xd:desc>
        <xd:param name="numCurr"/>
    </xd:doc>
    <xsl:template match="p:TableCell">
        <xsl:param name="numCurr" tunnel="true"/>
        <xsl:text>
          </xsl:text>
        <cell facs="#facs_{$numCurr}_{@id}" n="{@col}">
            <xsl:apply-templates select="@rowSpan | @colSpan"/>
            <xsl:attribute name="rend">
                <xsl:value-of select="number((xs:boolean(@leftBorderVisible), false())[1])"/>
                <xsl:value-of select="number((xs:boolean(@topBorderVisible), false())[1])"/>
                <xsl:value-of select="number((xs:boolean(@rightBorderVisible), false())[1])"/>
                <xsl:value-of select="number((xs:boolean(@bottomBorderVisible), false())[1])"/>
            </xsl:attribute>
            <xsl:apply-templates select="p:TextLine"/>
        </cell>
    </xsl:template>
    <xd:doc>
        <xd:desc>rowspan -> rows</xd:desc>
    </xd:doc>
    <xsl:template match="@rowSpan">
        <xsl:choose>
            <xsl:when test=". &gt; 1">
                <xsl:attribute name="rows" select="."/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xd:doc>
        <xd:desc>colspan -> cols</xd:desc>
    </xd:doc>
    <xsl:template match="@colSpan">
        <xsl:choose>
            <xsl:when test=". &gt; 1">
                <xsl:attribute name="cols" select="."/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xd:doc>
        <xd:desc>Converts one line of PAGE to one line of TEI</xd:desc>
        <xd:param name="numCurr">Numerus currens, to be tunneled through from the page
            level</xd:param>
    </xd:doc>
    <xsl:template match="p:TextLine">
        <xsl:param name="numCurr" tunnel="true"/>
        <xsl:if test="p:Baseline or $withoutBaseline">
            <xsl:variable name="text" select="p:TextEquiv/p:Unicode"/>
            <!--<xsl:variable name="custom" as="map(*)">
            <xsl:apply-templates select="@custom"/>
         </xsl:variable>
         <xsl:variable name="lineType" as="xs:string*" select="(@type, $custom?structure?type)"/>-->
            <xsl:variable name="custom" as="text()*">
                <xsl:for-each select="tokenize(@custom, '\}')">
                    <xsl:variable name="content"
                        select="substring-after(., '{') => normalize-space()"/>
                    <xsl:variable name="name"
                        select="substring-before(., ' {') => normalize-space()"/>
                    <!--<xsl:variable name="lineType" select="substring-before(substring-after(., 'type:'),';')"/>-->
                    <xsl:choose>
                        <xsl:when test="$content = '' or $name = ('readingOrder', 'structure')"/>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="starts" as="map(*)">
                <xsl:map>
                    <xsl:if test="count($custom) &gt; 0">
                        <xsl:for-each-group select="$custom"
                            group-by="substring-before(substring-after(., 'offset:'), ';')">
                            <xsl:map-entry key="xs:int(current-grouping-key())"
                                select="current-group()"/>
                        </xsl:for-each-group>
                    </xsl:if>
                </xsl:map>
            </xsl:variable>
            <xsl:variable name="ends" as="map(*)">
                <xsl:map>
                    <xsl:if test="count($custom) &gt; 0">
                        <xsl:for-each-group select="$custom" group-by="
                        xs:int(substring-before(substring-after(., 'offset:'), ';'))
                        + xs:int(substring-before(substring-after(., 'length:'), ';'))">
                            <xsl:map-entry key="current-grouping-key()" select="current-group()"/>
                        </xsl:for-each-group>
                    </xsl:if>
                </xsl:map>
            </xsl:variable>
            <xsl:variable name="prepped">
                <xsl:for-each select="0 to string-length($text)">
                    <xsl:if test=". &gt; 0">
                        <xsl:value-of select="substring($text, ., 1)"/>
                    </xsl:if>
                    <xsl:for-each select="map:get($starts, .)">
                        <!--<xsl:sort select="substring-before(substring-after(.,'offset:'), ';')" order="ascending"/>-->
                        <!-- end of current tag -->
                        <xsl:sort select="
                        xs:int(substring-before(substring-after(., 'offset:'), ';'))
                        + xs:int(substring-before(substring-after(., 'length:'), ';'))"
                            order="descending"/>
                        <xsl:sort select="substring(., 1, 3)" order="ascending"/>
                        <xsl:element name="local:m">
                            <xsl:attribute name="type"
                                select="normalize-space(substring-before(., ' '))"/>
                            <xsl:attribute name="o" select="substring-after(., 'offset:')"/>
                            <xsl:attribute name="pos">s</xsl:attribute>
                        </xsl:element>
                    </xsl:for-each>
                    <xsl:for-each select="map:get($ends, .)">
                        <xsl:sort select="substring-before(substring-after(., 'offset:'), ';')"
                            order="descending"/>
                        <xsl:sort select="substring(., 1, 3)" order="descending"/>
                        <xsl:element name="local:m">
                            <xsl:attribute name="type"
                                select="normalize-space(substring-before(., ' '))"/>
                            <xsl:attribute name="o" select="substring-after(., 'offset:')"/>
                            <xsl:attribute name="pos">e</xsl:attribute>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="prepared">
                <xsl:for-each select="$prepped/node()">
                    <xsl:choose>
                        <xsl:when test="@pos = 'e'">
                            <xsl:variable name="position" select="count(preceding-sibling::node())"/>
                            <xsl:variable name="o" select="@o"/>
                            <xsl:variable name="id" select="@type"/>
                            <xsl:variable name="precs"
                                select="preceding-sibling::local:m[@pos = 's' and preceding-sibling::local:m[@o = $o]]"/>
                            <xsl:for-each select="$precs">
                                <xsl:variable name="so" select="@o"/>
                                <xsl:variable name="myP"
                                    select="count(following-sibling::local:m[@pos = 'e' and @o = $so]/preceding-sibling::node())"/>
                                <xsl:if test="
                              following-sibling::local:m[@pos = 'e' and @o = $so
                              and $myP &gt; $position] and not(@type = $id)">
                                    <local:m type="{@type}" pos="e" o="{@o}"
                                        prev="{$myP||'.'||$position||($myP > $position)}"/>
                                </xsl:if>
                            </xsl:for-each>
                            <xsl:sequence select="."/>
                            <xsl:for-each select="$precs">
                                <xsl:variable name="so" select="@o"/>
                                <xsl:variable name="myP"
                                    select="count(following-sibling::local:m[@pos = 'e' and @o = $so]/preceding-sibling::node())"/>
                                <xsl:if test="
                              following-sibling::local:m[@pos = 'e' and @o = $so
                              and $myP &gt; $position] and not(@type = $id)">
                                    <local:m type="{@type}" pos="s" o="{@o}"
                                        prev="{$myP||'.'||$position||($myP > $position)}"/>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:sequence select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:variable>
            <!-- TODO parameter to create <l>...</l> - #1 -->
            <xsl:text>
               </xsl:text>
            <lb facs="#facs_{$numCurr}_{@id}">
                <xsl:if test="@custom">
                    <xsl:variable name="pos"
                        select="xs:integer(substring-before(substring-after(@custom, 'index:'), ';')) + 1"/>
                    <xsl:attribute name="n">
                        <xsl:text>N</xsl:text>
                        <xsl:value-of select="format-number($pos, '000')"/>
                    </xsl:attribute>
                </xsl:if>
            </lb>
            <xsl:choose>
                <!--               ARITHMETIC STRUCTURAL TYPES FOR LINES -->
                <xsl:when test="contains(@custom, 'structure')">
                    <span>
                        <xsl:attribute name="style">
                            <xsl:value-of
                                select="substring-before(substring-after(@custom, 'structure {type:'), ';')"
                            />
                        </xsl:attribute>
                        <xsl:apply-templates
                            select="$prepared/text()[not(preceding-sibling::local:m)]"/>
                        <xsl:apply-templates select="
                        $prepared/local:m[@pos = 's']
                        [count(preceding-sibling::local:m[@pos = 's']) = count(preceding-sibling::local:m[@pos = 'e'])]"
                        />
                    </span>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="$prepared/text()[not(preceding-sibling::local:m)]"/>
                    <xsl:apply-templates select="
                     $prepared/local:m[@pos = 's']
                     [count(preceding-sibling::local:m[@pos = 's']) = count(preceding-sibling::local:m[@pos = 'e'])]"
                    />
                </xsl:otherwise>
            </xsl:choose>
            <!--[not(preceding-sibling::local:m[1][@pos='s'])]" />-->
        </xsl:if>
    </xsl:template>
    <xd:doc>
        <xd:desc>Starting milestones for (possibly nested) elements</xd:desc>
    </xd:doc>
    <xsl:template match="local:m[@pos = 's']">
        <xsl:variable name="o" select="@o"/>
        <!--    ORIGINAL = Funktioniert nicht mehr :( -->
        <xsl:variable name="custom" as="map(*)">
            <xsl:map>
                <xsl:variable name="t" select="tokenize(@o, ';')"/>
                <xsl:if test="count($t) &gt; 1">
                    <xsl:for-each select="$t[. != '']">
                        <xsl:map-entry key="normalize-space(substring-before(., ':'))"
                            select="normalize-space(substring-after(., ':'))"/>
                    </xsl:for-each>
                </xsl:if>
            </xsl:map>
        </xsl:variable>
        <xsl:variable name="custom" as="map(*)">
            <xsl:map>
                <xsl:for-each-group select="tokenize($o, ';')[. != '']"
                    group-by="normalize-space(substring-before(., ':'))">
                    <xsl:map-entry key="current-grouping-key()"
                        select="normalize-space(substring-after(current-group()[1], ':'))"/>
                </xsl:for-each-group>
            </xsl:map>
        </xsl:variable>
        <xsl:variable name="elem">
            <local:t>
                <xsl:sequence select="
                  following-sibling::node()
                  intersect following-sibling::local:m[@o = $o]/preceding-sibling::node()"
                />
            </local:t>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="@type = 'textStyle'">
                <xsl:variable name="rend" as="xs:string*">
                    <xsl:if test="$custom?italic">
                        <xsl:text>italic</xsl:text>
                    </xsl:if>
                    <xsl:if test="$custom?underlined">
                        <xsl:text>underline</xsl:text>
                    </xsl:if>
                    <xsl:if test="$custom?strikethrough">
                        <xsl:text>line-through</xsl:text>
                    </xsl:if>
                    <xsl:if test="number($custom?fontSize) gt 0">
                        <xsl:value-of select="'font-size: ' || $custom?fontSize || 'px;'"/>
                    </xsl:if>
                    <xsl:if test="number($custom?kerning) gt 0">
                        <xsl:value-of select="'letter-spacing: ' || $custom?fontSize || 'px;'"/>
                    </xsl:if>
                    <xsl:if test="$custom?fontFamily != ''">
                        <xsl:value-of select="'font-family: ' || $custom?fontFamily || ';'"/>
                    </xsl:if>
                    <xsl:if test="$custom?superscript = 'true'">
                        <xsl:text>superscript</xsl:text>
                    </xsl:if>
                </xsl:variable>
                <hi>
                    <xsl:if test="count($rend) gt 0">
                        <xsl:attribute name="rend" select="string-join($rend, ' ')"/>
                    </xsl:if>
                    <xsl:call-template name="elem">
                        <xsl:with-param name="elem" select="$elem"/>
                    </xsl:call-template>
                </hi>
            </xsl:when>
            <xsl:when test="@type = 'supplied'">
                <supplied reason="">
                    <xsl:call-template name="elem">
                        <xsl:with-param name="elem" select="$elem"/>
                    </xsl:call-template>
                </supplied>
            </xsl:when>
            <xsl:when test="@type = 'abbrev'">
                <choice>
                    <expan>
                        <xsl:value-of
                            select="replace(map:get($custom, 'expansion'), '\\u0020', ' ')"/>
                    </expan>
                    <abbr>
                        <xsl:call-template name="elem">
                            <xsl:with-param name="elem" select="$elem"/>
                        </xsl:call-template>
                    </abbr>
                </choice>
            </xsl:when>
            <xsl:when test="@type = 'red'">
                <hi rend="red">
                    <xsl:call-template name="elem">
                        <xsl:with-param name="elem" select="$elem"/>
                    </xsl:call-template>
                </hi>
            </xsl:when>
            <xsl:when test="@type = 'sic'">
                <choice>
                    <corr>
                        <xsl:value-of
                            select="replace(map:get($custom, 'correction'), '\\u0020', ' ')"/>
                    </corr>
                    <sic>
                        <xsl:call-template name="elem">
                            <xsl:with-param name="elem" select="$elem"/>
                        </xsl:call-template>
                    </sic>
                </choice>
            </xsl:when>
            <xsl:when test="@type = 'title'">
                <title>
                    <xsl:call-template name="elem">
                        <xsl:with-param name="elem" select="$elem"/>
                    </xsl:call-template>
                </title>
            </xsl:when>
            <xsl:when test="@type = 'date'">
                <date>
                    <!--<xsl:variable name="year" select="if(map:keys($custom) = 'year') then format-number(xs:integer(map:get($custom, 'year')), '0000') else '00'"/>
          <xsl:variable name="month" select=" if(map:keys($custom) = 'month') then format-number(xs:integer(map:get($custom, 'month')), '00') else '00'"/>
          <xsl:variable name="day" select=" if(map:keys($custom) = 'day') then format-number(xs:integer(map:get($custom, 'day')), '00') else '00'"/>
          <xsl:variable name="when" select="$year||'-'||$month||'-'||$day" />
          <xsl:if test="$when != '0000-00-00'">
            <xsl:attribute name="when" select="$when" />
          </xsl:if>-->
                    <xsl:for-each select="map:keys($custom)">
                        <xsl:if test=". != 'length' and . != ''">
                            <xsl:attribute name="{.}" select="map:get($custom, .)"/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:call-template name="elem">
                        <xsl:with-param name="elem" select="$elem"/>
                    </xsl:call-template>
                </date>
            </xsl:when>
            <xsl:when test="@type = 'person'">
                <xsl:variable name="elName" select="
                  if ($rs) then
                     'rs'
                  else
                     'persName'"/>
                <xsl:element name="{$elName}">
                    <xsl:if test="$rs">
                        <xsl:attribute name="type">person</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$custom('lastname') != '' or $custom('firstname') != ''">
                        <xsl:attribute name="key"
                            select="replace($custom('lastname'), '\\u0020', ' ') || ', ' || replace($custom('firstname'), '\\u0020', ' ')"
                        />
                    </xsl:if>
                    <xsl:if test="$custom('continued')">
                        <xsl:attribute name="continued" select="true()"/>
                    </xsl:if>
                    <xsl:call-template name="elem">
                        <xsl:with-param name="elem" select="$elem"/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@type = 'place'">
                <xsl:variable name="elName" select="
                  if ($rs) then
                     'rs'
                  else
                     'placeName'"/>
                <xsl:element name="{$elName}">
                    <xsl:if test="$rs">
                        <xsl:attribute name="type">place</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$custom('placeName') != ''">
                        <xsl:attribute name="key"
                            select="replace($custom('placeName'), '\\u0020', ' ')"/>
                    </xsl:if>
                    <xsl:if test="$custom?continued">
                        <xsl:attribute name="continued" select="true()"/>
                    </xsl:if>
                    <xsl:call-template name="elem">
                        <xsl:with-param name="elem" select="$elem"/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@type = 'organization'">
                <xsl:variable name="elName" select="
                  if ($rs) then
                     'rs'
                  else
                     'orgName'"/>
                <xsl:element name="{$elName}">
                    <xsl:if test="$rs">
                        <xsl:attribute name="type">org</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$custom?continued">
                        <xsl:attribute name="continued" select="true()"/>
                    </xsl:if>
                    <xsl:call-template name="elem">
                        <xsl:with-param name="elem" select="$elem"/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="{@type}">
                    <xsl:for-each select="map:keys($custom)">
                        <xsl:if test="not(. = ('', 'length'))">
                            <xsl:attribute name="{.}" select="$custom(.)"/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:call-template name="elem">
                        <xsl:with-param name="elem" select="$elem"/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates
            select="following-sibling::local:m[@pos = 'e' and @o = $o]/following-sibling::node()[1][self::text()]"
        />
    </xsl:template>
    <xd:doc>
        <xd:desc>Process what's between a pair of local:m</xd:desc>
        <xd:param name="elem"/>
    </xd:doc>
    <xsl:template name="elem">
        <xsl:param name="elem"/>
        <xsl:choose>
            <xsl:when test="$elem//local:m">
                <xsl:apply-templates select="$elem/local:t/text()[not(preceding-sibling::local:m)]"/>
                <xsl:apply-templates select="
                  $elem/local:t/local:m[@pos = 's']
                  [not(preceding-sibling::local:m[1][@pos = 's'])]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$elem/local:t/node()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xd:doc>
        <xd:desc>Leave out possibly unwanted parts</xd:desc>
    </xd:doc>
    <xsl:template match="p:Metadata" mode="text"/>
    <xd:doc>
        <xd:desc>TranskribusMetadata contains the link to the image on Transkribus’ servers; return
            a tei:graphic element with this URL so it can be evaluated during
            postprocessing</xd:desc>
    </xd:doc>
    <xsl:template match="*:TranskribusMetadata">
        <xsl:text>
         </xsl:text>
        <graphic url="{@imgUrl}" width="{following::p:Page/@imageWidth}px"
            height="{following::p:Page/@imageHeight}px"/>
    </xsl:template>
    <xd:doc>
        <xd:desc>Parse the content of an attribute such as @custom into a map.</xd:desc>
    </xd:doc>
    <xsl:template match="@custom" as="map(*)">
        <xsl:map>
            <xsl:for-each select="tokenize(., '\}')[normalize-space() != '']">
                <xsl:map-entry key="substring-before(normalize-space(), ' ')">
                    <xsl:map>
                        <xsl:for-each
                            select="tokenize(substring-after(., '{'), ';')[normalize-space() != '']">
                            <xsl:map-entry key="substring-before(., ':')"
                                select="substring-after(., ':')"/>
                        </xsl:for-each>
                    </xsl:map>
                </xsl:map-entry>
            </xsl:for-each>
        </xsl:map>
    </xsl:template>
    <xd:doc>
        <xd:desc>Text nodes to be copied</xd:desc>
    </xd:doc>
    <xsl:template match="text()">
        <xsl:value-of select="."/>
    </xsl:template>
    <!--    START OF THE COORDINATE TEMPLATES-->
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
