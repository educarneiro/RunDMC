<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xdmp="http://marklogic.com/xdmp"
  xmlns      ="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:u    ="http://marklogic.com/rundmc/util"
  xmlns:api="http://marklogic.com/rundmc/api"
  xmlns:ml               ="http://developer.marklogic.com/site/internal"
  xpath-default-namespace="http://developer.marklogic.com/site/internal"
  exclude-result-prefixes="xs ml xdmp api">

  <xsl:import href="../../view/page.xsl"/>
  <xsl:import href="xquery-imports.xsl"/>

  <xsl:include href="tag-library.xsl"/>

  <xsl:variable name="template"   select="u:get-doc('/apidoc/config/template.xhtml')"/>

  <xsl:template match="ml:api-toc">
    <div id="apidoc_toc">
      <script type="text/javascript">
        window.onbeforeunload = function () {
            // Get current TOC scroll position
            $.cookie("tocScroll", $("#sub").scrollTop(), { expires: 7 });
        }

        $('#sub').load('<xsl:value-of select="$api:toc-url"/>', function() {
          $("#sub").scrollTop($.cookie("tocScroll"));
          $("#sub a[href='/<xsl:value-of select="substring-after(ml:external-uri($content),'/')"/>']").addClass("currentPage");
        });
      </script>
    </div>
  </xsl:template>

  <xsl:template mode="page-content" match="api:function-list-page">
    <div class="doclist">
      <h2>&#160;</h2>
      <span class="amount">
        <xsl:variable name="count" select="count(api:function-listing)"/>
        <xsl:value-of select="$count"/>
        <xsl:text> function</xsl:text>
        <xsl:if test="$count gt 1">s</xsl:if>
      </span>
      <table class="documentsTable">
        <colgroup>
          <col class="col1"/>
          <col class="col2"/>
        </colgroup>
        <thead>
          <tr>
            <th>Function name</th>
            <th>Description</th>
          </tr>
        </thead>
        <tbody>
          <xsl:apply-templates select="api:function-listing"/>
        </tbody>
      </table>
    </div>
  </xsl:template>

          <xsl:template match="api:function-listing">
            <tr>
              <td>
                <a href="/{api:name}">
                  <xsl:value-of select="api:name"/>
                </a>
              </td>
              <td>
                <xsl:apply-templates select="api:description/node()"/>
              </td>
            </tr>
          </xsl:template>

  <!-- Make everything a "main page" -->
  <xsl:template mode="body-class" match="*">main_page</xsl:template>


  <!-- Account for "/apidoc" prefix in internal/external URI mappings -->
  <xsl:function name="ml:external-uri" as="xs:string">
    <xsl:param name="node" as="node()"/>
    <xsl:variable name="doc-path" select="base-uri($node)"/>
    <xsl:sequence select="if ($doc-path eq '/apidoc/index.xml') then '/' else substring-before(substring-after($doc-path,'/apidoc'), '.xml')"/>
  </xsl:function>

  <xsl:function name="ml:internal-uri" as="xs:string">
    <xsl:param name="doc-path" as="xs:string"/>
    <xsl:sequence select="if ($doc-path eq '/') then '/apidoc/index.xml' else concat('/apidoc', $doc-path, '.xml')"/>
  </xsl:function>

  <!-- Don't ever add any special CSS classes -->
  <xsl:template mode="body-class-extra" match="*"/>

</xsl:stylesheet>
