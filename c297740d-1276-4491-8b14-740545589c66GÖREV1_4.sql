WITH combined_data AS (

    -- Google
    SELECT 
        ad_date,
        campaign_name,
        reach
    FROM public.google_ads_basic_daily

    UNION ALL

    -- Facebook (JOIN ile isim alıyoruz)
    SELECT 
        f.ad_date,
        fc.campaign_name,
        f.reach
    FROM public.facebook_ads_basic_daily f
    LEFT JOIN public.facebook_campaign fc
        ON f.campaign_id = fc.campaign_id
),

monthly_data AS (
    SELECT 
        campaign_name,
        DATE_TRUNC('month', ad_date) AS month,
        SUM(reach) AS total_reach
    FROM combined_data
    GROUP BY campaign_name, month
),

growth_calc AS (
    SELECT 
        campaign_name,
        month,
        total_reach,
        LAG(total_reach) OVER (
            PARTITION BY campaign_name 
            ORDER BY month
        ) AS prev_reach,
        total_reach - LAG(total_reach) OVER (
            PARTITION BY campaign_name 
            ORDER BY month
        ) AS growth
    FROM monthly_data
)

SELECT *
FROM growth_calc
WHERE growth IS NOT NULL
ORDER BY growth DESC
LIMIT 1;