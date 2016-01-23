<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
  version="2.0">
  <xsl:output method="text" encoding="UTF-16" indent="no"/>
  <!-- This is a set of templates for creating cypher from xml -->


  <!-- outputs:  
    ($identifier$labels {$property-name: "$property-value"})
  -->
  <xsl:template name="simpleNode">
    <xsl:param name="identifier"/>
    <xsl:param name="labels"/>
    <xsl:param name="property-name"/>
    <xsl:param name="property-value"/>

    <xsl:text>(</xsl:text>
    <xsl:value-of select="$identifier"/>
    <xsl:value-of select="$labels"/>
    <xsl:text> {</xsl:text>
    <xsl:value-of select="$property-name"/>
    <xsl:text>: "</xsl:text>
    <xsl:value-of select="$property-value"/>
    <xsl:text>"})</xsl:text>
  </xsl:template>


  <!-- Our project used these node types the most. A template like this can be a timesaver -->
  <!-- this template just calls simpleNode with the right parameters -->
  <!-- we were using URIs to distinguish nodes but this example should be easily modifiable to suit your needs. -->
  <xsl:template name="callSimpleNode">
    <xsl:param name="nodeKind"/>
    <xsl:param name="property-value"/>

    <xsl:variable name="prefix">
      <xsl:text>http://www.example.com/</xsl:text>
    </xsl:variable>

    <xsl:choose>

      <xsl:when
        test="lower-case($nodeKind) = 'org' or lower-case($nodeKind) = 'organization'">
        <xsl:call-template name="simpleNode">
          <xsl:with-param name="identifier" select="'org'"/>
          <xsl:with-param name="labels">
            <xsl:text>:Organization</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="property-name">
            <xsl:text>uri</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="property-value">
            <xsl:value-of select="concat($prefix, $property-value)"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="lower-case($nodeKind) = 'person'">

        <!-- you can declare distinct prefixes like so -->
        <xsl:variable name="prefix-person">
          <xsl:text>http://www.other.example.com/</xsl:text>
        </xsl:variable>

        <xsl:call-template name="simpleNode">
          <xsl:with-param name="identifier" select="'person'"/>
          <xsl:with-param name="labels">
            <xsl:text>:Person</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="property-name">
            <xsl:text>uri</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="property-value">
            <xsl:value-of select="concat($prefix-person, $property-value)"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>

      <xsl:when
        test="lower-case($nodeKind) = 'peri' or lower-case($nodeKind) = 'periodical' or lower-case($nodeKind) = 'journal'">
        <xsl:call-template name="simpleNode">
          <xsl:with-param name="identifier" select="'periodical'"/>
          <xsl:with-param name="labels">
            <xsl:text>:Title:Periodical</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="property-name">
            <xsl:text>uri</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="property-value">
            <xsl:value-of select="concat($prefix, $property-value)"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>

      <xsl:when
        test="lower-case($nodeKind) = 'place' or lower-case($nodeKind) = 'location'">

        <xsl:call-template name="simpleNode">
          <xsl:with-param name="identifier" select="'place'"/>
          <xsl:with-param name="labels">
            <xsl:text>:Place</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="property-name">
            <xsl:text>uri</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="property-value">
            <xsl:value-of select="concat($prefix, $property-value)"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      
      <xsl:when
        test="lower-case($nodeKind) = 'geog' or lower-case($nodeKind) = 'geogname'">
        
        <xsl:call-template name="simpleNode">
          <xsl:with-param name="identifier" select="'place'"/>
          <xsl:with-param name="labels">
            <xsl:text>:Geographic_Feature</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="property-name">
            <xsl:text>uri</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="property-value">
            <xsl:value-of select="concat($prefix, $property-value)"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      
      


      <!-- this example does not use URIs but a seperate and simpler property called "handle" -->
      <xsl:when
        test="lower-case($nodeKind) = 'faith' or lower-case($nodeKind) = 'religion' or lower-case($nodeKind) = 'beleif_system'">
        <xsl:call-template name="simpleNode">
          <xsl:with-param name="identifier" select="'beliefSystem'"/>
          <xsl:with-param name="labels">
            <xsl:text>:Belief_System</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="property-name">
            <xsl:text>handle</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="property-value">
            <xsl:value-of select="$property-value"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      
      <xsl:when
        test="lower-case($nodeKind) = 'date'">
        
        <xsl:call-template name="simpleNode">
          <xsl:with-param name="identifier" select="'date'"/>
          <xsl:with-param name="labels">
            <xsl:text>:Date</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="property-name">
            <xsl:text>when</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="property-value">
            <xsl:value-of select="$property-value"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      
      <xsl:when
        test="lower-case($nodeKind) = 'time'">
        
        <xsl:call-template name="simpleNode">
          <xsl:with-param name="identifier" select="'time'"/>
          <xsl:with-param name="labels">
            <xsl:text>:Time</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="property-name">
            <xsl:text>when</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="property-value">
            <xsl:value-of select="$property-value"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>

      <!-- hacky error catching; you'll need to search your output for this -->
      <xsl:otherwise>
        <xsl:text> ERROR The nodeKind you tried to use is invalid </xsl:text>
      </xsl:otherwise>

    </xsl:choose>
  </xsl:template>




  <!-- outputs following line plus a carriage return: 
    MATCH $node SET $identifier.$property-name ="$property-value";
  -->
  <xsl:template name="addProperties">
    <xsl:param name="node"/>
    <xsl:param name="property-name"/>
    <xsl:param name="property-value"/>

    <xsl:variable name="identifier"
      select="substring-after(substring-before($node, ':'), '(')"/>

    <xsl:text>MATCH </xsl:text>
    <xsl:value-of select="$node"/>
    <xsl:text> SET </xsl:text>
    <xsl:value-of select="$identifier"/>
    <xsl:text>.</xsl:text>
    <xsl:value-of select="$property-name"/>
    <xsl:text> = "</xsl:text>
    <xsl:value-of select="$property-value"/>
    <xsl:text>";
      
    </xsl:text>

  </xsl:template>




  <!-- outputs following line plus a carriage return: 
    MERGE $nodeLine;
  -->
  <xsl:template name="mergeNode">
    <xsl:param name="node"/>

    <xsl:text>MERGE </xsl:text>
    <xsl:value-of select="$node"/>
    <xsl:text>;
      
    </xsl:text>
  </xsl:template>



  <!-- outputs following line plus a carriage return:
     MATCH $fromNode, $toNode CREATE UNIQUE ($fromIdentity)-[:$relationshipType]->($toIdentity);
  -->
  <xsl:template name="simpleRelationship">
    <xsl:param name="fromNode"/>
    <xsl:param name="toNode"/>
    <xsl:param name="relationshipType"/>

    <xsl:variable name="fromIdentity">
      <xsl:value-of
        select="substring-after(substring-before($fromNode, ':'), '(')"/>
    </xsl:variable>

    <xsl:variable name="toIdentity">
      <xsl:value-of
        select="substring-after(substring-before($toNode, ':'), '(')"/>
    </xsl:variable>

    <xsl:text>MATCH </xsl:text>
    <xsl:value-of select="$fromNode"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$toNode"/>
    <xsl:text> CREATE UNIQUE (</xsl:text>
    <xsl:value-of select="$fromIdentity"/>
    <xsl:text>)-[:</xsl:text>
    <xsl:value-of select="$relationshipType"/>
    <xsl:text>]->(</xsl:text>
    <xsl:value-of select="$toIdentity"/>
    <xsl:text>);
      
    </xsl:text>
  </xsl:template>

  <!-- outputs following line plus a carriage return:
     MATCH $fromNode, $toNode CREATE UNIQUE ($fromIdentity)-[:$relationshipType{$properties}]->($toIdentity);
  -->
  <xsl:template name="simpleRelationship-withProperties">
    <xsl:param name="fromNode"/>
    <xsl:param name="toNode"/>
    <xsl:param name="relationshipType"/>
    <xsl:param name="propertyList"/>

    <!-- we normalize the spaces and strip out a trailing comma if it exists -->
    <xsl:variable name="properties">
      <xsl:if test="ends-with(normalize-space($propertyList), ',')">
        <xsl:value-of
          select="substring(normalize-space($propertyList), 1, string-length(normalize-space($propertyList))-1)"
        />
      </xsl:if>

      <xsl:if test="not(ends-with(normalize-space($propertyList), ','))">
        <xsl:value-of select="normalize-space($propertyList)"/>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="fromIdentity">
      <xsl:value-of
        select="substring-after(substring-before($fromNode, ':'), '(')"/>
    </xsl:variable>

    <xsl:variable name="toIdentity">
      <xsl:value-of
        select="substring-after(substring-before($toNode, ':'), '(')"/>
    </xsl:variable>

    <xsl:text>MATCH </xsl:text>
    <xsl:value-of select="$fromNode"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$toNode"/>
    <xsl:text> CREATE UNIQUE (</xsl:text>
    <xsl:value-of select="$fromIdentity"/>
    <xsl:text>)-[:</xsl:text>
    <xsl:value-of select="$relationshipType"/>
    <xsl:text>{</xsl:text>
    <xsl:value-of select="$properties"/>
    <xsl:text>}]->(</xsl:text>
    <xsl:value-of select="$toIdentity"/>
    <xsl:text>);
      
    </xsl:text>

  </xsl:template>




  <!-- this is for getting dates out of a date element: <date from="1975" notAfter="1976"/> -->
  <!-- outputs: 
    name-of-first-attribute: "first-attribute-value", name-of-2nd-attribute: "2nd-attribute-value",
  -->
  <!-- given the example above, outputs:
     from: "1975", notAfter: "1976",
  -->
  <!-- beware, a trailing comma on properties is invalid cypher -->
  <xsl:template name="dateFormatter">
    <xsl:param name="dateElement" select="date"/>

    <!-- gets name of first attribute -->
    <xsl:value-of select="name($dateElement/@*[1])"/>
    <xsl:text>: "</xsl:text>
    <!-- gets value of first attribute -->
    <xsl:value-of select="$dateElement/@*[1]"/>
    <xsl:text>"</xsl:text>
    <!-- checks for a second time attribute and functions as above -->
    <xsl:if test="$dateElement/@*[2] 
      and (
         name($dateElement/@*[2]) = 'when' 
      or name($dateElement/@*[2]) = 'from' 
      or name($dateElement/@*[2]) = 'to' 
      or name($dateElement/@*[2]) = 'notAfter' 
      or name($dateElement/@*[2]) = 'notBefore'
      )">
      <xsl:text>, </xsl:text>
      <xsl:value-of select="name($dateElement/@*[2])"/>
      <xsl:text>: "</xsl:text>
      <xsl:value-of select="$dateElement/@*[2]"/>
      <xsl:text>",
      
      </xsl:text>
    </xsl:if>

  </xsl:template>


  <!-- this is for getting dates out 2 date elements: <date from="1975"/> <date notAfter="1976"/> -->
  <!-- outputs: 
    name-of-first-element: "first-element-value", name-of-2nd-element: "2nd-element-value",
  -->
  <!-- given the example above, outputs:
     from: "1975", notAfter: "1976",
  -->
  <!-- beware, a trailing comma on properties is invalid cypher -->
  <xsl:template name="dateFormatter-twoElements">
    <xsl:choose>
      <xsl:when test="./date[2]">
        <xsl:text/>
        <xsl:value-of select="name(date[1]/@*[1])"/>
        <xsl:text>: "</xsl:text>
        <xsl:value-of select="date[1]/@*[1]"/>
        <xsl:text>",</xsl:text>

        <xsl:value-of select="name(date[2]/@*[1])"/>
        <xsl:text>: "</xsl:text>
        <xsl:value-of select="date[2]/@*[1]"/>
        <xsl:text>",</xsl:text>
      </xsl:when>
      <xsl:when test="not(./date[2])">
        <xsl:text/>
        <xsl:value-of select="name(date/@*[1])"/>
        <xsl:text>: "</xsl:text>
        <xsl:value-of select="date[1]/@*[1]"/>
        <xsl:text>",</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>


  <!-- this will get text ready for cypher. It escapes all quotation marks and exclamation marks -->

  <!--  input: We didn't know what the "A" stood for!     -->
  <!-- output: We didn\'t know what the \"A\" stood for\! -->


  <xsl:template name="textFormatter">
    <xsl:param name="input"/>

    <xsl:variable name="doubleQuot">
      <xsl:text>"</xsl:text>
    </xsl:variable>

    <xsl:variable name="escaped-doubleQuot">
      <xsl:text>\\"</xsl:text>
    </xsl:variable>

    <xsl:variable name="singleQuot">
      <xsl:text>'</xsl:text>
    </xsl:variable>

    <xsl:variable name="escaped-singleQuot">
      <xsl:text>\\'</xsl:text>
    </xsl:variable>

    <xsl:variable name="formatted"
      select="
      replace(replace(replace(normalize-space($input),
      $doubleQuot , $escaped-doubleQuot),
      $singleQuot, $escaped-singleQuot),
       '!' , '\\!')
       
       "/>
    <xsl:value-of select="normalize-space($formatted)"/>
  </xsl:template>




  <xsl:template name="capitalizer">
    <xsl:param name="input"/>
    <!-- get the substring of the uppercase $input, starting from the first char, with a length of one char -->
    <xsl:value-of select="substring(upper-case($input), 1, 1)"/>
    <!-- get the substring of lowercase $input, from the 2nd char to the end -->
    <xsl:value-of select="substring(lower-case($input), 2)"/>

  </xsl:template>




  <!-- this template takes a $tokenize-on argument for when more than one word must be capitalized.
  -->
  <!-- set space-with to an empty string (ie. "") if you want the resultant string in PascalCase -->
  <xsl:template name="capitalizer-tokenize">
    <xsl:param name="input"/>
    <xsl:param name="tokenize-on"/>
    <xsl:param name="space-with" />

    <xsl:variable name="temp">
      <xsl:for-each select="tokenize($input, $tokenize-on)">
        <xsl:call-template name="capitalizer">
          <xsl:with-param name="input" select="."/>
        </xsl:call-template>
        <xsl:value-of select="$space-with"/>
      </xsl:for-each>
    </xsl:variable>

    <!-- if the user wants to space it with a character, delete the last character in the string because the last character will be $space-with -->
    <xsl:if test="string-length($space-with) &gt; 0">
      <xsl:value-of select="substring($temp, 1, string-length($temp) - 1)"/>
    </xsl:if>
    
    <!-- if the user wants an empty string, (ie. $space-with = "") do not delete the last character. -->
    <xsl:if test="string-length($space-with) = 0">
      <xsl:value-of select="$temp"/>
    </xsl:if>
    
    
  </xsl:template>




  <!-- take this example:
      <birth when="1975" source="www.example.com/1">
          <placeName corresp="places.xml#CITY" source="www.example.com/2" />
          <note type="notes" source="www.example.com/1">Lorem Ipsum</note>
          <certainty locus="value" source="www.example.com/3" />
      </birth>
  -->
  <!--  to use this template, pass $root as the parent element you're finding sources for. In this case root is <birth>-->
  <!-- the template will get any descendant @source and make cypher properties out of them -->
  <!-- if more than one @source has the same value, it will collapse them into one @source -->
  <!-- this example would output as:
     source: "www.example.com/1", placeName_source: "www.example.com/2", precision_source: "www.example.com/3" -->
  <xsl:template name="sources-to-properties">
    <xsl:param name="root"/>

    <xsl:variable name="values">
      <xsl:value-of select="distinct-values(descendant-or-self::*/@source)"/>
      <!-- if you want to omit a certain value, like 'unknown', use this syntax -->
      <!-- select = "distinct-values(descendant-or-self::*/@source[.!='unknown'])" -->
    </xsl:variable>
    <!-- because we've used distinct-values(), $values could be a sequence rather than a simple string -->

    <xsl:variable name="temp">
      <!-- since $values can be a sequence, check if there's only one -->
      <!-- also check that the one value is actually populated with something -->
      <xsl:if test="count($values)=1 and string-length($values) &gt; 2">
        <!--since there's only one source, we can just call it "source" -->
        <xsl:text>source: "</xsl:text>
        <xsl:value-of select="$values"/>
        <xsl:text>",</xsl:text>
      </xsl:if>


      <xsl:if test="count($values) &gt; 1">
        <!-- if we have more than one distinct value... -->

        <xsl:for-each select="$values">
          <!-- we need to make a string of the current value, not sure why this wont work inline -->
          <xsl:variable name="currentValue">
            <xsl:value-of select="string(.)"/>
          </xsl:variable>

          <!-- for our current distinct @source, if only one element matches $currentValue,
            make a named source -->
          <xsl:if
            test="count($root/descendant-or-self::*[@source= $currentValue]) = 1">

            <!-- get the whole node that has the same @source -->
            <xsl:variable name="matchingNode">
              <xsl:value-of
                select="
                $root/descendant-or-self::*[@source = $currentValue]"
              />
            </xsl:variable>

            <!-- here you can put xsl:if statements or xsl:choose statements to choose what to do 
            with specific cases-->
            <xsl:choose>
              <!-- here we'll make the template change @source if it's a child of certainty-->
              <xsl:when test="name($matchingNode) ='certainty'">
                <xsl:text>precision_</xsl:text>
              </xsl:when>
              <!-- otherwise, we'll just use the name of the containing element -->
              <xsl:otherwise>
                <xsl:value-of select="name($matchingNode)"/>
                <xsl:text>_</xsl:text>
              </xsl:otherwise>
            </xsl:choose>

            <!--this part is appended to the end of the string genereated by the <choose>  -->
            <xsl:text>source: "</xsl:text>
            <xsl:value-of select="$matchingNode/@source"/>
            <xsl:text>", </xsl:text>

            <!-- end of if only one @source matches -->
          </xsl:if>

          <!-- for our current distinct @source, if more than one element from root matches, 
            we can just call it "source" -->
          <xsl:if
            test="count($root/descendant-or-self::*[@source = $currentValue]) &gt; 1">
            <xsl:text>source: "</xsl:text>
            <xsl:value-of select="$currentValue"/>
            <xsl:text>", </xsl:text>
          </xsl:if>
          <!-- it is technically possible that you could get two properties just called "source" with two different values, however, it did not come up in our project. -->

          <!-- end of for each $values -->
        </xsl:for-each>
        <!-- end of if more than one $values -->
      </xsl:if>
      <!-- end of temp variable -->
    </xsl:variable>

    <!-- if statements will remove a trailing comma -->
    <xsl:if test="ends-with(normalize-space($temp), ',')">
      <xsl:value-of
        select="substring(normalize-space($temp), 1, string-length(normalize-space($temp))-1)"
      />
    </xsl:if>

    <xsl:if test="not(ends-with(normalize-space($temp), ','))">
      <xsl:value-of select="$temp"/>
    </xsl:if>
    <!-- end of sources template -->
  </xsl:template>


</xsl:stylesheet>
