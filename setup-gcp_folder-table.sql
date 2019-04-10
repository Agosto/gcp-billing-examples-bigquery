#standardSQL

#
# setup-gcp_folder-table.sql
# Updated: 03-31-2019
# Author: Jeremy Pries, Agosto, jeremy.pries@agosto.com

# Purpose: 
#   Create and populate a table called gcp_folder that will be used
#   to resolve a folder id to name.


CREATE TABLE `myproject.mydataset.gcp_folder` (
   `ancestry_number` STRING
  ,`name` STRING
)

INSERT INTO `myproject.mydataset.gcp_folder`
(ancestry_number, name) VALUES
 ('374969883999','folder1')
,('444126082999','folder2')
,('609965036999','folder3')
,('686156563999','folder4')
,('931656520999','folder5')

