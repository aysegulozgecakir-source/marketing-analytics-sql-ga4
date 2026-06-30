WITH ads_data AS (

    SELECT
        f.ad_date,
        f.spend,
        f.value
    FROM facebook_ads_basic_daily f
    LEFT JOIN facebook_campaign c
        ON f.campaign_id = c.campaign_id
    LEFT JOIN facebook_adset a
        ON f.adset_id = a.adset_id

    UNION ALL

    SELECT
        ad_date,
        spend,
        value
    FROM google_ads_basic_daily

)

SELECT
    ad_date,
    1.00 * COALESCE(SUM(value),0) / SUM(spend) AS romi
FROM ads_data
WHERE spend > 0
GROUP BY ad_date
ORDER BY romi DESC
LIMIT 5;