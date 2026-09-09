# -*- coding: utf-8 -*-
"""
Export des tables du DW TelcoChurn vers des CSV pour Power BI.

Ce script remplace le « Save Results As » de SSMS, qui ne mettait pas
les en-têtes de colonnes. Il se connecte à SQL Server, lit chaque table
et écrit un CSV propre dans le dossier Power BI du projet.

Sortie : Power BI\\DimCustomer.csv, DimContract.csv, DimService.csv, FactSubscription.csv
Usage   : python export_powerbi.py
"""

import pandas as pd
import pyodbc

SERVEUR = r"MARWA\SQLEXPRESS"
BASE = "TelcoChurn_DW"
DOSSIER_SORTIE = r"C:\Users\marwa\Customer-Churn-Analytics\Power BI"

TABLES = ["DimCustomer", "DimContract", "DimService", "FactSubscription"]

connexion = pyodbc.connect(
    f"DRIVER={{ODBC Driver 17 for SQL Server}};"
    f"SERVER={SERVEUR};"
    f"DATABASE={BASE};"
    "Trusted_Connection=yes;"  # connexion Windows, pas de mot de passe
)

for table in TABLES:
    df = pd.read_sql(f"SELECT * FROM {table}", connexion)
    chemin = f"{DOSSIER_SORTIE}\\{table}.csv"
    # utf-8-sig : ajoute le BOM pour que Power BI et Excel lisent bien les accents
    df.to_csv(chemin, index=False, encoding="utf-8-sig")
    print(f"{table} : {df.shape[0]} lignes, {df.shape[1]} colonnes -> {chemin}")

connexion.close()
print("Export terminé.")