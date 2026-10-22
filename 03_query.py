import sqlite3
import pandas as pd

con = sqlite3.connect("caers.db")

query = """
SELECT SUBSTR(DATE_FDA_FIRST_RECEIVED_REPORT, -4) AS year,
       COUNT(DISTINCT CASE WHEN PRODUCT = 'EXEMPTION 4' THEN REPORT_ID END) AS exemption4,
       COUNT(DISTINCT CASE WHEN PRODUCT != 'EXEMPTION 4' THEN REPORT_ID END) AS other
FROM product_events
WHERE PRODUCT_TYPE = 'SUSPECT' AND PRODUCT_CODE = '53'
GROUP BY year
ORDER BY year;
"""

print(pd.read_sql(query, con).to_string())
con.close()