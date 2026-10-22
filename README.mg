# Adverse event reports for supplements and cosmetics: what FDA's public complaint data can and cannot show

## Question
Which product categories have the highest share of severe-outcome reports in FDA's public adverse event data, and how has report volume changed over time? Written as a safety-signal analysis for a wellness brand's quality team.

## Data
- **Source:** FDA Human Foods Complaint System (HFCS), formerly CFSAN Adverse Event Reporting System (CAERS). Quarterly extract dated 2026-03-31, product-based CSV.
- **Size:** 236,014 rows, 151,589 distinct reports, 12 columns. FDA states the extract covers reports received 1 January 2004 to 31 March 2026. About 60 reports in the two categories studied carry earlier first-received dates (1999 to 2003); I left these out of the trend chart.
- **What one row means:** one product named in one report. A report that names several products appears as several rows (the largest has 44), so counting rows overcounts reports. All counts below are distinct reports.
- **Product role:** each row is SUSPECT (199,954 rows) or CONCOMITANT (36,060 rows). Only SUSPECT rows were used.
- **Categories compared:** code 53, Cosmetics; code 54, Vit/Min/Prot/Unconv Diet (Human/Animal), FDA's supplement-type category.
- **Type of data:** public industry-wide data. It is not any company's own data.

## Method
- Loaded the CSV into SQLite and queried it with SQL (queries.sql); pandas and matplotlib for the extract, charts and intervals.
- **Severe** = the outcome text contains Death, Hospitalization or Life Threatening. This is my own definition; the outcome field can hold several outcomes joined together, so I searched the text.
- Severe share = severe distinct reports / total distinct reports per category.
- 95% confidence intervals use the normal approximation for a proportion.

## Findings
1. **Row counts overstate reports.** 236,014 rows correspond to 151,589 reports.
2. **Severe share by category** (distinct SUSPECT reports):
   - Supplement-type (54): 32.0% (16,010 of 50,074; 95% CI 31.6 to 32.4%)
   - Cosmetics, all (53): 40.1% (20,922 of 52,134; 39.7 to 40.6%)
   - Cosmetics, talc-named products excluded: 38.2% (18,482 of 48,380; 37.8 to 38.6%)
   - Cosmetics, talc-named products and the withheld "EXEMPTION 4" label excluded: 5.1% (536 of 10,432; 4.7 to 5.6%)
3. **The cosmetics result depends on one group.** Among cosmetic reports with a Death outcome, the leading named products were talc powders, alongside cancer terms such as ovarian cancer and mesothelioma, but the single largest label was "EXEMPTION 4", a placeholder where the product name is withheld (but the single largest label was “EXEMPTION 4”. FDA redacts product names under Exemption 4 of the Freedom of Information Act, which protects trade secrets and commercial or financial information (21 CFR 20.111(c)(3)), so what those products are is unknown). Reports carrying that label make up most cosmetic reports from 2015 to 2022, peaking at 12,762 of 13,342 in 2021. Depending on whether that group is included, cosmetics comes out higher or far lower than supplements. This file cannot rank the two categories by severity.
4. **Supplements are more stable.** No product or hidden label dominates the top 10. The largest is 1,103 of 50,074 reports (about 2%).
5. **Volume over time (2004 to 2023):** supplement reports rose from 654 in 2004 to a peak of 4,100 in 2013, then settled between about 2,000 and 3,800. Cosmetic reports with named products rose from 789 in 2022 to 4,364 in 2023, for a reason I have not determined.
6. **Cosmetic reports after 2023 are missing from this file.** Named-product reports drop to 66 in 2024, 7 in 2025 and 1 in 2026. This looks like a change in where cosmetic reports are recorded, not a real fall: FDA launched a separate public dashboard for cosmetic adverse events, and mandatory reporting under MoCRA began in December 2023. The 2026 supplement count (650) covers one quarter only.

![Reports per year](reports_per_year.png)
![Severe share](severe_share.png)

## Limitations
- Reports are unverified and largely voluntary. They don't show that a product caused an event.
- No sales or usage denominator, so report counts are not risk rates.
- Reporting rules differ by category. Supplement manufacturers have to report serious events; cosmetic reporting was voluntary until recently. This can change the severe share of what gets reported.
- Error bars show sampling variation only. They don't capture who chooses to report, so they overstate precision.
- One report can name several products. Reports naming both a cosmetic and a supplement count in both categories.
- "Severe" is my own text-based definition and was not clinically validated.
- Some cleaning issues: the same description appears under two product codes (24 and 25, vegetables), and the same term can appear with different capitalisation (for example "Ovarian cancer" and "OVARIAN CANCER").
- Cosmetic data after 2023 is incomplete in this file (see Finding 6).
FDA notes that the same adverse event can be reported by more than one person (for example a consumer and a doctor), so duplicates may remain despite FDA’s efforts to remove them.
FDA states that these data can’t be used to estimate incidence or risk. That’s why this analysis compares shares of reports, not risk.
## Recommendations
- Treat the roughly 32% severe share for supplement-type reports as a description of what is reported, not a measure of risk.
- Never quote one cosmetics severe figure. Report it with and without the withheld group.
- To compare products fairly, add sales or exposure data, which this file does not contain.
- For cosmetics after 2023, use FDA's cosmetic dashboard instead of this file.

## Files
- queries.sql: every SQL query used
- 03_query.py, 04_chart.py, 05_stats.py, 06_chart2.py: scripts
- Data: download from the FDA HFCS page (not included, because of file size)