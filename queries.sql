-- Project 1: FDA adverse event reports (HFCS/CAERS), supplements vs cosmetics
-- Table: product_events (one row = one product inside one report)

-- 1. Rows vs distinct reports (SQL version of the pandas check)
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT REPORT_ID) AS distinct_reports
FROM product_events;

-- 2. Role of each product in the report: SUSPECT vs CONCOMITANT
SELECT PRODUCT_TYPE, COUNT(*) AS n
FROM product_events
GROUP BY PRODUCT_TYPE
ORDER BY n DESC;

-- 3. Product categories among SUSPECT rows (53 = Cosmetics, 54 = Vit/Min/Prot/Unconv Diet)
SELECT PRODUCT_CODE, DESCRIPTION, COUNT(*) AS n
FROM product_events
WHERE PRODUCT_TYPE = 'SUSPECT'
GROUP BY PRODUCT_CODE, DESCRIPTION
ORDER BY n DESC
LIMIT 15;

-- 4. Outcome combinations by category (distinct reports)
SELECT PRODUCT_CODE, CASE_OUTCOME, COUNT(DISTINCT REPORT_ID) AS reports
FROM product_events
WHERE PRODUCT_TYPE = 'SUSPECT' AND PRODUCT_CODE IN ('53', '54')
GROUP BY PRODUCT_CODE, CASE_OUTCOME
ORDER BY reports DESC
LIMIT 20;

-- 5. Severe share by category (severe = Death, Hospitalization or Life Threatening)
SELECT PRODUCT_CODE,
       COUNT(DISTINCT REPORT_ID) AS total_reports,
       COUNT(DISTINCT CASE
            WHEN CASE_OUTCOME LIKE '%Death%'
              OR CASE_OUTCOME LIKE '%Hospitalization%'
              OR CASE_OUTCOME LIKE '%Life Threatening%'
            THEN REPORT_ID END) AS severe_reports
FROM product_events
WHERE PRODUCT_TYPE = 'SUSPECT' AND PRODUCT_CODE IN ('53', '54')
GROUP BY PRODUCT_CODE;

-- 6. Reported terms in cosmetic reports with a Death outcome
SELECT CASE_MEDDRA_PREFERRED_TERMS, COUNT(DISTINCT REPORT_ID) AS n
FROM product_events
WHERE PRODUCT_TYPE = 'SUSPECT' AND PRODUCT_CODE = '53'
  AND CASE_OUTCOME LIKE '%Death%'
GROUP BY CASE_MEDDRA_PREFERRED_TERMS
ORDER BY n DESC
LIMIT 10;

-- 7. Products named in cosmetic reports with a Death outcome
SELECT PRODUCT, COUNT(DISTINCT REPORT_ID) AS n
FROM product_events
WHERE PRODUCT_TYPE = 'SUSPECT' AND PRODUCT_CODE = '53'
  AND CASE_OUTCOME LIKE '%Death%'
GROUP BY PRODUCT
ORDER BY n DESC
LIMIT 10;

-- 8. Cosmetics severe share, talc names AND "EXEMPTION 4" excluded
SELECT COUNT(DISTINCT REPORT_ID) AS total_reports,
       COUNT(DISTINCT CASE
            WHEN CASE_OUTCOME LIKE '%Death%'
              OR CASE_OUTCOME LIKE '%Hospitalization%'
              OR CASE_OUTCOME LIKE '%Life Threatening%'
            THEN REPORT_ID END) AS severe_reports
FROM product_events
WHERE PRODUCT_TYPE = 'SUSPECT' AND PRODUCT_CODE = '53'
  AND REPORT_ID NOT IN (
      SELECT REPORT_ID FROM product_events
      WHERE PRODUCT = 'EXEMPTION 4'
         OR PRODUCT LIKE 'JOHNSONS POWDER%'
         OR PRODUCT LIKE '%TALC%'
         OR PRODUCT LIKE '%SHOWER TO SHOWER%'
  );

-- 9. Cosmetics severe share, talc names excluded only (Exemption 4 kept in)
SELECT COUNT(DISTINCT REPORT_ID) AS total_reports,
       COUNT(DISTINCT CASE
            WHEN CASE_OUTCOME LIKE '%Death%'
              OR CASE_OUTCOME LIKE '%Hospitalization%'
              OR CASE_OUTCOME LIKE '%Life Threatening%'
            THEN REPORT_ID END) AS severe_reports
FROM product_events
WHERE PRODUCT_TYPE = 'SUSPECT' AND PRODUCT_CODE = '53'
  AND REPORT_ID NOT IN (
      SELECT REPORT_ID FROM product_events
      WHERE PRODUCT LIKE 'JOHNSONS POWDER%'
         OR PRODUCT LIKE '%TALC%'
         OR PRODUCT LIKE '%SHOWER TO SHOWER%'
  );

-- 10. Top supplement products (checks for a dominant cluster)
SELECT PRODUCT, COUNT(DISTINCT REPORT_ID) AS n
FROM product_events
WHERE PRODUCT_TYPE = 'SUSPECT' AND PRODUCT_CODE = '54'
GROUP BY PRODUCT
ORDER BY n DESC
LIMIT 10;

-- 11. Distinct reports per year by category (date stored as text, year = last 4 characters)
SELECT SUBSTR(DATE_FDA_FIRST_RECEIVED_REPORT, -4) AS year,
       COUNT(DISTINCT CASE WHEN PRODUCT_CODE = '53' THEN REPORT_ID END) AS cosmetics,
       COUNT(DISTINCT CASE WHEN PRODUCT_CODE = '54' THEN REPORT_ID END) AS supplements
FROM product_events
WHERE PRODUCT_TYPE = 'SUSPECT' AND PRODUCT_CODE IN ('53', '54')
GROUP BY year
ORDER BY year;

-- 12. Cosmetics per year: "EXEMPTION 4" vs all other products
SELECT SUBSTR(DATE_FDA_FIRST_RECEIVED_REPORT, -4) AS year,
       COUNT(DISTINCT CASE WHEN PRODUCT = 'EXEMPTION 4' THEN REPORT_ID END) AS exemption4,
       COUNT(DISTINCT CASE WHEN PRODUCT != 'EXEMPTION 4' THEN REPORT_ID END) AS other
FROM product_events
WHERE PRODUCT_TYPE = 'SUSPECT' AND PRODUCT_CODE = '53'
GROUP BY year
ORDER BY year;