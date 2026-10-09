# Cart Abandonment Analysis

Many online shoppers add products to their cart and then leave without buying. In this project, I analyzed session, order, and ad data from an online store to find where customers drop off, which ads and devices perform better, and what the business should fix first.

**Tools used:** Python (Pandas, NumPy), MySQL, Power BI, Excel
**Skills practiced:** ETL, EDA, SQL analysis, dashboarding, business insights

## Business Question

Where are customers dropping off in the checkout funnel, which abandoned carts are worth recovering, and what should the product and marketing teams fix to recover more revenue?

## Project Workflow

1. Loaded the raw session, order, and ad campaign data using Python.
2. Cleaned and prepared the data with Pandas and NumPy: fixed data types, handled missing values, removed duplicates, and created helper columns such as funnel stage, device type, and conversion flag.
3. Loaded the cleaned data into MySQL.
4. Ran exploratory data analysis (EDA) and SQL queries to measure drop-off at each funnel step, compare desktop and mobile, and compare ad performance.
5. Built a two-page Power BI dashboard: one page for the funnel and customer behavior, and one for ad and source performance.
6. Wrote the findings and recommendations, along with the limitations of the data.

## Key Numbers

- Total sessions: 472,871
- Total orders: 32,313
- Conversion rate: 6.83%
- Cart abandonment: 65.97%
- Estimated potential revenue lost: 3.76M (this is an estimate, not confirmed recoverable revenue)

## Key Findings

### Checkout funnel

Each percentage below is the share of people lost between two steps.

- Home to Product: 44.76%
- Product to Cart: 63.65% (the biggest drop)
- Cart to Shipping: 32.09%
- Shipping to Billing: 19.27%
- Billing to Order: 37.93%

### Device

- Desktop conversion rate is 8.50%.
- Mobile conversion rate is 3.09%.
- This large gap suggests the mobile experience needs attention, such as page speed, cart usability, and the payment flow.

### Customer segment

- Unique sessions make up about 81% (3.04M) of the estimated potential revenue lost.
- Repeat sessions make up about 19% (0.72M).

### Ad performance

- g_ad_1 (gsearch) brings the most traffic: 366,034 sessions and 24,940 orders at a 6.81% conversion rate.
- b_ad_2 (bsearch) has the highest conversion rate at 8.86%, but it has low volume, so it should be tested before scaling.
- social_ad_1 (socialbook) converts at only 1.08%, while social_ad_2 converts at 5.15%. This gap is worth investigating.

## Recommendations

1. Start with the Product to Cart step, since it loses the most people. Test clearer pricing, delivery and returns information, stronger calls to action, and faster page loading.
2. Audit the mobile checkout.
3. Run a cart-recovery test with a control group before trusting the 3.76M estimate.
4. Test b_ad_2 at a larger scale and review or fix social_ad_1, but only after checking ad spend.
5. Review shipping costs and payment errors, since they are common reasons for leaving late in checkout.

## Limitations

- Orders stop appearing after May 2015 in the dashboard. This should be checked to see whether the data simply ends there or whether it is a tracking issue.
- The data does not include ad spend, so ROAS and profit cannot be calculated. Conversion rate alone does not show whether an ad is worth the money.
- Metric definitions (session-based, event-based, or distinct users) were not independently verified.
- The potential revenue lost figure is an estimate and should be treated only as a signal for where to look first.

## Project Structure

```
cart-abandonment-analysis/
    data/          raw and cleaned datasets
    notebooks/     Python notebooks for ETL and EDA
    sql/           MySQL scripts and analysis queries
    powerbi/       Power BI (.pbix) dashboard
    reports/       final report
    README.md
```

Change the folder names to match your repository.

## How to Run

1. Clone the repository.
2. Install the required libraries:

```
pip install pandas numpy mysql-connector-python
```

3. Run the notebooks in the notebooks folder to clean the data and load it into MySQL.
4. Run the SQL scripts to repeat the analysis.
5. Open the .pbix file in Power BI Desktop and refresh the data source.

## About Me

I am Harshal Chouhan, a BCA graduate from Apex University, Jaipur, working towards an entry-level Data Analyst role. This is one of my portfolio projects.

GitHub: https://github.com/harshal-jam
