<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:include href="common.xsl"/>
    <xsl:variable name="suid-prefix" select="'1.2.4.0.13.1.4.2252867.'"/>
    <xsl:template match="/hl7">
        <dataset>
            <attr tag="00080005" vr="CS">ISO_IR 100</attr>
            <xsl:apply-templates select="PID"/>
            <xsl:apply-templates select="PV1"/>
            <xsl:apply-templates select="ORC[1]"/>
            <xsl:apply-templates select="OBR[1]"/>
            <!-- Scheduled Procedure Step Sequence -->
            <attr tag="00400100" vr="SQ">
                <xsl:apply-templates select="ORC" mode="sps"/>
            </attr>
        </dataset>
    </xsl:template>
    <xsl:template match="PID">

            <!-- Patient ID -->
        <xsl:call-template name="cx2attrs">
            <xsl:with-param name="idtag" select="'00100020'"/>
            <xsl:with-param name="istag" select="'00100021'"/>
            <xsl:with-param name="cx" select="field[3]"/>
        </xsl:call-template>
        <!-- hardcoding issuer as bahmni ORM message is not having it part of PID:3/3. Without this dcm4chee creates duplicate patients -->
        <attr tag="00100021" vr="LO">BahmniEMR</attr>
        <!-- Patient Birth Date -->
        <xsl:call-template name="attrDA">
          <xsl:with-param name="tag" select="'00100030'"/>
          <xsl:with-param name="val" select="string(field[7]/text())"/>
        </xsl:call-template>
        <!-- Patient Sex -->
        <xsl:call-template name="attr">
          <xsl:with-param name="tag" select="'00100040'"/>
          <xsl:with-param name="vr" select="'CS'"/>
          <xsl:with-param name="val" select="string(field[8]/text())"/>
        </xsl:call-template>

    </xsl:template>
    <xsl:template match="ORC[1]">
        <!-- AccessionNumber -->
        <xsl:call-template name="attr">
            <xsl:with-param name="tag" select="'00080050'"/>
            <xsl:with-param name="vr" select="'SH'"/>
            <xsl:with-param name="val" select="field[2]"/>
        </xsl:call-template>
        <!-- Placer Order Number -->
        <xsl:call-template name="ei2attr">
            <xsl:with-param name="tag" select="'00402016'"/>
            <xsl:with-param name="ei" select="field[2]"/>
        </xsl:call-template>
        <!-- Use Placer Order Number as Filler Order Number -->
        <xsl:call-template name="ei2attr">
            <xsl:with-param name="tag" select="'00402017'"/>
            <xsl:with-param name="ei" select="field[2]"/>
        </xsl:call-template>
        <!-- Referring Physican Name -->
        <xsl:call-template name="cn2pnAttr">
            <xsl:with-param name="tag" select="'00080090'"/>
            <xsl:with-param name="cn" select="field[12]/component[3]"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="OBR[1]">
        <!-- Patient Name -->
        <xsl:call-template name="attr">
          <xsl:with-param name="tag" select="'00100010'"/>
          <xsl:with-param name="vr" select="'PN'"/>
          <xsl:with-param name="val" select="string(field[43]/component[1]/text())"/>
        </xsl:call-template>

        <!-- Use Placer Order Number as Accession Number if missing OBR-18 -->
        <xsl:variable name="accno">
            <xsl:choose>
                <xsl:when test="field[18]/text()">
                    <xsl:value-of select="string(field[18]/text())"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="string(field[2]/text())"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:call-template name="attr">
            <xsl:with-param name="tag" select="'00080050'"/>
            <xsl:with-param name="vr" select="'SH'"/>
            <xsl:with-param name="val" select="$accno"/>
        </xsl:call-template>
        <!-- Provide Requesting Physician also as Referring Physican Name -->
        <xsl:call-template name="cn2pnAttr">
            <xsl:with-param name="tag" select="'00080090'"/>
            <xsl:with-param name="cn" select="field[16]"/>
        </xsl:call-template>
        <!-- Medical Alerts -->
        <xsl:call-template name="attr">
            <xsl:with-param name="tag" select="'00102000'"/>
            <xsl:with-param name="vr" select="'LO'"/>
            <xsl:with-param name="val" select="string(field[13]/text())"/>
        </xsl:call-template>
        <!-- Requesting Physician -->
        <xsl:call-template name="cn2pnAttr">
            <xsl:with-param name="tag" select="'00321032'"/>
            <xsl:with-param name="cn" select="field[16]"/>
        </xsl:call-template>
        <!-- (0032,1033) Requesting Service
        <xsl:call-template name="attr">
            <xsl:with-param name="tag" select="'00321033'"/>
            <xsl:with-param name="vr" select="'LO'"/>
            <xsl:with-param name="val" select="'Requesting Service'"/>
        </xsl:call-template>
        -->
        <!-- Patient State -->
        <xsl:call-template name="attr">
            <xsl:with-param name="tag" select="'00380500'"/>
            <xsl:with-param name="vr" select="'LO'"/>
            <xsl:with-param name="val" select="string(field[12]/text())"/>
        </xsl:call-template>
        <!-- Patient Transport Arrangements -->
        <xsl:call-template name="attr">
            <xsl:with-param name="tag" select="'00401004'"/>
            <xsl:with-param name="vr" select="'LO'"/>
            <xsl:with-param name="val" select="string(field[30]/text())"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="ORC" mode="sps">
        <item>
            <!-- Use Placer Order Number.position() as Scheduled Procedure Step ID -->
            <xsl:variable name="spsid" select="concat(string(field[2]/text()),'.',position())"/>
            <xsl:call-template name="attr">
                <xsl:with-param name="tag" select="'00400009'"/>
                <xsl:with-param name="vr" select="'SH'"/>
                <xsl:with-param name="val" select="$spsid"/>
            </xsl:call-template>
            <!-- Use SPS ID as Requested Procedure ID on SPS Level!-->
            <xsl:call-template name="attr">
                <xsl:with-param name="tag" select="'00401001'"/>
                <xsl:with-param name="vr" select="'SH'"/>
                <xsl:with-param name="val" select="$spsid"/>
            </xsl:call-template>
            <!-- Use SPS ID  as Study Instance UID on SPS Level -->
            <xsl:call-template name="attr">
                <xsl:with-param name="tag" select="'0020000D'"/>
                <xsl:with-param name="vr" select="'UI'"/>
                <xsl:with-param name="val" select="concat($suid-prefix,$spsid)"/>
            </xsl:call-template>
            <!-- Insert Requested Procedure Priority on SPS Level -->
            <xsl:call-template name="procedurePriority">
                <xsl:with-param name="priority" select="string(field[7]/component[5]/text())"/>
            </xsl:call-template>
            <!-- Scheduled Procedure Step Start Date/Time -->
            <xsl:call-template name="attrDATM">
                <xsl:with-param name="datag" select="'00400002'"/>
                <xsl:with-param name="tmtag" select="'00400003'"/>
                <xsl:with-param name="val" select="string(field[7]/component[3]/text())"/>
            </xsl:call-template>
            <xsl:apply-templates select="following-sibling::OBR[1]" mode="sps"/>
        </item>
    </xsl:template>
    <xsl:template name="procedurePriority">
        <xsl:param name="priority"/>
        <xsl:if test="normalize-space($priority)">
            <attr tag="00401003" vr="CS">
                <xsl:choose>
                    <xsl:when test="$priority = 'STAT'">STAT</xsl:when>
                    <xsl:when test="$priority = 'A' or $priority = 'P' or $priority = 'C' ">HIGH</xsl:when>
                    <xsl:when test="$priority = 'ROUTINE'">ROUTINE</xsl:when>
                 <xsl:when test="$priority = 'T'">MEDIUM</xsl:when>
                </xsl:choose>
            </attr>
        </xsl:if>
    </xsl:template>


    <!-- specific device XX -->
    <xsl:template match="OBR[field[24]/text()='XX']" mode="sps">
        <!-- Use ORB-24 as Scheduled Station Name -->
        <xsl:call-template name="attr">
            <xsl:with-param name="tag" select="'00400010'"/>
            <xsl:with-param name="vr" select="'SH'"/>
            <xsl:with-param name="val" select="string(field[24]/text())"/>
        </xsl:call-template>
        <!-- Scheduled Performing Physican Name -->
        <xsl:call-template name="cn2pnAttr">
            <xsl:with-param name="tag" select="'00400006'"/>
            <xsl:with-param name="cn" select="field[34]"/>
            <xsl:with-param name="cn26" select="field[34]/subcomponent"/>
        </xsl:call-template>
        <xsl:choose>
            <!-- if OBR-4.2-4:6 are missing -->
            <xsl:when test="count(field[4]/component) &lt; 5">
                <!-- Use ORB-4.2 as Procedure Description as Scheduled Procedure Step -->
                <xsl:call-template name="attr">
                    <xsl:with-param name="tag" select="'00400007'"/>
                    <xsl:with-param name="vr" select="'LO'"/>
                    <xsl:with-param name="val" select="string(field[4]/component[1]/text())"/>
                </xsl:call-template>
                <!-- Use ORB-4.1-3 as Scheduled Protocol Code -->
                <xsl:call-template name="codeItem">
                    <xsl:with-param name="sqtag" select="'00400008'"/>
                    <xsl:with-param name="code" select="string(field[4]/text())"/>
                    <xsl:with-param name="scheme" select="string(field[4]/component[2]/text())"/>
                    <xsl:with-param name="meaning" select="string(field[4]/component[1]/text())"/>
                </xsl:call-template>
            </xsl:when>
            <!-- treat according IHE -->
            <xsl:otherwise>
                <!-- Scheduled Procedure Step Description -->
                <xsl:call-template name="attr">
                    <xsl:with-param name="tag" select="'00400007'"/>
                    <xsl:with-param name="vr" select="'LO'"/>
                    <xsl:with-param name="val" select="field[4]/component[4]"/>
                </xsl:call-template>
                <!-- Scheduled Protocol Code Sequence -->
                <xsl:call-template name="codeItem">
                    <xsl:with-param name="sqtag" select="'00400008'"/>
                    <xsl:with-param name="code" select="string(field[4]/component[3]/text())"/>
                    <xsl:with-param name="scheme" select="string(field[4]/component[5]/text())"/>
                    <xsl:with-param name="meaning" select="string(field[4]/component[4]/text())"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <!-- Use ORB-4.2 as Requested Procedure Description on SPS Level! -->
        <xsl:call-template name="attr">
            <xsl:with-param name="tag" select="'00321060'"/>
            <xsl:with-param name="vr" select="'LO'"/>
            <xsl:with-param name="val" select="field[4]/component[1]"/>
        </xsl:call-template>
        <!-- Use ORB-4.1-3 as Requested Procedure Code Sequence on SPS Level-->
        <xsl:call-template name="codeItem">
            <xsl:with-param name="sqtag" select="'00321064'"/>
            <xsl:with-param name="code" select="string(field[4]/text())"/>
            <xsl:with-param name="scheme" select="string(field[4]/component[2]/text())"/>
            <xsl:with-param name="meaning" select="string(field[4]/component[1]/text())"/>
        </xsl:call-template>
    </xsl:template>

    <!-- other devices -->
    <xsl:template match="OBR" mode="sps">
        <!-- Modality -->
        <xsl:call-template name="attr">
            <xsl:with-param name="tag" select="'00080060'"/>
            <xsl:with-param name="vr" select="'CS'"/>
            <xsl:with-param name="val" select="string(field[24]/text())"/>
        </xsl:call-template>

        <!-- Use ORB-24 as Scheduled Station Name -->
        <xsl:call-template name="attr">
            <xsl:with-param name="tag" select="'00400010'"/>
            <xsl:with-param name="vr" select="'SH'"/>
            <xsl:with-param name="val" select="string(field[24]/text())"/>
        </xsl:call-template>
        <!-- Scheduled Performing Physican Name -->
        <xsl:call-template name="cn2pnAttr">
            <xsl:with-param name="tag" select="'00400006'"/>
            <xsl:with-param name="cn" select="field[34]"/>
            <xsl:with-param name="cn26" select="field[34]/subcomponent"/>
        </xsl:call-template>

        <!-- attaching comments like Urgent to SPS Description createing a string like [Urgent]CHEST PA-->
        <xsl:variable name="spsDescription">
            <xsl:choose>
                <xsl:when test="field[31]/component[1]/text()">
                    <xsl:value-of select="concat('[',string(field[31]/component[1]/text()),']',string(field[4]/component[1]/text()))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="string(field[4]/component[1]/text())"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <!-- if OBR-4.2-4:6 are missing -->
            <xsl:when test="count(field[4]/component) &lt; 5">
                <!-- Use ORB-4.2 as Procedure Description as Scheduled Procedure Step -->
                <xsl:call-template name="attr">
                    <xsl:with-param name="tag" select="'00400007'"/>
                    <xsl:with-param name="vr" select="'LO'"/>
                    <xsl:with-param name="val" select="$spsDescription"/>
                </xsl:call-template>
                <!-- Use ORB-4.1-3 as Scheduled Protocol Code -->
                <xsl:call-template name="codeItem">
                    <xsl:with-param name="sqtag" select="'00400008'"/>
                    <xsl:with-param name="code" select="string(field[4]/text())"/>
                    <xsl:with-param name="scheme" select="string(field[4]/component[2]/text())"/>
                    <xsl:with-param name="meaning" select="string(field[4]/component[1]/text())"/>
                </xsl:call-template>
            </xsl:when>
            <!-- treat according IHE -->
            <xsl:otherwise>
                <!-- Scheduled Procedure Step Description -->
                <xsl:call-template name="attr">
                    <xsl:with-param name="tag" select="'00400007'"/>
                    <xsl:with-param name="vr" select="'LO'"/>
                    <xsl:with-param name="val" select="string(field[4]/component[4]/text())"/>
                </xsl:call-template>
                <!-- Scheduled Protocol Code Sequence -->
                <xsl:call-template name="codeItem">
                    <xsl:with-param name="sqtag" select="'00400008'"/>
                    <xsl:with-param name="code" select="string(field[4]/component[3]/text())"/>
                    <xsl:with-param name="scheme" select="string(field[4]/component[5]/text())"/>
                    <xsl:with-param name="meaning" select="string(field[4]/component[4]/text())"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <!-- Use ORB-4.2 as Requested Procedure Description on SPS Level! -->
        <xsl:call-template name="attr">
            <xsl:with-param name="tag" select="'00321060'"/>
            <xsl:with-param name="vr" select="'LO'"/>
            <xsl:with-param name="val" select="concat(string(field[4]/component[1]/text()))"/>
        </xsl:call-template>
        <!-- Use ORB-4.1-3 as Requested Procedure Code Sequence on SPS Level-->
        <xsl:call-template name="codeItem">
            <xsl:with-param name="sqtag" select="'00321064'"/>
            <xsl:with-param name="code" select="string(field[4]/text())"/>
            <xsl:with-param name="scheme" select="string(field[4]/component[2]/text())"/>
            <xsl:with-param name="meaning" select="string(field[4]/component[1]/text())"/>
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>
