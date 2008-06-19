<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:premis="info:lc/xmlns/premis-v2" xmlns="http://www.loc.gov/METS/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.0">
	<xsl:output method="xml" indent="yes"/>
	<xsl:template match="/premis:premis">
		<mets>
			<amdSec>
				<xsl:apply-templates select="premis:object[@xsi:type='file']" mode="bucket"/>
				<xsl:apply-templates select="premis:object[xsi:type='representation']"/>
				<xsl:apply-templates select="premis:event"/>
				<xsl:apply-templates select="premis:agent"/>
			</amdSec>
			<fileSec>
				<fileGrp>
					<xsl:apply-templates select="premis:object[@xsi:type='file']" mode="file"/>
				</fileGrp>
			</fileSec>
			<structMap>
				<div/>
			</structMap>
			<xsl:apply-templates select="object[xsi:type='representation']"/>
		</mets>
	</xsl:template>
<!-- mets file -->
	<xsl:template match="premis:object[@xsi:type='file']" mode="file">
		<file>
<!-- ID -->
			<xsl:attribute name="ID">
				<xsl:text>FILE-</xsl:text><xsl:value-of select="generate-id()" />
			</xsl:attribute>
<!-- ADMID -->
			<xsl:attribute name="ADMID">
				<xsl:text>OBJECT-</xsl:text><xsl:value-of select="generate-id()" />
			</xsl:attribute>
<!-- size -->
			<xsl:attribute name="SIZE">
				<xsl:value-of select="premis:objectCharacteristics/premis:size"/>
			</xsl:attribute>
<!-- checksum -->
			<xsl:attribute name="CHECKSUM">
				<xsl:value-of select="premis:objectCharacteristics/premis:fixity/premis:messageDigest"/>
			</xsl:attribute>
			<xsl:if test="contains('HAVAL MD5 SHA-1 SHA-256 SHA-384 SHA-512 TIGER WHIRLPOOL', premis:objectCharacteristics/premis:fixity/premis:messageDigestAlgorithm)">
				<xsl:attribute name="CHECKSUMTYPE">
					<xsl:value-of select="premis:objectCharacteristics/premis:fixity/premis:messageDigestAlgorithm"/>
				</xsl:attribute>
			</xsl:if>
<!-- if identifier type is in LOCTYPE then set LOCTYPE to it, otherwise set it to OTHER and OTHERLOCTYPE -->
			<Flocat>
				<xsl:choose>
					<xsl:when test="contains('ARK URN URL PURL HANDLE DOI', premis:objectIdentifier/premis:objectIdentifierType)">
						<xsl:attribute name="TYPE">
							<xsl:value-of select="premis:objectIdentifier/premis:objectIdentifierType"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="TYPE">
							<xsl:text>OTHER</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="OTHERLOCTYPE">
							<xsl:value-of select="premis:objectIdentifier/premis:objectIdentifierType"/>
						</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:attribute name="xlink:href">
					<xsl:value-of select="premis:objectIdentifier/premis:objectIdentifierValue"/>
				</xsl:attribute>
			</Flocat>
		</file>
	</xsl:template>
<!-- make structmap for every representation -->
	<xsl:template match="object[@xsi:type='representation']">
		<structMap>
			<div>
				<xsl:comment>TODO div for each representation goes here</xsl:comment>
			</div>
		</structMap>
	</xsl:template>
<!-- techMD for premis files -->
	<xsl:template match="premis:object[@xsi:type='file']" mode="bucket">
		<xsl:call-template name="tech-bucket">
			<xsl:with-param name="contents">
				<xsl:copy-of select="."/>
			</xsl:with-param>
			<xsl:with-param name="identifier">
				<xsl:text>OBJECT-</xsl:text><xsl:value-of select="generate-id()" />
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
<!-- digiprovMD for premis representations -->
	<xsl:template match="premis:object[xsi:type='representation']">
		<xsl:call-template name="digiprov-bucket">
			<xsl:with-param name="contents">
				<xsl:copy-of select="."/>
			</xsl:with-param>
			<xsl:with-param name="identifier">
				<xsl:text>REPRESENTATION-</xsl:text><xsl:value-of select="generate-id()" />
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
<!-- digiprovMD for premis event -->
	<xsl:template match="premis:event">
		<xsl:call-template name="digiprov-bucket">
			<xsl:with-param name="contents">
				<xsl:copy-of select="."/>
			</xsl:with-param>
			<xsl:with-param name="identifier">
				<xsl:text>EVENT-</xsl:text><xsl:value-of select="generate-id()" />
			</xsl:with-param>			
		</xsl:call-template>
	</xsl:template>
<!-- digiprovMD for premis agent -->
	<xsl:template match="premis:agent">
		<xsl:call-template name="digiprov-bucket">
			<xsl:with-param name="contents">
				<xsl:copy-of select="."/>
			</xsl:with-param>
			<xsl:with-param name="identifier">
				<xsl:text>AGENT-</xsl:text><xsl:value-of select="generate-id()" />
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
<!-- mets digiprovMD bucket -->
	<xsl:template name="digiprov-bucket">
		<xsl:param name="contents"/>
		<xsl:param name="identifier"/>
		<digiprovMD>
			<xsl:attribute name="ID">
				<xsl:value-of select="$identifier"/>
			</xsl:attribute>
			<xsl:call-template name="mdwrap-xmldata-bucket">
				<xsl:with-param name="contents">
					<xsl:copy-of select="$contents"/>
				</xsl:with-param>
				<xsl:with-param name="mdtype">PREMIS</xsl:with-param>
			</xsl:call-template>
		</digiprovMD>
	</xsl:template>
<!-- mets techMD bucket -->
	<xsl:template name="tech-bucket">
		<xsl:param name="contents"/>
		<xsl:param name="identifier"/>
		<techMD>
			<xsl:attribute name="ID">
				<xsl:value-of select="$identifier"/>
			</xsl:attribute>
			<xsl:call-template name="mdwrap-xmldata-bucket">
				<xsl:with-param name="contents">
					<xsl:copy-of select="$contents"/>
				</xsl:with-param>
				<xsl:with-param name="mdtype">PREMIS</xsl:with-param>
			</xsl:call-template>
		</techMD>
	</xsl:template>
<!-- mets mdWrap/xmlData bucket -->
	<xsl:template name="mdwrap-xmldata-bucket">
		<xsl:param name="contents"/>
		<xsl:param name="mdtype"/>
		<mdWrap MDTYPE="$mdtype">
			<xsl:attribute name="MDTYPE">
				<xsl:value-of select="$mdtype"/>
			</xsl:attribute>
			<xmlData>
				<xsl:copy-of select="$contents"/>
			</xmlData>
		</mdWrap>
	</xsl:template>
</xsl:stylesheet>