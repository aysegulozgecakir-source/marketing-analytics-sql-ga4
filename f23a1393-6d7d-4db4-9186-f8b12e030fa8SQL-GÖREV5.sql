WITH adset_dates AS (

    SELECT DISTINCT
        a.adset_name,
        f.ad_date
    FROM facebook_ads_basic_daily f
    LEFT JOIN facebook_adset a
        ON f.adset_id = a.adset_id

    UNION

    SELECT DISTINCT
        adset_name,
        ad_date
    FROM google_ads_basic_daily
    WHERE adset_name IS NOT NULL

),

numbered AS (

    SELECT
        adset_name,
        ad_date,
        ad_date - ROW_NUMBER() OVER (
            PARTITION BY adset_name
            ORDER BY ad_date
        )::int AS grp
    FROM adset_dates

),

streaks AS (

    SELECT
        adset_name,
        MIN(ad_date) AS streak_start,
        MAX(ad_date) AS streak_end,
        COUNT(*) AS streak_length
    FROM numbered
    GROUP BY
        adset_name,
        grp

)

SELECT
    adset_name,
    streak_start,
    streak_end,
    streak_length
FROM streaks
ORDER BY streak_length DESC
LIMIT 1;