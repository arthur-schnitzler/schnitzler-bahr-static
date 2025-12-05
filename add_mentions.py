import glob
import os
import lxml.etree as ET
from acdh_tei_pyutils.tei import TeiReader
from collections import defaultdict
from tqdm import tqdm


files = glob.glob('./data/editions/*.xml')
indices = glob.glob('./data/indices/list*.xml')

d = defaultdict(set)
for x in tqdm(sorted(files), total=len(files)):
    doc = TeiReader(x)
    file_name = os.path.split(x)[1]
    doc_title = doc.any_xpath('.//tei:titleStmt/tei:title[@level="a"]/text()')[0]
    # Extract ISO date from the document
    iso_date_nodes = doc.any_xpath('.//tei:titleStmt/tei:title[@type="iso-date"]/text()')
    iso_date = iso_date_nodes[0] if iso_date_nodes else ""
    for entity in doc.any_xpath('.//tei:back//*[@xml:id]/@xml:id'):
        d[entity].add(f"{file_name}_____{doc_title}_____{iso_date}")

for x in indices:
    doc = TeiReader(x)
    for node in doc.any_xpath('.//tei:body//*[@xml:id]'):
        node_id = node.attrib['{http://www.w3.org/XML/1998/namespace}id']
        for mention in d[node_id]:
            parts = mention.split('_____')
            file_name = parts[0]
            doc_title = parts[1]
            iso_date = parts[2] if len(parts) > 2 else ""

            note = ET.Element('{http://www.tei-c.org/ns/1.0}note')
            note.attrib['target'] = file_name
            note.attrib['type'] = "mentions"
            if iso_date:
                note.attrib['corresp'] = iso_date
            note.text = doc_title
            node.append(note)
    doc.tree_to_file(file=x)

print("DONE")