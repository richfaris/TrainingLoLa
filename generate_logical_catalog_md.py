#!/usr/bin/env python3
"""
Generate a Markdown reference for all views and fields in LoLaCatalog.xlsx
"""
import pandas as pd
from collections import defaultdict

def main():
    df = pd.read_excel('LoLaCatalog.xlsx')
    grouped = defaultdict(list)
    for _, row in df.iterrows():
        grouped[row['view_name']].append({
            'field_num': row['field_num'],
            'field_name': row['field_name'],
            'field_type': row['field_type'],
            'field_description': row['field_description']
        })
    
    with open('views/logical_catalog_reference.md', 'w', encoding='utf-8') as f:
        f.write('# BriteCore Logical Catalog Reference\n\n')
        f.write('This document lists all available views and their fields as found in `v_logical_catalog` (LoLaCatalog.xlsx).\n\n')
        for view in sorted(grouped.keys()):
            f.write(f'## `{view}`\n\n')
            f.write('| # | Field Name | Type | Description |\n')
            f.write('|---|------------|------|-------------|\n')
            for field in grouped[view]:
                num = field['field_num']
                name = field['field_name'] if pd.notnull(field['field_name']) else ''
                typ = field['field_type'] if pd.notnull(field['field_type']) else ''
                desc = field['field_description'] if pd.notnull(field['field_description']) else ''
                f.write(f'| {num} | {name} | {typ} | {desc} |\n')
            f.write('\n')
    print('Generated views/logical_catalog_reference.md')

if __name__ == '__main__':
    main() 