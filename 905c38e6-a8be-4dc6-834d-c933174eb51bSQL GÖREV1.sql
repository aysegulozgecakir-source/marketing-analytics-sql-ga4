WITH ads_data AS (

    SELECT
        f.ad_date,
        'facebook' AS media_source,
        f.spend
    FROM facebook_ads_basic_daily f
    LEFT JOIN facebook_campaign c
        ON f.campaign_id = c.campaign_id
    LEFT JOIN facebook_adset a
        ON f.adset_id = a.adset_id

    UNION ALL

    SELECT
        ad_date,
        'google' AS media_source,
        spend
    FROM google_ads_basic_daily

)

SELECT
    ad_date,
    media_source,
    ROUND(AVG(spend), 2) AS avg_spend,
    ROUND(MAX(spend), 2) AS max_spend,
    ROUND(MIN(spend), 2) AS min_spend
FROM ads_data
GROUP BY
    ad_date,
    media_source
ORDER BY
    ad_date,
    media_source;