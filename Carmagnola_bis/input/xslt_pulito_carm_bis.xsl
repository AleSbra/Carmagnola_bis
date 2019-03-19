<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0">
    <xsl:param name="ma-cc">cc</xsl:param>
    <!-- tempalte per l'applicazione di name="contenuto" al variare del parametro -->
    <xsl:template match="//tei:sourceDoc/tei:surfaceGrp/tei:surface[@n]">
        <xsl:choose>
            <xsl:when test="$ma-cc = 'cc'">
                <xsl:call-template name="contenuto">
                    <xsl:with-param name="ma-cc">
                        <xsl:value-of select="$ma-cc"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="contenuto">
                    <xsl:with-param name="ma-cc">
                        <xsl:value-of select="$ma-cc"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:del">
        <!-- <sup><xsl:number count="tei:del" from="tei:surface" level="any"></xsl:number></sup>-->
    </xsl:template>
    <!-- definizione del template principale -->
    <xsl:template name="contenuto">
        <xsl:param name="ma-cc"/>
        <xsl:result-document href="../testi/{$ma-cc}/{@n}.html">
            <html>
                <head>
                    <title>
                        <xsl:value-of select="$ma-cc"/>
                    </title>
                    <style>
                        
                        h1{
                        font-family: "Lucida Grande", "Lucida Sans Unicode", "Lucida Sans", "DejaVu Sans", Verdana, "sans-serif";
                        text-align: center;
                        text-align: center;
                        font-weight: bolder;
                        font-size: 13px;
                        }
                        h2{
                        font-family: "Lucida Grande", "Lucida Sans Unicode", "Lucida Sans", "DejaVu Sans", Verdana, "sans-serif";
                        text-align: center;
                        font-size: 12px;
                        }
                        l{
                        font-family: "Lucida Grande", "Lucida Sans Unicode", "Lucida Sans", "DejaVu Sans", Verdana, "sans-serif";
                        font-size: 11x;
                        text-align: justify;
                        }
                        .block{
                        font-family: "Lucida Grande", "Lucida Sans Unicode", "Lucida Sans", "DejaVu Sans", Verdana, "sans-serif";
                        font-size: 11px;
                        text-align: justify;
                        display: block;
                        }
                        .inline{
                        font-family: "Lucida Grande", "Lucida Sans Unicode", "Lucida Sans", "DejaVu Sans", Verdana, "sans-serif";
                        font-size: 11px;
                        text-align: justify;
                        }
                        .box{
                        text-decoration: none;
                        width: 300px;
                        height: 500px;
                        position: absolute;
                        text-align: center;
                        align-content: center;
                        align-items: center;
                        margin-top: 2.5%;
                        }
                        .note{margin-top:30px;
                        font-size:8px;
                        font-family: "Lucida Grande", "Lucida Sans Unicode", "Lucida Sans", "DejaVu Sans", Verdana, "sans-serif";}
                    </style>
                </head>
                <body>
                    
                    <div class="box">
                        
                        <xsl:for-each
                            select=".//tei:zone[contains(@change, concat('#r', $ma-cc)) or @type = 'patch']">
                            <xsl:sort select="substring-after(@change, concat('#r', $ma-cc))"/>
                            <!-- <xsl:sort select="if (//tei:zone,@type = 'patch') then (//tei:zone[@xml:id = .[substring-after(@corresp, '#')]]/@change,
                                    concat('#r', $ma-cc))  else substring-after(@change, concat('#r', $ma-cc))"/>-->
                            
                            <xsl:choose>
                                <xsl:when test="@type = 'patch'">
                                    <xsl:variable name="patch-id"
                                        select="@xml:id"/>
                                    
                                    <xsl:for-each select="//tei:zone[@xml:id = $patch-id]">
                                        <l id="{$patch-id}">
                                            <xsl:apply-templates select="tei:line"/>
                                        </l>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:when test="tei:line[@type = 'title']">
                                    <h1>
                                        <xsl:apply-templates/>
                                    </h1>
                                </xsl:when>
                                <xsl:when test="tei:line[@type = 'subtitle']">
                                    <h2>
                                        <xsl:apply-templates/>
                                    </h2>
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    <xsl:for-each select="tei:line">
                                      <l><xsl:apply-templates/></l>
                                    </xsl:for-each>
                                </xsl:otherwise>
                            </xsl:choose>
                            
                        </xsl:for-each>
                        
                        
                        <!--  <div class="note">
                        <hr/>
                        <h5>Apparato</h5>
                        <xsl:for-each
                            select=".//tei:zone [contains(@change, concat('#c', $fl-sp))]/tei:line">
                            <xsl:choose>
                                <xsl:when test="tei:del">
                                    <div class="app"> 
                                        <sup><xsl:number count="tei:del" from="tei:surface" level="any"></xsl:number></sup>
                                        <xsl:apply-templates select="tei:del/text()"/></div>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>
                    </div>-->
                        <xsl:text disable-output-escaping="yes">&lt;/p></xsl:text>
                    </div>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    <!-- template per l'impaginazione in paragrafi -->
    <xsl:template match="tei:milestone">
        <xsl:choose>
            <xsl:when test="@unit='seg'">
                <a href="testo_apparato/puliti/{$ma-cc}/{@n}.html" target="_blank">[<xsl:value-of select="@n"/>] </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="cur-mile" select="@xml:id"/>
                
                <xsl:if test="not(ancestor::tei:zone/tei:line[1]/node()[1][@xml:id = $cur-mile])">
                    <xsl:text disable-output-escaping="yes">&lt;/p></xsl:text>
                </xsl:if>
                <xsl:text disable-output-escaping="yes">&lt;p></xsl:text> 
                [<xsl:value-of select="substring-after(@xml:id, concat('p', $ma-cc, '0'))"/>] 
                
                
            </xsl:otherwise>
        </xsl:choose>
        
        
    </xsl:template>
    <!-- esclusione delle informazioni del teiHeader -->
    <xsl:template match="tei:teiHeader"/>
</xsl:stylesheet>