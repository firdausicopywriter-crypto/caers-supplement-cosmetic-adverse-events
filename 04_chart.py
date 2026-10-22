import sqlite3
import pandas as pd
import matplotlib.pyplot as plt

con = sqlite3.connect("caers.db")

query = """
SELECT SUBSTR(DATE_FDA_FIRST_RECEIVED_REPORT, -4) AS year,
       COUNT(DISTINCT CASE WHEN PRODUCT_CODE = '54' THEN REPORT_ID END) AS supplements,
       COUNT(DISTINCT CASE WHEN PRODUCT_CODE = '53' AND PRODUCT = 'EXEMPTION 4' THEN REPORT_ID END) AS cosmetics_exemption4,
       COUNT(DISTINCT CASE WHEN PRODUCT_CODE = '53' AND PRODUCT != 'EXEMPTION 4' THEN REPORT_ID END) AS cosmetics_other
FROM product_events
WHERE PRODUCT_TYPE = 'SUSPECT' AND PRODUCT_CODE IN ('53', '54')
  AND SUBSTR(DATE_FDA_FIRST_RECEIVED_REPORT, -4) BETWEEN '2004' AND '2023'
GROUP BY year
ORDER BY year;
"""

df = pd.read_sql(query, con)
con.close()

df = df.set_index("year")
df.plot(figsize=(10, 6))
plt.title("FDA adverse event reports per year (CAERS file, 2004-2023)")
plt.xlabel("Year first received by FDA")
plt.ylabel("Distinct reports")
plt.tight_layout()
plt.savefig("reports_per_year.png")
print("saved")