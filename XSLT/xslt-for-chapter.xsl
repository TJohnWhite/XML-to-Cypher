<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c/ns/1.0"
  xmlns:fa="http://www.w3.org/2005/xpath-functions" exclude-result-prefixes="xs" version="2.0"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0">
  <xsl:import href="generic-cypher.xsl"/>

  <!-- apply templates to our types individually -->
  <!-- I write from the bottom up, so first step is head to the text/body/div[@type='novel'] template at the bottom of this stylesheet. -->
  <xsl:template match="TEI">
    <xsl:apply-templates select="text/body/div[@type='novel']"/>
  </xsl:template>





  <!-- these first few templates are all basically the same, go to the bottom of the page if you
  want to know how we got here.-->

  <xsl:template match="geogName">
    <xsl:param name="paragraph-node"/>

    <!-- make var for the geog -->
    <xsl:variable name="geog-node">
      <xsl:call-template name="callSimpleNode">
        <xsl:with-param name="nodeKind" select="'geog'"/>
        <xsl:with-param name="property-value" select="./@corresp"/>
      </xsl:call-template>
    </xsl:variable>
    
    <!-- merge it -->
    <xsl:call-template name="elements-to-paragraphs">
      <xsl:with-param name="element-node" select="$geog-node"/>
      <xsl:with-param name="paragraph-node" select="$paragraph-node"/>
    </xsl:call-template>

  </xsl:template>

  <xsl:template match="placeName">
    <xsl:param name="paragraph-node"/>

    <!-- make var for the place -->
    <xsl:variable name="place-node">
      <xsl:call-template name="callSimpleNode">
        <xsl:with-param name="nodeKind" select="'place'"/>
        <xsl:with-param name="property-value" select="./@corresp"/>
      </xsl:call-template>
    </xsl:variable>

    <!-- merge it -->
    <xsl:call-template name="elements-to-paragraphs">
      <xsl:with-param name="element-node" select="$place-node"/>
      <xsl:with-param name="paragraph-node" select="$paragraph-node"/>
    </xsl:call-template>

  </xsl:template>



  <xsl:template match="time">
    <xsl:param name="paragraph-node"/>

    <!-- make var for the place -->
    <xsl:variable name="time-node">
      <xsl:call-template name="callSimpleNode">
        <xsl:with-param name="nodeKind" select="'time'"/>
        <xsl:with-param name="property-value" select="./@when"/>
      </xsl:call-template>
    </xsl:variable>

    <!-- merge it -->
    <xsl:call-template name="elements-to-paragraphs">
      <xsl:with-param name="element-node" select="$time-node"/>
      <xsl:with-param name="paragraph-node" select="$paragraph-node"/>
    </xsl:call-template>

  </xsl:template>


  <xsl:template match="date">
    <xsl:param name="paragraph-node"/>

    <!-- make var for the date -->
    <xsl:variable name="date-node">
      <xsl:call-template name="callSimpleNode">
        <xsl:with-param name="nodeKind" select="'date'"/>
        <xsl:with-param name="property-value" select="./@when"/>
      </xsl:call-template>
    </xsl:variable>

    <!-- merge it -->
    <xsl:call-template name="elements-to-paragraphs">
      <xsl:with-param name="element-node" select="$date-node"/>
      <xsl:with-param name="paragraph-node" select="$paragraph-node"/>
    </xsl:call-template>

  </xsl:template>




  <xsl:template match="p">
    <xsl:param name="chapter-node"/>

    <!-- this makes a paragraph ID by stepping out the xpath one step and getting the @n from the containing chapter -->
    <xsl:variable name="paragraph-identifier">
      <xsl:value-of select="../@n"/>
      <xsl:text>-</xsl:text>
      <xsl:value-of select="@n"/>
    </xsl:variable>


    <!-- make var for the paragraph -->
    <xsl:variable name="paragraph-node">
      <xsl:call-template name="simpleNode">
        <xsl:with-param name="identifier" select="'paragraph'"/>
        <xsl:with-param name="labels" select="':Paragraph'"/>
        <xsl:with-param name="property-name" select="'paragraph_id'"/>
        <xsl:with-param name="property-value" select="$paragraph-identifier"/>
      </xsl:call-template>
    </xsl:variable>

    <!-- merge it -->
    <xsl:call-template name="mergeNode">
      <xsl:with-param name="node" select="$paragraph-node"/>
    </xsl:call-template>

    <!-- make the relationship from the paragraph to the chapter -->
    <xsl:call-template name="simpleRelationship">
      <xsl:with-param name="fromNode" select="$paragraph-node"/>
      <xsl:with-param name="toNode" select="$chapter-node"/>
      <xsl:with-param name="relationshipType" select="'IN'"/>
    </xsl:call-template>

    <!-- here we apply the rest of the templates. Ordinarily, I'd like to put date and times as 
    a property of a relationship, but I think they're fine here as nodes themselves because this 
    is just an example-->
    <xsl:apply-templates select="date | time | placeName | geogName">
      <xsl:with-param name="paragraph-node" select="$paragraph-node"/>
    </xsl:apply-templates>



  </xsl:template>




  <xsl:template match="div[@type='chapter']">
    <xsl:param name="novel-node"/>


    <!-- makes a var for the chapter -->
    <xsl:variable name="chapter-node">

      <xsl:call-template name="simpleNode">
        <xsl:with-param name="identifier" select="'chapter'"/>
        <xsl:with-param name="labels" select="':Chapter'"/>
        <xsl:with-param name="property-name" select="'title'"/>

        <!-- The <head> for the chapter in Dracula_ex.xml is in all caps. This next param calls
        a template that can separate the input on a character and send it to the capitalizer template.
        It's set to tokenize on spaces and then add the spaces back in.
        -->
        <xsl:with-param name="property-value">
          <xsl:call-template name="capitalizer-tokenize">
            <xsl:with-param name="input" select="./head"/>
            <xsl:with-param name="tokenize-on" select="' '"/>
            <xsl:with-param name="space-with" select="' '"/>
          </xsl:call-template>
        </xsl:with-param>

      </xsl:call-template>
    </xsl:variable>

    <!-- merge chapter into the database -->
    <xsl:call-template name="mergeNode">
      <xsl:with-param name="node" select="$chapter-node"/>
    </xsl:call-template>

    <!-- giving it properties -->
    <xsl:call-template name="addProperties">
      <xsl:with-param name="node" select="$chapter-node"/>
      <xsl:with-param name="property-name" select="'chapter_number'"/>
      <xsl:with-param name="property-value" select="@n"/>
    </xsl:call-template>

    <!-- making the relationship between the chapter and novel -->
    <xsl:call-template name="simpleRelationship">
      <xsl:with-param name="fromNode" select="$chapter-node"/>
      <xsl:with-param name="toNode" select="$novel-node"/>
      <xsl:with-param name="relationshipType" select="'FROM'"/>
    </xsl:call-template>

    <!-- we need to treat the central place differently. -->
    <xsl:variable name="central-place">
      <xsl:call-template name="callSimpleNode">
        <xsl:with-param name="property-value"
          select="descendant::placeName[@type='central']/@corresp"/>
        <xsl:with-param name="nodeKind" select="'place'"/>
      </xsl:call-template>
    </xsl:variable>


    <!-- another variable for the central date. -->
    <!-- with neo4j, we like to put unique information as properties of a node, and potentially
      replicatable information as relationships. In this case, the central date is going to end up
      as a property of the relationship.-->
    <xsl:variable name="central-date-as-property">
      <xsl:call-template name="dateFormatter">
        <xsl:with-param name="dateElement" select="descendant::date[@type='central']"/>
      </xsl:call-template>
    </xsl:variable>


    <xsl:call-template name="simpleRelationship-withProperties">
      <xsl:with-param name="fromNode" select="$chapter-node"/>
      <xsl:with-param name="toNode" select="$central-place"/>
      <xsl:with-param name="relationshipType" select="'IN'"/>
      <xsl:with-param name="propertyList" select="$central-date-as-property"/>
    </xsl:call-template>



    <!-- sends the chapter node to the p template -->
    <xsl:apply-templates select="p">
      <xsl:with-param name="chapter-node" select="$chapter-node"/>
    </xsl:apply-templates>


  </xsl:template>

  <xsl:template match="div[@type='novel']">
    <!-- after the root template, this is the first template that will fire. -->


    <!-- make a var for the whole novel, this is also an example of the simple node template.
    If novel sized nodes came up enough to be worth it, you could put a new statement into
    callSimpleNode
    -->
    <xsl:variable name="novel-node">
      <xsl:call-template name="simpleNode">
        <xsl:with-param name="identifier" select="'novel'"/>
        <xsl:with-param name="labels" select="':Novel'"/>
        <xsl:with-param name="property-name" select="'title'"/>


        <!-- we use the capitalizer here because the title appears in all caps -->
        <xsl:with-param name="property-value">
          <xsl:call-template name="capitalizer">
            <xsl:with-param name="input" select="./head"/>
          </xsl:call-template>
        </xsl:with-param>

      </xsl:call-template>
    </xsl:variable>


    <!-- merge the novel node into the database. We will preserve the novel node through the next step -->
    <xsl:call-template name="mergeNode">
      <xsl:with-param name="node" select="$novel-node"/>
    </xsl:call-template>


    <!-- we call the chapter template here so we can pass it the novel node. -->
    <xsl:apply-templates select="./div[@type='chapter']">
      <xsl:with-param name="novel-node" select="$novel-node"/>
    </xsl:apply-templates>

  </xsl:template>


  <!-- this is a super simple bespoke template for relating elements to the paragraphs they're found in -->
  <xsl:template name="elements-to-paragraphs">
    <xsl:param name="element-node"/>
    <xsl:param name="paragraph-node"/>

    <xsl:call-template name="mergeNode">
      <xsl:with-param name="node" select="$element-node"/>
    </xsl:call-template>

    <xsl:call-template name="simpleRelationship">
      <xsl:with-param name="fromNode" select="$element-node"/>
      <xsl:with-param name="toNode" select="$paragraph-node"/>
      <xsl:with-param name="relationshipType" select="'MENTIONED_IN'"/>
    </xsl:call-template>

  </xsl:template>



</xsl:stylesheet>
