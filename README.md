# Arthur Schnitzler, Hermann Bahr: Briefwechsel, Aufzeichnungen, Dokumente (1891–1931). Website (no data)

This application fetches the data from this repository: https://github.com/arthur-schnitzler/schnitzler-bahr-data and deploys it as a website: https://schnitzler-bahr.acdh.oeaw.ac.at. 

Addressed (and mostly solved) are several shortcomings of the previous iteration. Also included is a closer integration with other biographical sources of Arthur Schnitzler developped at the Austrian Centre for Digital Humanities (ACDH) at the Austrian Academy of Sciences, see: https://schnitzler.acdh.oeaw.ac.at

* build with [DSE-Static-Cookiecutter](https://github.com/acdh-oeaw/dse-static-cookiecutter)

## Build Process

The website is automatically built and deployed via GitHub Actions. The build process includes:

1. XSLT transformation of TEI XML files to HTML
2. Typesense search index generation
3. Sitemap.xml generation for search engines

The sitemap is automatically generated during the build process and includes all HTML pages with appropriate priorities and change frequencies.

## Third-Party Software

This repository includes Saxon-HE (Home Edition) 9.x, an XSLT and XQuery processor. Saxon-HE is licensed under the [Mozilla Public License Version 2.0](https://www.mozilla.org/en-US/MPL/2.0/). The complete license text is available in [saxon/notices/LICENSE.txt](saxon/notices/LICENSE.txt).

For more information about Saxon, visit [https://www.saxonica.com/](https://www.saxonica.com/).
