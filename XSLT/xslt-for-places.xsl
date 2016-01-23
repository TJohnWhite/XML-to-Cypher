<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c/ns/1.0"
  xmlns:fa="http://www.w3.org/2005/xpath-functions" exclude-result-prefixes="xs" version="2.0"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0">
  <xsl:import href="generic-cypher.xsl"/>

  <!-- apply templates to our types individually -->
  <!-- I write from the bottom up, so first step is head to the @type='continent' template at the bottom of this stylesheet. -->
  
  
  <!-- this template runs first and will ignore the header -->
  <xsl:template match="TEI">
    <xsl:apply-templates select="text/body"/>
  </xsl:template>
  
  
  <!-- this template will process the listPlaces that are a child of listPlace-->
  <xsl:template match="body/listPlace">
    <xsl:apply-templates select="listPlace[@type='continent']/place"/>
    <xsl:apply-templates select="listPlace[@type='country']/place"/>
    <xsl:apply-templates select="listPlace[@type='past-region']/place"/>
    <xsl:apply-templates select="listPlace[@type='city']/place"/>
    <xsl:apply-templates select="listPlace[@type='sub-city']/place | listPlace[@type='geo-feature']/place"/>
  </xsl:template>




  <xsl:template match="listPlace[@type='sub-city']/place | listPlace[@type='geo-feature']/place">

    <!-- make a little var for labels, we will use the @type, but we need to capitalize it first -->
    <xsl:variable name="labels">
      <xsl:if test="../@type = 'geo-feature'">
        <xsl:text>:Geographic_Feature:</xsl:text>
      </xsl:if>
      <xsl:if test="../@type = 'sub-city'">
         <xsl:text>:Place:</xsl:text>
      </xsl:if>
     
     <!-- this call-template will tokenize on a hyphen, capitalize, and then space with an underscore -->
      <xsl:call-template name="capitalizer-tokenize">
        <xsl:with-param name="input" select="@type"/>
        <xsl:with-param name="tokenize-on" select="'-'"/>
        <xsl:with-param name="space-with" select="'_'"/>
      </xsl:call-template>
    </xsl:variable>

    <!-- make var for our node -->
    <xsl:variable name="sub-geo-node">
      <xsl:call-template name="simpleNode">
        <xsl:with-param name="identifier" select="'currentSubGeo'"/>
        <xsl:with-param name="labels" select="$labels"/>
        <xsl:with-param name="property-name" select="'uri'"/>
        <xsl:with-param name="property-value">
          <xsl:text>http://www.example.com/geo.xml#</xsl:text>
          <xsl:value-of select="@xml:id"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <!-- Merge it -->
    <xsl:call-template name="mergeNode">
      <xsl:with-param name="node" select="$sub-geo-node"/>
    </xsl:call-template>

    <!-- add name -->
    <xsl:call-template name="name-property">
      <xsl:with-param name="node" select="$sub-geo-node"/>
    </xsl:call-template>

    <!-- var for country-->
    <xsl:variable name="containing-country">
      <xsl:call-template name="containing-place"/>
    </xsl:variable>

    <xsl:call-template name="simpleRelationship">
      <xsl:with-param name="fromNode" select="$sub-geo-node"/>
      <xsl:with-param name="toNode" select="$containing-country"/>
      <xsl:with-param name="relationshipType" select="'IN'"/>
    </xsl:call-template>



  </xsl:template>

  <xsl:template match="listPlace[@type='city']/place">

    <!-- make var for city -->
    <xsl:variable name="current-city-node">
      <xsl:call-template name="simpleNode">
        <xsl:with-param name="identifier" select="'currentCity'"/>
        <xsl:with-param name="labels" select="':Place:City'"/>
        <xsl:with-param name="property-name" select="'uri'"/>
        <xsl:with-param name="property-value">
          <xsl:text>http://www.example.com/geo.xml#</xsl:text>
          <xsl:value-of select="@xml:id"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>


    <!-- merge it -->
    <xsl:call-template name="mergeNode">
      <xsl:with-param name="node" select="$current-city-node"/>
    </xsl:call-template>

    <!-- add name -->
    <xsl:call-template name="name-property">
      <xsl:with-param name="node" select="$current-city-node"/>
    </xsl:call-template>


    <!-- make var for country -->
    <xsl:variable name="containing-country">
      <xsl:call-template name="containing-place"> </xsl:call-template>
    </xsl:variable>

    <!-- make rel -->
    <xsl:call-template name="simpleRelationship">
      <xsl:with-param name="fromNode" select="$current-city-node"/>
      <xsl:with-param name="toNode" select="$containing-country"/>
      <xsl:with-param name="relationshipType" select="'IN'"/>
    </xsl:call-template>



  </xsl:template>

  <xsl:template match="listPlace[@type='past-region']/place">

    <!-- make var for region -->
    <xsl:variable name="current-region-node">
      <xsl:call-template name="simpleNode">
        <xsl:with-param name="identifier" select="'currentRegion'"/>
        <xsl:with-param name="labels" select="':Place:Historic_Region'"/>
        <xsl:with-param name="property-name" select="'uri'"/>
        <xsl:with-param name="property-value">
          <xsl:text>http://www.example.com/geo.xml#</xsl:text>
          <xsl:value-of select="@xml:id"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>


    <!-- merge it -->

    <xsl:call-template name="mergeNode">
      <xsl:with-param name="node" select="$current-region-node"/>
    </xsl:call-template>


    <!-- add name property -->
    <xsl:call-template name="name-property">
      <xsl:with-param name="node" select="$current-region-node"/>
    </xsl:call-template>

    <!-- generally, one shouldn't use too many conditional loops in xslts, instead focusing on templates.
      I think it's fine for short, simple loops like this, especially because we use $current-region-node
      in the loop, which we would have to port in if it were a template-->

    <xsl:for-each select="./location/region/@corresp">

      <!-- just making a quick variable for clarity's sake, you could declare this inline-->
      <xsl:variable name="uri-string">
        <xsl:text>geo.xml</xsl:text>
        <xsl:value-of select="."/>
      </xsl:variable>


      <!-- make a node for the country to link to -->
      <xsl:variable name="containing-country">
        <xsl:call-template name="callSimpleNode">
          <xsl:with-param name="nodeKind" select="'place'"/>
          <xsl:with-param name="property-value" select="concat('geo.xml', .)"/>
        </xsl:call-template>
      </xsl:variable>


      <!-- make relationship. These regions no longer exist as political divisions, they have been absorbed into other countries -->
      <xsl:call-template name="simpleRelationship">
        <xsl:with-param name="fromNode" select="$current-region-node"/>
        <xsl:with-param name="toNode" select="$containing-country"/>
        <xsl:with-param name="relationshipType" select="'IN_WHAT_IS_NOW'"/>
      </xsl:call-template>


    </xsl:for-each>


  </xsl:template>


  <xsl:template match="listPlace[@type='country']/place">

    <!-- make variable for the country node -->
    <xsl:variable name="current-country-node">
      <xsl:call-template name="simpleNode">
        <xsl:with-param name="identifier" select="'currentCountry'"/>
        <xsl:with-param name="labels" select="':Place:Country'"/>
        <xsl:with-param name="property-name" select="'uri'"/>
        <xsl:with-param name="property-value">
          <xsl:text>http://www.example.com/geo.xml#</xsl:text>
          <xsl:value-of select="@xml:id"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <!-- merge it -->

    <xsl:call-template name="mergeNode">
      <xsl:with-param name="node" select="$current-country-node"/>
    </xsl:call-template>

    <!-- add properties -->
    <xsl:call-template name="name-property">
      <xsl:with-param name="node" select="$current-country-node"/>
    </xsl:call-template>


    <!-- make var for europe, we will use an easier template.  -->
    <!-- the easier template won't have all the right info, but is enough to match on -->

    <xsl:variable name="europeNode">
      <xsl:call-template name="containing-place"/>
    </xsl:variable>

    <!-- link country to Europe -->
    <xsl:call-template name="simpleRelationship">
      <xsl:with-param name="fromNode" select="$current-country-node"/>
      <xsl:with-param name="toNode" select="$europeNode"/>
      <xsl:with-param name="relationshipType" select="'IN'"/>
    </xsl:call-template>


  </xsl:template>



  <xsl:template match="listPlace[@type='continent']/place">

    <!-- Make a variable for Europe -->
    <xsl:variable name="continent-node">
      <xsl:call-template name="simpleNode">
        <xsl:with-param name="identifier" select="'europe'"/>
        <xsl:with-param name="labels" select="':Place:Continent'"/>
        <xsl:with-param name="property-name" select="'uri'"/>
        <xsl:with-param name="property-value">
          <xsl:text>http://www.example.com/geo.xml#</xsl:text>
          <xsl:value-of select="@xml:id"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>


    <!-- merge Europe into the database. If you MERGE the same string more than one time, it will still
      only go into the database once. CREATE has the capability to make duplicate nodes from the same string -->
    <xsl:call-template name="mergeNode">
      <xsl:with-param name="node" select="$continent-node"/>
    </xsl:call-template>


    <!-- give it the right properties -->
    <xsl:call-template name="name-property">
      <xsl:with-param name="node" select="$continent-node"/>
    </xsl:call-template>

    <!-- since we gave Europe the correct labels and properties here, we can just refer to it based on URI later  -->

  </xsl:template>

<!-- these last few templates are bespoke templates that just call other templates. -->
  <xsl:template name="name-property">
    <xsl:param name="node"/>
    <xsl:call-template name="addProperties">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="property-name" select="'name'"/>
      <xsl:with-param name="property-value" select="./placeName | ./geogName"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="containing-place">
    <xsl:call-template name="callSimpleNode">
      <xsl:with-param name="nodeKind" select="'place'"/>
      <xsl:with-param name="property-value" select="concat('geo.xml', ./location/region/@corresp)"/>
    </xsl:call-template>
  </xsl:template>


</xsl:stylesheet>
