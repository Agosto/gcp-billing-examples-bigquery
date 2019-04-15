# gcp-billing-examples-bigquery

Examples originally published to support the NEXT '19 session on Aligning Cloud Costs with Service Delivery.


## Setting up
Some of the example queries are based on folder level reporting.  Folder level data in the billing table will reference the id, not the name.  The example queries here require a helper table named gcp_folder that will resolve the folder id to name.

All examples require you to replace '--mydataset--' with the name of your dataset.

1. [setup-gcp_folder-table.sql](./setup-gcp_folder-table.sql) - Create the table.  Includes inserts of a few examples.
2. [list-top-folders-in-org.sh](./list-top-folders-in-org.sh) - Uses gcloud to pull all the top level folder names and ids from a given organization.  Also, see .ps1 file for a Powershell version of this script.
```
Example: ./list-top-folders-in-org.sh -g demo.agosto.com
```

## Important Links
Here are some helpful related links.

* [Export billing data to BigQuery](https://cloud.google.com/billing/docs/how-to/export-data-bigquery) - Setting up the export
* [Data Studio billing report](https://cloud.google.com/billing/docs/how-to/visualize-data) - A starting point in building your own billing reports
* [GKE Cluster Usage Metering](https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-usage-metering) - Combine GKE usage data with cluster costs.
* [GCE Usage Export](https://cloud.google.com/compute/docs/usage-export) - Exporting usage data on individual resources in compute engine
