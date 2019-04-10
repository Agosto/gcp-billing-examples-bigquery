#standardSQL

/* 
  monthly-folder-report.sql
  
  Reports on us last month's costs by top level folder.
  null means there is no folder or the folder is not in 
  the gcp_folder table
  
  To create the gcp_folder table, see setup-gcp_folder-table.sql
  To populate the gcp_folder table, see list-top-folders-in-org

*/

SELECT 
   Month
  ,ORG as Org
  ,FOLDER as Folder
  ,SUM(cost) as Cost
  ,SUM(credit) as Credit
  ,SUM(total) as Total
FROM
(
  SELECT
     invoice.month
     
     /* if we split ancestry_numbers by a / character, the orgnode is the first index.  Second index is the folder (if there is one) */
    ,SPLIT(project.ancestry_numbers,'/')[OFFSET(1)] ORG
    ,(SELECT name FROM `--mydataset--.gcp_folder` WHERE ancestry_number = SPLIT(project.ancestry_numbers,'/')[OFFSET(2)]) AS FOLDER
    
    ,SUM(cost) as cost
    ,IFNULL(SUM((SELECT SUM(amount) FROM UNNEST(credits))),0) as credit
    ,SUM(cost) + IFNULL(SUM((SELECT SUM(amount) FROM UNNEST(credits))),0) as total

  	FROM `--mydataset--.gcp_billing_export_v1_*` B
    
    /* the following where clause will calculate last month */
    WHERE invoice.month = FORMAT_DATE("%Y%m",DATE_ADD(CURRENT_DATE(), INTERVAL -1 MONTH))
    
    GROUP BY project.ancestry_numbers, invoice.month, project.id
)
GROUP BY Month,ORG,FOLDER