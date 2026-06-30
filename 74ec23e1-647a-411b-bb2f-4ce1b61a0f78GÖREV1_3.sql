WITH combined_data AS (

 
    SELECT 
        ad_date,
        campaign_name,
        value
    FROM public.google_ads_basic_daily

    UNION ALL

    
    SELECT 
        f.ad_date,
        COALESCE(fc.campaign_name, 'unknown_campaign') AS campaign_name,
        f.value
    FROM public.facebook_ads_basic_daily f
    LEFT JOIN public.facebook_campaign fc
        ON f.campaign_id = fc.campaign_id
)

SELECT 
    DATE_TRUNC('week', ad_date) AS week,
    campaign_name,
    SUM(value) AS total_value
FROM combined_data
GROUP BY week, campaign_name
HAVING SUM(value) IS NOT NULL
ORDER BY total_value DESC
LIMIT 1;