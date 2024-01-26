-- This query is executed using Databricks Workflow (see resources/default_sql_sql_job.yml)
--
-- The streaming table below ingests all JSON files in /databricks-datasets/retail-org/sales_orders/
-- See also https://docs.databricks.com/sql/language-manual/sql-ref-syntax-ddl-create-streaming-table.html

CREATE OR REFRESH STREAMING TABLE
  SYMBOL(CONCAT({{catalog}}, '.', {{schema}}, '.', 'raw_orders'))
AS SELECT
  customer_name,
  DATE(TIMESTAMP(FROM_UNIXTIME(TRY_CAST(order_datetime AS BIGINT)))) AS order_date,
  order_number
FROM STREAM READ_FILES(
  "/databricks-datasets/retail-org/sales_orders/",
  format => "json",
  header => true
)
