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
<title>Statut</title>
<style type="text/css" media="screen">@import url(css/stats.css);</style>
</head>
<body>
<xsl:apply-templates/>

</body>
</html>
 </xsl:template>
  <xsl:template match="server">
    <br />
	<table width="500px" align="center" id="serverinfo" >
    <tr>
      <td width="25%" class="statstdtop">Version</td>
      <td width="25%" class="statstdtop">Propriétaire</td>
      <td width="25%" class="statstdtop">Nom du serveur</td>
      <td width="25%" class="statstdtop">Fonctionnement</td>
     </tr>
      <xsl:apply-templates/>
	</table>
 </xsl:template>
  <xsl:template match="version">
    <td class="statstd">
      <xsl:apply-templates/>
    </td>
  </xsl:template>
  <xsl:template match="owner">
    <td class="statstd">
      <xsl:apply-templates/>
    </td>
  </xsl:template>
  <xsl:template match="servername">
    <td class="statstd">
      <xsl:apply-templates/>
    </td>
  </xsl:template>
  <xsl:template match="uptime">
    <td class="statstd">
      <xsl:apply-templates/>
    </td>
  </xsl:template>

  <xsl:template match="serverload">
    <br />
	<table width="500px" align="center" id="serverstats" >
    <tr>
      <td width="20%" class="statstdtop">Stats serveur</td>
      <td width="20%" class="statstdtop">Temps</td>
      <td width="20%" class="statstdtop">Boucles</td>
      <td width="20%" class="statstdtop">Temps total</td>
      <td width="20%" class="statstdtop">Charge</td>
    </tr>
      <xsl:apply-templates/>
  	</table>
   	<table class="refresh" align="center">
	<td><a href="stat.xml" target="_self">Rafraîchir</a></td>
	<td><a href="honor.xml" target="_self">Honneur</a></td>
	</table>


 </xsl:template>


  <xsl:template match="world">
    <tr class="plist">
     <td width="20%" class="statstd">Monde</td>
      <xsl:apply-templates/>
    </tr>
  </xsl:template>

  <xsl:template match="network">
    <tr class="plist">
     <td width="20%" class="statstd">Réseau</td>
      <xsl:apply-templates/>
    </tr>
  </xsl:template>

  <xsl:template match="configsleep">
    <td class="statstd">
      <xsl:apply-templates/>
    </td>
  </xsl:template>

  <xsl:template match="loops">
    <td class="statstd">
      <xsl:apply-templates/>
    </td>
  </xsl:template>

  <xsl:template match="totaltime">
    <td class="statstd">
      <xsl:apply-templates/>
    </td>
  </xsl:template>

  <xsl:template match="load">
    <td class="statstd">
      <xsl:apply-templates/>
    </td>
  </xsl:template>

  <xsl:template match="players">
      <div class="center">
      <p class="text">Il y a actuellement <span class="stat"><xsl:value-of select="count(./*)"/></span> joueurs en ligne.</p>
      </div>
  <table align="center" id="playerlist">
     <tr class="plist">
  	<td width="80px" align="center" class="statstdtop">Niveau</td>
  	<td width="80px" align="center" class="statstdtop">Nom</td>
  	<td width="60px" align="center" class="statstdtop">Race</td>
  	<td width="80px" align="center" class="statstdtop">Classe</td>
  	<td width="80px" align="center" class="statstdtop">Lieu</td>
  	<td width="80px" align="center" class="statstdtop">Zone</td>
  	<td width="80px" align="center" class="statstdtop">Latence</td>
  	<td width="80px" align="center" class="statstdtop">Niveau-J</td>

     </tr>

      <xsl:for-each select="player">

	  <xsl:sort select="level" data-type="number" />
      <tr>

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
               </xsl:choose>

            </xsl:attribute>
            <xsl:value-of select="level" />
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
			   <!--  -->
               <xsl:when test="race = 2">horde</xsl:when>
	           <xsl:when test="race = 5">horde</xsl:when>
               <xsl:when test="race = 6">horde</xsl:when>
               <xsl:when test="race = 8">horde</xsl:when>
               </xsl:choose>

            </xsl:attribute>
			<xsl:value-of select="name" />
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


         <td class="m4p">
			<xsl:choose>
  		<xsl:when test="map = 0">Azeroth</xsl:when>
  		<xsl:when test="map = 1">Kalimdor</xsl:when>
  		<xsl:when test="map = 13">Prison</xsl:when>
  		<xsl:when test="map = 25">Scott Test</xsl:when>
  		<xsl:when test="map = 29">Cash Test</xsl:when>
  		<xsl:when test="map = 30">Vallée d'Alterac</xsl:when>
  		<xsl:when test="map = 33">Donjon d'Ombrecroc</xsl:when>
  		<xsl:when test="map = 34">La Prison</xsl:when>
  		<xsl:when test="map = 35">Banque de Stormwind</xsl:when>
  		<xsl:when test="map = 36">Mortemines</xsl:when>
  		<xsl:when test="map = 37">Cratère d'Azshara</xsl:when>
 		<xsl:when test="map = 42">Collin's Test</xsl:when>
 		<xsl:when test="map = 43">Cavernes des lamentations</xsl:when>
 		<xsl:when test="map = 44">Monastère</xsl:when>
 		<xsl:when test="map = 47">Kraal de Tranchebauge</xsl:when>
 		<xsl:when test="map = 48">Pronfondeurs de Brassenoire</xsl:when>
 		<xsl:when test="map = 70">Uldaman</xsl:when>
 		<xsl:when test="map = 90">Gnomeregan</xsl:when>
		<xsl:when test="map = 109">Temple d'Atal'Hakkar</xsl:when>
 		<xsl:when test="map = 129">Souilles de Tranchebauge</xsl:when>
		<xsl:when test="map = 169">Rêve d'émeraude</xsl:when>
  		<xsl:when test="map = 189">Monastère écarlate</xsl:when>
  		<xsl:when test="map = 209">Zul'Farrak</xsl:when>
  		<xsl:when test="map = 229">Pic de Blackrock</xsl:when>
  		<xsl:when test="map = 230">Profondeurs de Blackrock</xsl:when>
  		<xsl:when test="map = 249">Repaire d'Onyxia</xsl:when>
  		<xsl:when test="map = 269">Grottes du temps</xsl:when>
  		<xsl:when test="map = 289">Scholomance</xsl:when>
  		<xsl:when test="map = 309">Zul'Gurub</xsl:when>
  		<xsl:when test="map = 329">Stratholme</xsl:when>
  		<xsl:when test="map = 349">Maraudon</xsl:when>
  		<xsl:when test="map = 369">Tram des pronfondeurs</xsl:when>
  		<xsl:when test="map = 389">Gouffre de Ragefeu</xsl:when>
  		<xsl:when test="map = 409">Coeur du Magma</xsl:when>
  		<xsl:when test="map = 429">Hache tripes</xsl:when>
  		<xsl:when test="map = 449">Hall des Champions</xsl:when>
  		<xsl:when test="map = 450">Hall des légendes</xsl:when>
  		<xsl:when test="map = 451">Île des programmeurs</xsl:when>
  		<xsl:when test="map = 469">Repaire de l'Aile noire</xsl:when>
  		<xsl:when test="map = 489">Goulet des Warsong</xsl:when>
  		<xsl:when test="map = 509">Ahn Qiraj</xsl:when>
  		<xsl:when test="map = 529">Bassin d'Arathi</xsl:when>
            </xsl:choose>
         </td>


         <td class="z0n3">
			<xsl:choose>
  		<xsl:when test="zone = 406">Serres Rocheuses</xsl:when>
  		<xsl:when test="zone = 15">Marécage d'Âprefange</xsl:when>
  		<xsl:when test="zone = 1377">Silithus</xsl:when>
  		<xsl:when test="zone = 1519">Stormwind</xsl:when>
  		<xsl:when test="zone = 1637">Orgrimmar</xsl:when>
  		<xsl:when test="zone = 1497">Undercity</xsl:when>
  		<xsl:when test="zone = 2597">Vallée d'Alterac</xsl:when>
  		<xsl:when test="zone = 357">Feralas</xsl:when>
  		<xsl:when test="zone = 440">Tanaris</xsl:when>
  		<xsl:when test="zone = 14">Durotar</xsl:when>
  		<xsl:when test="zone = 215">Mulgore</xsl:when>
  		<xsl:when test="zone = 17">Les Tarides</xsl:when>
  		<xsl:when test="zone = 36">Montagnes d'Alterac</xsl:when>
  		<xsl:when test="zone = 45">Arathi</xsl:when>
  		<xsl:when test="zone = 3">Terres ingrates</xsl:when>
  		<xsl:when test="zone = 4">Terres foudroyées</xsl:when>
  		<xsl:when test="zone = 85">Clairières de Tirisfal</xsl:when>
  		<xsl:when test="zone = 130">Pins argentés</xsl:when>
  		<xsl:when test="zone = 28">Maleterres de l'ouest</xsl:when>
  		<xsl:when test="zone = 139">Maleterres de l'est</xsl:when>
  		<xsl:when test="zone = 267">Hillsbrad</xsl:when>
  		<xsl:when test="zone = 47">Hinterlands</xsl:when>
  		<xsl:when test="zone = 1">Dun Morogh</xsl:when>
  		<xsl:when test="zone = 51">Gorge des Vents brûlants</xsl:when>
  		<xsl:when test="zone = 46">Steppes ardentes</xsl:when>
  		<xsl:when test="zone = 12">Forêt d'Elwynn</xsl:when>
  		<xsl:when test="zone = 41">Défilé de Deuillevent</xsl:when>
  		<xsl:when test="zone = 10">Bois de la pénombre</xsl:when>
  		<xsl:when test="zone = 38">Loch Modan</xsl:when>
  		<xsl:when test="zone = 44">Les Carmines</xsl:when>
  		<xsl:when test="zone = 33">Strangleronce</xsl:when>
  		<xsl:when test="zone = 8">Marais des Chagrins</xsl:when>
  		<xsl:when test="zone = 40">Marche de l'Ouest</xsl:when>
  		<xsl:when test="zone = 11">Les Paluns</xsl:when>
  		<xsl:when test="zone = 141">Teldrassil</xsl:when>
  		<xsl:when test="zone = 148">Sombrivage</xsl:when>
  		<xsl:when test="zone = 331">Ashenvale</xsl:when>
  		<xsl:when test="zone = 405">Desolace</xsl:when>
  		<xsl:when test="zone = 400">Mille pointes</xsl:when>
  		<xsl:when test="zone = 16">Azshara</xsl:when>
  		<xsl:when test="zone = 361">Gangrebois</xsl:when>
  		<xsl:when test="zone = 618">Berceau de l'Hiver</xsl:when>
  		<xsl:when test="zone = 1537">Ironforge</xsl:when>
  		<xsl:when test="zone = 1657">Darnassus</xsl:when>
  		<xsl:when test="zone = 490">Cratère d'Un'Goro</xsl:when>
  		<xsl:when test="zone = 493">Reflet de Lune</xsl:when>
  		<xsl:when test="zone = 719">Donjon</xsl:when>
  		<xsl:when test="zone = 1638">Thunder Bluff</xsl:when>
  		<xsl:when test="zone = 2100">Grotte maudite</xsl:when>
  		<xsl:when test="zone = 876">Île des MJ</xsl:when>
  		<xsl:when test="zone = 2557">Hache tripes</xsl:when>
            </xsl:choose>
         </td>


         <td class="p1ng">
            <div>
            <xsl:attribute name="class">
               <xsl:choose>
               <xsl:when test="ping &lt; 99">low</xsl:when>
               <xsl:when test="ping &lt; 199">mid</xsl:when>
               <xsl:when test="ping &gt; 199">high</xsl:when>
               </xsl:choose>

            </xsl:attribute>
            <xsl:value-of select="ping" />
            </div>
	     </td>


         <td class="p13v31">
		 <!-- plevel -->
			<div>

            <xsl:attribute name="class">
               <xsl:choose>
               <xsl:when test="plevel = 0">Player</xsl:when>
               <xsl:when test="plevel = 1">Counselor</xsl:when>
               <xsl:when test="plevel = 2">Seer</xsl:when>
               <xsl:when test="plevel = 3">Moderator</xsl:when>
               <xsl:when test="plevel = 4">GM</xsl:when>
               <xsl:when test="plevel = 5">Administrator</xsl:when>
	           <xsl:when test="plevel &gt; 5">Developer</xsl:when>
               </xsl:choose>
            </xsl:attribute>
            <!--<xsl:value-of select="plevel" /><br />-->
               <xsl:choose>
               <xsl:when test="plevel = 0">Joueur</xsl:when>
               <xsl:when test="plevel = 1">Conseiller</xsl:when>
               <xsl:when test="plevel = 2">Surveillant</xsl:when>
               <xsl:when test="plevel = 3">Modérateur</xsl:when>
               <xsl:when test="plevel = 4">Maître de jeu</xsl:when>
               <xsl:when test="plevel = 5">Administrateur</xsl:when>
	           <xsl:when test="plevel &gt; 5">Développeur</xsl:when>
               </xsl:choose>

            </div>
	     </td>



      </tr>
      </xsl:for-each>
</table>

   </xsl:template>

</xsl:stylesheet>