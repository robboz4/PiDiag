<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- ===============================================================
    Diagout.xsl: Formats the Linux Diagnostic Output.
    Tom Milner ( email: tomkmilner@gmail.com )
    Copyright (c) 2016, Tom Milner, all rights reserved
    February 15, 2016

    2017/02/28  Added templates system, lsmod, and System.
==================================================================== -->

<xsl:variable name='title'      select="'Diag Log'" />
<xsl:variable name='darkstripe' select="'#D7D6D4'" />
<xsl:variable name='stripe'     select="'#E8EAEF'" />

<!--===========
    Main
=============-->
<xsl:template match='/' >
    <html>
    <head>
    <title><xsl:value-of select='$title' /></title>
    <style>
        A:link          { text-decoration: underline; }
        A:visited       { text-decoration: underline; }
        A:active        { text-decoration: underline; }
        A:hover         { text-decoration: underline; }
        
        body {
            font-size: 10pt; 
            font-family: Verdana,Arial,Helvetica;
            color: black; 
            margin-left: 1em; 
            margin-right: 1em; 
        }
        h1 {
            font-size: 10pt; 
            font-family: Verdana,Arial,Helvetica;
            color: black; 
        }
        table {
            font-size: 10pt; 
            font-family: Verdana,Arial,Helvetica;
            color: black; 
            vertical-align: top;
            margin-left: 0em; 
            margin-right: 0em; 
            border: 1px solid black;
            border-collapse: collapse;
            border-spacing: 0;
        }
        tr.stripe {
            background-color: #E8EAEF ;     /** Light grey */
        }
        td {
            font-family: Verdana,Arial,Helvetica;
            padding: 5px ;
            vertical-align: top;
        }
        th {
            text-align: left;
            vertical-align: bottom;
            padding: 7px ;
            background-color: #D7D6D4 ;     /** dark grey */
        }
        pre {
            font-size: 10pt; 
            color: darkgreen; 
        }
    </style>
    </head>
    <body>
    <h1><xsl:value-of select='$title' /></h1>

    <xsl:apply-templates />

    </body>
    </html>
</xsl:template >


<!--=========================================================================
    Just show contents.
============================================================================-->
<xsl:template match="date" >
    <br/><xsl:value-of select='.' />
</xsl:template>

<!--=========================================================================
    Dumps a section as a table.
============================================================================-->
<xsl:template match="system|usb|lsmod|dmesg|ifconfig|wpa_cli|iwlist|SysLog" >
    <p/><table>
        <tr><th>
            <xsl:value-of select='name(.)' /><xsl:value-of select='./@tag' />
        </th></tr>
        <tr><td><pre><xsl:value-of select='.' /></pre></td></tr>
    </table>
</xsl:template>

</xsl:stylesheet>
