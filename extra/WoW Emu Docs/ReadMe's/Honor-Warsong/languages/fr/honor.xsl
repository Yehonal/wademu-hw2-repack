<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes"/>
<xsl:template match="/">
<!-- CopyRight 2005 RA3OR -->
<!-- Modified for Spirit's Honor System -->

<html>
<head>

<meta http-equiv="Pragma" content="no-cache"/>
<meta http-equiv="Cache-Control" content="no-cache"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta http-equiv="content-language" content="fr"/>
<title>Classement de l'Honneur</title>
<style type="text/css" media="screen">@import url(css/stats.css);</style>
</head>
<body>
<xsl:apply-templates/>

</body>
</html>
 </xsl:template>

  <!--// here (1.4.1 mod) //-->

  <xsl:template match="players">

	  <div class="center">
	  <p class="text">Classement de l'Honneur (<span class="stat"><xsl:value-of select="count"/></span> joueurs)</p>
	  <table class="refresh" align="center" border="0">
	  <td><a href="honor.xml" target="_self">Rafraîchir</a></td>
	  </table>
	  </div>

  <!-- tb3 --><table align="center" id="playerlist">
	 <tr class="plist">
	<td width="1%" align="center" class="statstdtop">Pos.</td>
	<td width="1%" align="center" class="statstdtop">Nom du personnage</td>
	<td width="1%" align="center" class="statstdtop">Nom de guilde</td>
	<td width="1%" align="center" class="statstdtop">Niveau</td>
	<td width="1%" align="center" class="statstdtop">Race</td>
	<td width="1%" align="center" class="statstdtop">Classe</td>
	<xsl:choose>
    <xsl:when test="defeats!=''">
	<td width="1%" align="center" class="statstdtop">Victoires</td>
	<td width="1%" align="center" class="statstdtop">Défaites</td>
	</xsl:when>
  	<xsl:otherwise>
  	<td width="1%" align="center" class="statstdtop">Victoires</td>
  	</xsl:otherwise>
	</xsl:choose>
	<td width="1%" align="center" class="statstdtop">Points</td>
	 </tr>


	  <xsl:for-each select="player">

	  <tr>


		  <td class="l3v3l">
			<div>
			<!-- pos -->
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
			   <xsl:when test="pos=1">er</xsl:when>
			   <xsl:when test="pos=2">e</xsl:when>
			   <xsl:when test="pos=3">e</xsl:when>
			   <xsl:otherwise>e</xsl:otherwise>
			</xsl:choose></sup>
			</div>
		 </td>

		 <td class="n4m3" style="text-align: left; padding-left: 5px;">
			<div>
			<xsl:attribute name="title">
			   <xsl:choose>
			   <xsl:when test="honor &lt; 1000  and (race=1 or race=3 or race=4 or race=7)">Grade: Soldat</xsl:when>
			   <xsl:when test="honor &lt; 5000  and (race=1 or race=3 or race=4 or race=7)">Grade: Caporal</xsl:when>
			   <xsl:when test="honor &lt; 10000 and (race=1 or race=3 or race=4 or race=7)">Grade: Sergent</xsl:when>
			   <xsl:when test="honor &lt; 15000 and (race=1 or race=3 or race=4 or race=7)">Grade: Sergent-chef</xsl:when>
			   <xsl:when test="honor &lt; 20000 and (race=1 or race=3 or race=4 or race=7)">Grade: Sergent-Major</xsl:when>
			   <xsl:when test="honor &lt; 25000 and (race=1 or race=3 or race=4 or race=7)">Grade: Chevalier</xsl:when>
			   <xsl:when test="honor &lt; 30000 and (race=1 or race=3 or race=4 or race=7)">Grade: Chevalier-lieutenant</xsl:when>
			   <xsl:when test="honor &lt; 35000 and (race=1 or race=3 or race=4 or race=7)">Grade: Chevalier-capitaine</xsl:when>
			   <xsl:when test="honor &lt; 40000 and (race=1 or race=3 or race=4 or race=7)">Grade: Chevalier-champion</xsl:when>
			   <xsl:when test="honor &lt; 45000 and (race=1 or race=3 or race=4 or race=7)">Grade: Lieutenant-commandant</xsl:when>
			   <xsl:when test="honor &lt; 50000 and (race=1 or race=3 or race=4 or race=7)">Grade: Commandant</xsl:when>
			   <xsl:when test="honor &lt; 55000 and (race=1 or race=3 or race=4 or race=7)">Grade: Maréchal</xsl:when>
			   <xsl:when test="honor &lt; 60000 and (race=1 or race=3 or race=4 or race=7)">Grade: Grand Maréchal</xsl:when>
			   <xsl:when test="honor &lt; 65001 and (race=1 or race=3 or race=4 or race=7)">Grade: Connétable</xsl:when>

			   <xsl:when test="honor &lt; 1000  and (race=2 or race=5 or race=6 or race=8)">Grade: Éclaireur</xsl:when>
			   <xsl:when test="honor &lt; 5000  and (race=2 or race=5 or race=6 or race=8)">Grade: Grunt</xsl:when>
			   <xsl:when test="honor &lt; 10000 and (race=2 or race=5 or race=6 or race=8)">Grade: Sergent</xsl:when>
			   <xsl:when test="honor &lt; 15000 and (race=2 or race=5 or race=6 or race=8)">Grade: Sergent-chef</xsl:when>
			   <xsl:when test="honor &lt; 20000 and (race=2 or race=5 or race=6 or race=8)">Grade: Adjudant</xsl:when>
			   <xsl:when test="honor &lt; 25000 and (race=2 or race=5 or race=6 or race=8)">Grade: Garde de pierre</xsl:when>
			   <xsl:when test="honor &lt; 30000 and (race=2 or race=5 or race=6 or race=8)">Grade: Garde de sang</xsl:when>
			   <xsl:when test="honor &lt; 35000 and (race=2 or race=5 or race=6 or race=8)">Grade: Légionnaire</xsl:when>
			   <xsl:when test="honor &lt; 40000 and (race=2 or race=5 or race=6 or race=8)">Grade: Centurion</xsl:when>
			   <xsl:when test="honor &lt; 45000 and (race=2 or race=5 or race=6 or race=8)">Grade: Champion</xsl:when>
			   <xsl:when test="honor &lt; 50000 and (race=2 or race=5 or race=6 or race=8)">Grade: Lieutenant-général</xsl:when>
			   <xsl:when test="honor &lt; 55000 and (race=2 or race=5 or race=6 or race=8)">Grade: Général</xsl:when>
			   <xsl:when test="honor &lt; 60000 and (race=2 or race=5 or race=6 or race=8)">Grade: Seigneur de guerre</xsl:when>
			   <xsl:when test="honor &lt; 65001 and (race=2 or race=5 or race=6 or race=8)">Grade: Grand seigneur de guerre</xsl:when>
			   </xsl:choose>
			</xsl:attribute>
			<!-- name -->
			<xsl:attribute name="class">
			   <xsl:choose>
			   <xsl:when test="race = 1">alliance</xsl:when>
			   <xsl:when test="race = 3">alliance</xsl:when>
			   <xsl:when test="race = 4">alliance</xsl:when>
			   <xsl:when test="race = 7">alliance</xsl:when>
			   <!--  -->
			   <xsl:when test="race = 2">horde</xsl:when>
			   <xsl:when test="race = 5">horde</xsl:when>
			   <xsl:when test="race = 6">horde</xsl:when>
			   <xsl:when test="race = 8">horde</xsl:when>
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
			</xsl:attribute></img> <xsl:value-of select="name" />
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
			<!-- level -->
			<xsl:attribute name="class">
			   <xsl:choose>
			   <xsl:when test="level &lt; 10">white</xsl:when>
			   <xsl:when test="level &lt; 20">low</xsl:when>
			   <xsl:when test="level &lt; 30">low-mid</xsl:when>
			   <xsl:when test="level &lt; 40">mid</xsl:when>
			   <xsl:when test="level &lt; 56">high</xsl:when>
			   <xsl:when test="level &gt; 55">high-blink</xsl:when>
			   </xsl:choose>

			</xsl:attribute>
			<xsl:value-of select="level" />
			</div>
		 </td>


		 <td class="r4c3">
			   <!-- race -->
		   <div>

			<xsl:attribute name="class">
			   <!-- race css -->
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
			   <xsl:when test="race = 1">Humain</xsl:when>
			   <xsl:when test="race = 2">Orc</xsl:when>
			   <xsl:when test="race = 3">Nain</xsl:when>
			   <xsl:when test="race = 4">ElfeDeLaNuit</xsl:when>
			   <xsl:when test="race = 5">MortVivant</xsl:when>
			   <xsl:when test="race = 6">Tauren</xsl:when>
			   <xsl:when test="race = 7">Gnome</xsl:when>
			   <xsl:when test="race = 8">Troll</xsl:when>
			   </xsl:choose>
<br />
			</div>
		 </td>


		<td class="cl4ss">
			<!-- class -->
		<div>

			<xsl:attribute name="class">
			   <!-- class css -->
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
			   <xsl:when test="class = 1">Guerrier</xsl:when>
			   <xsl:when test="class = 2">Paladin</xsl:when>
			   <xsl:when test="class = 3">Chasseur</xsl:when>
			   <xsl:when test="class = 4">Voleur</xsl:when>
			   <xsl:when test="class = 5">Prêtre</xsl:when>
			   <xsl:when test="class = 6">FUTURE_1</xsl:when>
			   <xsl:when test="class = 7">Shaman</xsl:when>
			   <xsl:when test="class = 8">Mage</xsl:when>
			   <xsl:when test="class = 9">Démoniste</xsl:when>
			   <xsl:when test="class = 10">FUTURE_2</xsl:when>
			   <xsl:when test="class = 11">Druide</xsl:when>
			   </xsl:choose>
<br />
			</div>
		 </td>


		  <td class="l3v3l">
			<span>
			<!-- kills -->
			<xsl:attribute name="class">
			  <xsl:choose>
			   <xsl:when test="kills &lt; 1">white</xsl:when>
			   <xsl:when test="kills &gt; 0">low</xsl:when>
			   </xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="kills" />
			</span>

			<xsl:if test="dkills!=''"> - <span>
			<!-- dkills -->
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
			<!-- defeats -->
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
			<!-- honor -->
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
   <!-- /tb3 --></table>

   <p><br/></p>
   </xsl:template>

   <xsl:template match="total">

	<table align="center" id="playerlist">
		<tr class="plist">
	<td align="center" class="statstdtop">Total Horde</td>
	<td align="center" class="statstdtop">Total Alliance</td>
	 </tr>
	 <tr>
	 <td class="n4m3"><span class="horde"><xsl:value-of select="horde" /></span></td>
	 <td class="n4m3"><span class="alliance"><xsl:value-of select="alliance" /></span></td>
	 </tr>

	</table>
	<p><br/></p>

   </xsl:template>


</xsl:stylesheet>