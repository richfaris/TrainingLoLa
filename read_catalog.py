#!/usr/bin/env python3
"""
Read and analyze LoLaCatalog.xlsx to understand the structure
"""

import pandas as pd

def analyze_catalog():
    try:
        # Read the Excel file
        df = pd.read_excel('LoLaCatalog.xlsx')
        print("=== LoLaCatalog.xlsx Analysis ===")
        print(f"Shape: {df.shape}")
        print(f"Columns: {list(df.columns)}")
        print("\n=== First 5 rows ===")
        print(df.head())
        print("\n=== Column Info ===")
        print(df.info())
        print("\n=== Sample data by column ===")
        for col in df.columns:
            print(f"\n{col}:")
            print(df[col].head(3).tolist())
        return df
    except Exception as e:
        print(f"Error reading file: {e}")
        return None

if __name__ == "__main__":
    analyze_catalog() 