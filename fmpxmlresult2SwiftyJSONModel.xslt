<?xml version="1.0" encoding="UTF-8"?>
<!-- 
     Written by Gjermund G Thorsen 2017, all rights deserved
     for the purpose of generating SwiftJSONModel from FMPXMLRESULT
     This script was inspired by a talk given by https://github.com/alickbass for CocoaHeadNL 2017, Jan 18
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fmp="http://www.filemaker.com/fmpxmlresult" version="1.0">
	<xsl:output method="text" version="1.0" encoding="UTF-8" indent="no"/>
	<xsl:template match="fmp:FMPXMLRESULT">
		<xsl:text>import SwiftyJSONModel

struct </xsl:text><xsl:value-of select="$tableName"/><xsl:text> {
</xsl:text>			
				<xsl:for-each select="fmp:METADATA/fmp:FIELD">
          <xsl:text>  let </xsl:text><xsl:value-of select="@NAME"/><xsl:text>: </xsl:text>
          <xsl:value-of select="concat(
			              substring( 'String',		    	1 div boolean( @TYPE  = 'TEXT'      ) ),
			              substring( 'Binary',    			1 div boolean( @TYPE  = 'CONTAINER' ) ),
			              substring( 'NSTimeInterval',	1 div boolean( @TYPE  = 'DATE'      ) ),
			              substring( 'NSTimeInterval',	1 div boolean( @TYPE  = 'TIMESTAMP' ) ),
			              substring( 'NSTimeInterval',	1 div boolean( @TYPE  = 'TIME'      ) ),
			              substring( 'Int',             1 div boolean( @TYPE  = 'NUMBER'    ) )
			              )" />
                  <xsl:text>
</xsl:text>
				</xsl:for-each>
<xsl:text>}

extension </xsl:text><xsl:value-of select="$tableName"/><xsl:text>: JSONModelType {
  enum PropertyKey: String {
    case </xsl:text>
				<xsl:for-each select="fmp:METADATA/fmp:FIELD">
          <xsl:value-of select="@NAME"/>
          <xsl:text>, </xsl:text>
				</xsl:for-each>
<xsl:text>
  }

  init( object: JSONObject&lt;PropertyKey&gt; ) throws {
</xsl:text>
				<xsl:for-each select="fmp:METADATA/fmp:FIELD">
          <xsl:text>    </xsl:text>
          <xsl:value-of select="@NAME"/>
          <xsl:text> = try object.value( for: .</xsl:text>
          <xsl:value-of select="@NAME"/>
          <xsl:text> )
</xsl:text>
				</xsl:for-each>
<xsl:text>
  }
  
  var dictValue: [PropertyKey : JSONRepresentable?] {
    return [ </xsl:text>
				<xsl:for-each select="fmp:METADATA/fmp:FIELD">
          <xsl:text>.</xsl:text>
          <xsl:value-of select="@NAME"/>
          <xsl:text>: </xsl:text>
          <xsl:value-of select="@NAME"/>
          <xsl:text>, </xsl:text>
				</xsl:for-each>
<xsl:text> ]
  }
}
  
let </xsl:text><xsl:value-of select="$tableName"/><xsl:text>JSON = //JSON that we'll use for our model
do {
  let </xsl:text><xsl:value-of select="$tableName"/><xsl:text> = try </xsl:text><xsl:value-of select="$tableName"/><xsl:text>( json: </xsl:text><xsl:value-of select="$tableName"/><xsl:text>JSON )
  print( </xsl:text><xsl:value-of select="$tableName"/><xsl:text>.jsonValue )
} catch let error {
  print( error )
}
  </xsl:text>
  </xsl:template>
	<xsl:variable name="databaseName">
		<xsl:value-of select="fmp:FMPXMLRESULT/fmp:DATABASE/@NAME"/>
	</xsl:variable>
	<xsl:variable name="tableName">
		<xsl:value-of select="fmp:FMPXMLRESULT/fmp:DATABASE/@LAYOUT"/>
	</xsl:variable>
	<xsl:variable name="timeformat">
		<xsl:value-of select="fmp:FMPXMLRESULT/fmp:DATABASE/@TIMEFORMAT"/>
	</xsl:variable>
</xsl:stylesheet><!--
========================================================================================
Copyright (c) 2008 Gjermund Gusland Thorsen, released under the MIT License.
All rights deserved.
This piece comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law.
========================================================================================
-->
