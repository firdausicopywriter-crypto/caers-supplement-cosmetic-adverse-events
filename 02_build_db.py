import pandas as pd
import sqlite3

df = pd.read_csv("product based.csv")
con = sqlite3.connect("caers.db")
df.to_sql("product_events", con, if_exists="replace", index=False)
con.close()
print("done")