#!/usr/bin/env python3
"""
Generate sitemap.xml for Google search indexing
"""
import os
from datetime import datetime
from pathlib import Path
from xml.etree import ElementTree as ET

# Configuration
BASE_URL = "https://schnitzler-bahr.acdh.oeaw.ac.at"
HTML_DIR = "./html"
OUTPUT_FILE = "./html/sitemap.xml"

# Priority and change frequency settings
PRIORITIES = {
    "index.html": "1.0",
    "toc.html": "0.9",
    "search.html": "0.8",
    "listperson.html": "0.7",
    "listplace.html": "0.7",
    "listwork.html": "0.7",
    "listorg.html": "0.7",
    "default": "0.5"
}

CHANGE_FREQ = {
    "index.html": "weekly",
    "default": "monthly"
}


def get_lastmod(file_path):
    """Get last modification time of file in ISO format"""
    mtime = os.path.getmtime(file_path)
    return datetime.fromtimestamp(mtime).strftime('%Y-%m-%d')


def create_sitemap():
    """Create sitemap.xml from HTML files"""

    # Create root element
    urlset = ET.Element('urlset')
    urlset.set('xmlns', 'http://www.sitemaps.org/schemas/sitemap/0.9')

    # Get all HTML files
    html_files = []
    for root, dirs, files in os.walk(HTML_DIR):
        for file in files:
            if file.endswith('.html'):
                file_path = os.path.join(root, file)
                rel_path = os.path.relpath(file_path, HTML_DIR)
                html_files.append((rel_path, file_path))

    # Sort files to ensure consistent order
    html_files.sort()

    # Add URLs to sitemap
    for rel_path, file_path in html_files:
        url = ET.SubElement(urlset, 'url')

        # Location
        loc = ET.SubElement(url, 'loc')
        url_path = rel_path.replace('\\', '/')
        loc.text = f"{BASE_URL}/{url_path}"

        # Last modified
        lastmod = ET.SubElement(url, 'lastmod')
        lastmod.text = get_lastmod(file_path)

        # Change frequency
        changefreq = ET.SubElement(url, 'changefreq')
        filename = os.path.basename(rel_path)
        changefreq.text = CHANGE_FREQ.get(filename, CHANGE_FREQ['default'])

        # Priority
        priority = ET.SubElement(url, 'priority')
        priority.text = PRIORITIES.get(filename, PRIORITIES['default'])

    # Create tree and write to file
    tree = ET.ElementTree(urlset)
    ET.indent(tree, space='  ')

    tree.write(OUTPUT_FILE, encoding='utf-8', xml_declaration=True)

    print(f"✓ Sitemap created: {OUTPUT_FILE}")
    print(f"✓ Total URLs: {len(html_files)}")

    # Print some statistics
    editions = sum(1 for f, _ in html_files if not os.path.basename(f).startswith(('index', 'toc', 'search', 'list', 'imprint', 'nachwort')))
    print(f"  - Edition pages: {editions}")
    print(f"  - Other pages: {len(html_files) - editions}")


if __name__ == '__main__':
    create_sitemap()
