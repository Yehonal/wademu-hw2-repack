<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes"/>
<xsl:template match="/">
<html>
<head><meta http-equiv="Pragma" content="no-cache"/>
<meta http-equiv="Cache-Control" content="no-cache"/>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251"/>
<meta http-equiv="content-language" content="en"/>
<title>Honor Rankings</title>
<style type="text/css" media="screen">@import url(css/stats.css);</style>
</head>
<body>
<xsl:apply-templates/>
</body>
</html>
 </xsl:template>
 <xsl:template match="players">
   <div class="center">
	<p class="text">Honor Rankings (<span class="stat"><xsl:value-of select="count(player)"/></span> players)</p>
	<table class="refresh" align="center" border="0">
	<td><a href="honor.xml" target="_self">Refresh</a></td><td><a href="stat.xml" target="_self">Online Status</a></td>
	</table>
	</div>
	<table align="center" id="playerlist">
	<tr class="plist">
	<td width="1%" align="center" class="statstdtop">Rank</td>
	<td width="1%" align="center" class="statstdtop">Position</td>
	<td width="1%" align="center" class="statstdtop">Nickname</td>
	<td width="1%" align="center" class="statstdtop">Guild Name</td>
	<td width="1%" align="center" class="statstdtop">Level</td>
	<td width="1%" align="center" class="statstdtop">Race</td>
	<td width="1%" align="center" class="statstdtop">Class</td>
	<xsl:choose>
    <xsl:when test="defeats!=''">
	<td width="1%" align="center" class="statstdtop">Victories</td>
	<td width="1%" align="center" class="statstdtop">Defeats</td>
	</xsl:when>
  	<xsl:otherwise>
  	<td width="1%" align="center" class="statstdtop">Kills</td>
  	</xsl:otherwise>
	</xsl:choose>
	<td width="1%" align="center" class="statstdtop">Rating</td>
	 </tr>
	  <xsl:for-each select="player"><tr>
	  <td class="n4m3">
			<div>
			<xsl:attribute name="title">
			   <xsl:choose>
			   <xsl:when test="honor &lt; 1000  and (race=1 or race=3 or race=4 or race=7)">Rank: Private</xsl:when>
			   <xsl:when test="honor &lt; 5000  and (race=1 or race=3 or race=4 or race=7)">Rank: Corporal</xsl:when>
			   <xsl:when test="honor &lt; 10000 and (race=1 or race=3 or race=4 or race=7)">Rank: Sergeant</xsl:when>
			   <xsl:when test="honor &lt; 15000 and (race=1 or race=3 or race=4 or race=7)">Rank: Master Sergeant</xsl:when>
			   <xsl:when test="honor &lt; 20000 and (race=1 or race=3 or race=4 or race=7)">Rank: Sergeant Major</xsl:when>
			   <xsl:when test="honor &lt; 25000 and (race=1 or race=3 or race=4 or race=7)">Rank: Knight</xsl:when>
			   <xsl:when test="honor &lt; 30000 and (race=1 or race=3 or race=4 or race=7)">Rank: Knight-Lieutenant</xsl:when>
			   <xsl:when test="honor &lt; 35000 and (race=1 or race=3 or race=4 or race=7)">Rank: Knight-Captain</xsl:when>
			   <xsl:when test="honor &lt; 40000 and (race=1 or race=3 or race=4 or race=7)">Rank: Knight-Champion</xsl:when>
			   <xsl:when test="honor &lt; 45000 and (race=1 or race=3 or race=4 or race=7)">Rank: Lieutenant Commander</xsl:when>
			   <xsl:when test="honor &lt; 50000 and (race=1 or race=3 or race=4 or race=7)">Rank: Commander</xsl:when>
			   <xsl:when test="honor &lt; 55000 and (race=1 or race=3 or race=4 or race=7)">Rank: Marshal</xsl:when>
			   <xsl:when test="honor &lt; 60000 and (race=1 or race=3 or race=4 or race=7)">Rank: Field Marshal</xsl:when>
			   <xsl:when test="honor &lt; 65001 and (race=1 or race=3 or race=4 or race=7)">Rank: Grand Marshal</xsl:when>
			   <xsl:when test="honor &lt; 1000  and (race=2 or race=5 or race=6 or race=8)">Rank: Scout</xsl:when>
			   <xsl:when test="honor &lt; 5000  and (race=2 or race=5 or race=6 or race=8)">Rank: Grunt</xsl:when>
			   <xsl:when test="honor &lt; 10000 and (race=2 or race=5 or race=6 or race=8)">Rank: Sergeant</xsl:when>
			   <xsl:when test="honor &lt; 15000 and (race=2 or race=5 or race=6 or race=8)">Rank: Senior Sergeant</xsl:when>
			   <xsl:when test="honor &lt; 20000 and (race=2 or race=5 or race=6 or race=8)">Rank: First Sergeant</xsl:when>
			   <xsl:when test="honor &lt; 25000 and (race=2 or race=5 or race=6 or race=8)">Rank: Stone Guard</xsl:when>
			   <xsl:when test="honor &lt; 30000 and (race=2 or race=5 or race=6 or race=8)">Rank: Blood Guard</xsl:when>
			   <xsl:when test="honor &lt; 35000 and (race=2 or race=5 or race=6 or race=8)">Rank: Legionnaire</xsl:when>
			   <xsl:when test="honor &lt; 40000 and (race=2 or race=5 or race=6 or race=8)">Rank: Centurion</xsl:when>
			   <xsl:when test="honor &lt; 45000 and (race=2 or race=5 or race=6 or race=8)">Rank: Champion</xsl:when>
			   <xsl:when test="honor &lt; 50000 and (race=2 or race=5 or race=6 or race=8)">Rank: Lieutenant General</xsl:when>
			   <xsl:when test="honor &lt; 55000 and (race=2 or race=5 or race=6 or race=8)">Rank: General</xsl:when>
			   <xsl:when test="honor &lt; 60000 and (race=2 or race=5 or race=6 or race=8)">Rank: Warlord</xsl:when>
			   <xsl:when test="honor &lt; 65001 and (race=2 or race=5 or race=6 or race=8)">Rank: High Warlord</xsl:when>
			   </xsl:choose>
			</xsl:attribute>
			   <img style="vertical-align: top">
			   <xsl:attribute name="src">
			   <xsl:choose>
			   <xsl:when test="honor &lt; 1000">ranks/rank1.gif</xsl:when>
			   <xsl:when test="honor &lt; 5000">ranks/rank2.gif</xsl:when>
			   <xsl:when test="honor &lt; 10000">ranks/rank3.gif</xsl:when>
			   <xsl:when test="honor &lt; 15000">ranks/rank4.gif</xsl:when>
			   <xsl:when test="honor &lt; 20000">ranks/rank5.gif</xsl:when>
			   <xsl:when test="honor &lt; 25000">ranks/rank6.gif</xsl:when>
			   <xsl:when test="honor &lt; 30000">ranks/rank7.gif</xsl:when>
			   <xsl:when test="honor &lt; 35000">ranks/rank8.gif</xsl:when>
			   <xsl:when test="honor &lt; 40000">ranks/rank9.gif</xsl:when>
			   <xsl:when test="honor &lt; 45000">ranks/rank10.gif</xsl:when>
			   <xsl:when test="honor &lt; 50000">ranks/rank11.gif</xsl:when>
			   <xsl:when test="honor &lt; 55000">ranks/rank12.gif</xsl:when>
			   <xsl:when test="honor &lt; 60000">ranks/rank13.gif</xsl:when>
			   <xsl:when test="honor &lt; 65001">ranks/rank14.gif</xsl:when>
			   <xsl:when test="honor &gt; 65000">ranks/rank15.gif</xsl:when>
			   </xsl:choose>
			 </xsl:attribute></img>
			</div>
		 </td>
	  <td class="l3v3l">
			<div>
			<xsl:attribute name="class">
			  <xsl:choose>
			   <xsl:when test="pos &gt; 100">white</xsl:when>
			   <xsl:when test="pos &gt; 50">low</xsl:when>
			   <xsl:when test="pos &gt; 20">low-mid</xsl:when>
			   <xsl:when test="pos &gt; 10">mid</xsl:when>
			   <xsl:when test="pos &gt; 1">high</xsl:when>
			   <xsl:when test="pos &lt; 2">high-blink</xsl:when>
			   </xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="pos" /><sup>
			<xsl:choose>
			   <xsl:when test="pos=1">st</xsl:when>
			   <xsl:when test="pos=2">nd</xsl:when>
			   <xsl:when test="pos=3">rd</xsl:when>
			   <xsl:otherwise>th</xsl:otherwise>
			</xsl:choose></sup>
			</div>
		 </td>

		 <td class="n4m3">
			<div>
			<xsl:attribute name="class">
			   <xsl:choose>
			   <xsl:when test="race = 1">alliance</xsl:when>
			   <xsl:when test="race = 3">alliance</xsl:when>
			   <xsl:when test="race = 4">alliance</xsl:when>
			   <xsl:when test="race = 7">alliance</xsl:when>
			   <xsl:when test="race = 2">horde</xsl:when>
			   <xsl:when test="race = 5">horde</xsl:when>
			   <xsl:when test="race = 6">horde</xsl:when>
			   <xsl:when test="race = 8">horde</xsl:when>
			   </xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="src">
			   <xsl:choose>
			   <xsl:when test="honor &lt; 1000"></xsl:when>
			   <xsl:when test="honor &lt; 5000"></xsl:when>
			   <xsl:when test="honor &lt; 10000"></xsl:when>
			   <xsl:when test="honor &lt; 15000"></xsl:when>
			   <xsl:when test="honor &lt; 20000"></xsl:when>
			   <xsl:when test="honor &lt; 25000"></xsl:when>
			   <xsl:when test="honor &lt; 30000"></xsl:when>
			   <xsl:when test="honor &lt; 35000"></xsl:when>
			   <xsl:when test="honor &lt; 40000"></xsl:when>
			   <xsl:when test="honor &lt; 45000"></xsl:when>
			   <xsl:when test="honor &lt; 50000"></xsl:when>
			   <xsl:when test="honor &lt; 55000"></xsl:when>
			   <xsl:when test="honor &lt; 60000"></xsl:when>
			   <xsl:when test="honor &lt; 65001"></xsl:when>
			   <xsl:when test="honor &gt; 65000"></xsl:when>
			   </xsl:choose>
			 </xsl:attribute><xsl:value-of select="name" />
		  </div>
		 </td>
         <td class="n4m3">
			<div>
			   <xsl:attribute name="class">
			   <xsl:choose>
			   <xsl:when test="race = 1">alliance</xsl:when>
			   <xsl:when test="race = 3">alliance</xsl:when>
			   <xsl:when test="race = 4">alliance</xsl:when>
			   <xsl:when test="race = 7">alliance</xsl:when>

			   <xsl:when test="race = 2">horde</xsl:when>
			   <xsl:when test="race = 5">horde</xsl:when>
			   <xsl:when test="race = 6">horde</xsl:when>
			   <xsl:when test="race = 8">horde</xsl:when>
			   </xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="guild" />
			</div>
		 </td>
		 <td class="l3v3l">
			<div>
			<xsl:attribute name="class">
			   <xsl:choose>
			   <xsl:when test="level &lt; 10">white</xsl:when>
			   <xsl:when test="level &lt; 20">low</xsl:when>
			   <xsl:when test="level &lt; 30">low-mid</xsl:when>
			   <xsl:when test="level &lt; 40">mid</xsl:when>
			   <xsl:when test="level &lt; 56">high</xsl:when>
			   <xsl:when test="level &gt; 55">high-blink</xsl:when>
			   </xsl:choose></xsl:attribute>
			<xsl:value-of select="level" />
			</div>
		 </td>
		 <td class="r4c3">
		   <div>
		   <xsl:attribute name="class">
		   <xsl:choose>
			   <xsl:when test="race = 1">Human</xsl:when>
			   <xsl:when test="race = 2">Orc</xsl:when>
			   <xsl:when test="race = 3">Dwarf</xsl:when>
			   <xsl:when test="race = 4">NightElf</xsl:when>
			   <xsl:when test="race = 5">Undead</xsl:when>
			   <xsl:when test="race = 6">Tauren</xsl:when>
			   <xsl:when test="race = 7">Gnome</xsl:when>
			   <xsl:when test="race = 8">Troll</xsl:when>
			   </xsl:choose>
			   </xsl:attribute>
             <br />
            <br />
		   <xsl:choose>
			   <xsl:when test="race = 1">Human</xsl:when>
			   <xsl:when test="race = 2">Orc</xsl:when>
			   <xsl:when test="race = 3">Dwarf</xsl:when>
			   <xsl:when test="race = 4">NightElf</xsl:when>
			   <xsl:when test="race = 5">Undead</xsl:when>
			   <xsl:when test="race = 6">Tauren</xsl:when>
			   <xsl:when test="race = 7">Gnome</xsl:when>
			   <xsl:when test="race = 8">Troll</xsl:when>
			   </xsl:choose>
              <br />
			</div>
		 </td>
		<td class="cl4ss">
		<div>
		<xsl:attribute name="class">
		   <xsl:choose>
			   <xsl:when test="class = 1">Warrior</xsl:when>
			   <xsl:when test="class = 2">Paladin</xsl:when>
			   <xsl:when test="class = 3">Hunter</xsl:when>
			   <xsl:when test="class = 4">Rogue</xsl:when>
			   <xsl:when test="class = 5">Priest</xsl:when>
			   <xsl:when test="class = 6">FUTURE_1</xsl:when>
			   <xsl:when test="class = 7">Shaman</xsl:when>
			   <xsl:when test="class = 8">Mage</xsl:when>
			   <xsl:when test="class = 9">Warlock</xsl:when>
			   <xsl:when test="class = 10">FUTURE_2</xsl:when>
			   <xsl:when test="class = 11">Druid</xsl:when>
			</xsl:choose>
			</xsl:attribute>
			    <br />
			   <br />
			   <xsl:choose>
			   <xsl:when test="class = 1">Warrior</xsl:when>
			   <xsl:when test="class = 2">Paladin</xsl:when>
			   <xsl:when test="class = 3">Hunter</xsl:when>
			   <xsl:when test="class = 4">Rogue</xsl:when>
			   <xsl:when test="class = 5">Priest</xsl:when>
			   <xsl:when test="class = 6">FUTURE_1</xsl:when>
			   <xsl:when test="class = 7">Shaman</xsl:when>
			   <xsl:when test="class = 8">Mage</xsl:when>
			   <xsl:when test="class = 9">Warlock</xsl:when>
			   <xsl:when test="class = 10">FUTURE_2</xsl:when>
			   <xsl:when test="class = 11">Druid</xsl:when>
			   </xsl:choose><br />
			</div>
		 </td>
		 <td class="l3v3l">
			<span>
			<xsl:attribute name="class">
			  <xsl:choose>
			   <xsl:when test="kills &lt; 1">white</xsl:when>
			   <xsl:when test="kills &gt; 0">low</xsl:when>
			   </xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="kills" />
			</span>
			<xsl:if test="dkills!=''">-<span>
			<xsl:attribute name="class">
			  <xsl:choose>
			   <xsl:when test="dkills &lt; 1">white</xsl:when>
			   <xsl:when test="dkills &gt; 0">high</xsl:when>
			   </xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="dkills" />
			</span>
			</xsl:if>
		 </td>
		 <xsl:if test="defeats!=''">
		 <td class="l3v3l">
			<span>
			<xsl:attribute name="class">
			  <xsl:choose>
			   <xsl:when test="defeats &lt; 1">white</xsl:when>
			   <xsl:when test="defeats &gt; 0">high</xsl:when>
			   </xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="defeats" />
			</span>
		 </td>
		 </xsl:if>
		 <td class="l3v3l">
			<div>
			<xsl:attribute name="class">
			  <xsl:choose>
			   <xsl:when test="honor &lt; 1000">white</xsl:when>
			   <xsl:when test="honor &lt; 20000">low</xsl:when>
			   <xsl:when test="honor &lt; 40000">low-mid</xsl:when>
			   <xsl:when test="honor &lt; 50000">mid</xsl:when>
			   <xsl:when test="honor &lt; 60000">high</xsl:when>
			   <xsl:when test="honor &gt; 59999">high-blink</xsl:when>
			   </xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="honor" />
			</div>
		 </td>
	  </tr>
	  </xsl:for-each>
      </table>
    <p><br/></p>
   </xsl:template>
   <xsl:template match="total">
	<table align="center" id="playerlist">
	<tr class="plist">
	<td align="center" class="statstdtop">Total-Horde</td>
	<td align="center" class="statstdtop">Total-Alliance</td>
	 </tr>
	 <tr>
	 <td class="n4m3"><span class="horde"><xsl:value-of select="horde" /></span></td>
	 <td class="n4m3"><span class="alliance"><xsl:value-of select="alliance" /></span></td>
	 </tr></table>
	<p><br/></p>
	</xsl:template>
</xsl:stylesheet>