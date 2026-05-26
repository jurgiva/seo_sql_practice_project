-- VIEW 1: daily_page_performance
-- Goal: combine page-level SEO + analytics data per day

CREATE VIEW daily_page_performance AS
    WITH page_date AS (
    SELECT page_id, date
    FROM gsc_daily
    UNION
    SELECT page_id, date 
    FROM ga4_daily
    )
    SELECT  url, pd.date, clicks, impressions, position, sessions, conversions
    FROM  page_date pd
    JOIN pages p
    ON p.page_id = pd.page_id 
    LEFT JOIN gsc_daily gsc 
    ON p.page_id = gsc.page_id 
    AND gsc.date = pd.date
    LEFT JOIN ga4_daily ga4 
    ON p.page_id = ga4.page_id
    AND ga4.date = pd.date
    ORDER BY p.client_id, p.url, pd.date;

-- VIEW 2: weekly_client_summary
-- Goal: aggregate SEO + analytics metrics per client per week

CREATE VIEW weekly_client_summary AS
    WITH gsc_weekly AS (
    SELECT
        page_id,
        DATE_TRUNC('week', date) AS week,
        SUM(clicks) AS clicks,
        SUM(impressions) AS impressions
    FROM gsc_daily
    GROUP BY 
        page_id,
        DATE_TRUNC('week', date)
    ),
    ga4_weekly AS (
    SELECT
        page_id,
        DATE_TRUNC('week', date) AS week,
        SUM(sessions) AS sessions,
        SUM(conversions) AS conversions
    FROM ga4_daily
    GROUP BY 
        page_id,
        DATE_TRUNC('week', date)
    ),
    page_weeks AS (
    SELECT page_id, week
    FROM gsc_weekly
    UNION
    SELECT page_id, week
    FROM ga4_weekly)
    SELECT 
    c.client_name,
    pw.week,
    SUM(gsc.clicks) AS total_clicks,
    SUM(gsc.impressions) AS total_impressions,
    SUM(ga4.sessions) AS total_sessions,
    SUM(ga4.conversions) AS total_conversions
    FROM clients c
    JOIN pages p
    ON c.client_id = p.client_id
    JOIN page_weeks pw
    ON p.page_id = pw.page_id
    LEFT JOIN gsc_weekly gsc
    ON gsc.page_id = pw.page_id
    AND gsc.week = pw.week
    LEFT JOIN ga4_weekly ga4
    ON ga4.page_id = pw.page_id
    AND ga4.week = pw.week
    GROUP BY 
    c.client_name,
    pw.week
    ORDER BY 
    c.client_name,
    pw.week;

-- VIEW 3: seo_opportunity_report
-- Goal: identify SEO opportunities using performance data + crawl issues

CREATE VIEW seo_opportunity_report AS
    WITH gsc_totals AS (
    SELECT
        page_id,
        SUM(clicks) AS clicks,
        SUM(impressions) AS impressions
    FROM gsc_daily
    GROUP BY page_id
    ),
    ga4_totals AS (
    SELECT
        page_id,
        SUM(sessions) AS sessions,
        SUM(conversions) AS conversions
    FROM ga4_daily
    GROUP BY page_id
    ),
    joined_data AS (
    SELECT
        c.client_name,
        p.url,
        gsc.clicks,
        gsc.impressions,
        ga4.sessions,
        ga4.conversions,
        ci.issue_type
    FROM clients c
    JOIN pages p
        ON c.client_id = p.client_id
    LEFT JOIN gsc_totals gsc
        ON p.page_id = gsc.page_id
    LEFT JOIN ga4_totals ga4
        ON p.page_id = ga4.page_id
    LEFT JOIN crawl_issues ci
        ON p.page_id = ci.page_id
    ),
    with_ctr_and_cr AS (
    SELECT
        client_name,
        url,
        clicks,
        impressions,
        clicks::decimal / NULLIF(impressions, 0) AS ctr,
        sessions,
        conversions,
        conversions::decimal / NULLIF(sessions,0) AS conversion_ratio,
        issue_type
    FROM joined_data
    )
    SELECT
    client_name,
    url,
    clicks,
    impressions,
    ctr,
    sessions,
    conversions,
    conversion_ratio,
    issue_type,
    CASE
        WHEN impressions >= 1000 AND ctr < 0.05 -- who knows :) 
        THEN 'High impressions but low CTR'
        WHEN sessions >= 200 AND issue_type IS NOT NULL 
        THEN 'Popular page has a crawl issue'
        WHEN issue_type IS NOT NULL
        THEN 'Page has a crawl issue'
        ELSE 'No clear opportunity'
    END AS opportunity_type
    FROM with_ctr_and_cr;
