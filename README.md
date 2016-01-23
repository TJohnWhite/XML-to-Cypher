# XML-to-Cypher
=================

XML-to-Cypher is an XSLT library designed to create Cypher from XML. Cypher is used to make graphs using the [Neo4j](http://neo4j.com/) platform. This library was tested on Neo4j version 2.3.0 with XSLT version 2.0

The main file is generic-cypher.xsl, found in the XSLT folder. Some of its functionality is specific to the needs of the project that spawned XML-to-Cypher, so users will need to modify it to their own needs.

The rest of the files are examples of how to use XML-to-Cypher. The XML folder contains examples of TEI created from the novel Dracula, which is in the public domain. xslt-for-chapters.xsl and xslt-for-places.xsl run on those XML files. Use an XML editor like Oxygen to run the transformations. 


# XML-to-Cypher 
