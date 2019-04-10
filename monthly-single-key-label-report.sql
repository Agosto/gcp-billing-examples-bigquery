#standardSQL

/* 
  monthly-single-key-label-report.sql
  
  Reports on us last month's costs by for a single key 
  organized by value.  This example shows a key "owner".

  
*/

SELECT
   invoice.month
  ,labels.value as owner
  ,SUM(cost) + IFNULL(SUM((SELECT SUM(amount) FROM UNNEST(credits))),0) as total

/* Replace with your dataset name */
FROM `--mydataset--.gcp_billing_export_v1_*`
LEFT JOIN UNNEST(labels) as labels ON labels.key = "owner"
 
WHERE invoice.month = FORMAT_DATE("%Y%m",DATE_ADD(CURRENT_DATE(), INTERVAL -1 MONTH))
  AND _PARTITIONTIME > TIMESTAMP(DATE_ADD(CURRENT_DATE(), INTERVAL -35 DAY)) /* limit the data we are querying */
    
GROUP BY owner, invoice.month  
LIMIT 100