#standardSQL


/* 
  view-for-data-studio.sql
  
  View to add top level folder data to the stanar billing table.
  
  Reports on us last month's costs by top level folder.
  null means there is no folder or the folder is not in 
  the gcp_folder table
  
  To create the gcp_folder table, see setup-gcp_folder-table.sql
  To populate the gcp_folder table, see list-top-folders-in-org

*/

SELECT 
   EXTRACT(DATE FROM _PARTITIONTIME) AS pdate
  ,billing_account_id
  ,service
  ,sku
  ,usage_start_time
  ,usage_end_time
  ,project
  ,labels
  ,system_labels
  ,location
  ,export_time
  ,cost
  ,IFNULL((SELECT SUM(amount) FROM UNNEST(B.credits)),0) AS credit_amount
  ,cost + IFNULL((SELECT SUM(amount) FROM UNNEST(B.credits)),0) AS cost_plus_credit
  ,currency
  ,currency_conversion_rate
  ,usage
  ,credits
  ,invoice
  ,cost_type
  ,(SELECT name FROM `--myproject--.--mydataset--.gcp_folder` WHERE ancestry_number = SPLIT(project.ancestry_numbers,'/')[OFFSET(2)]) AS FOLDER

FROM `--myproject--.--mydataset--.gcp_billing_export_v1_012E73_A890DB_8A2D1F` B

