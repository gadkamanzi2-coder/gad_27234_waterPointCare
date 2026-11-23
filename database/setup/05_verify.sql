
SELECT name, open_mode
FROM v$pdbs
WHERE name = 'B_27234_GAD_WATERPOINTCARE_DB';


ALTER SESSION SET CONTAINER = B_27234_GAD_WATERPOINTCARE_DB;

SELECT username, account_status,
       default_tablespace, temporary_tablespace
FROM dba_users
WHERE username = 'GAD_ADMIN';

SELECT tablespace_name,
       ROUND(bytes / 1024 / 1024, 2) AS size_mb,
       autoextensible,
       ROUND(increment_by * (
           SELECT value FROM v$parameter
           WHERE name = 'db_block_size'
       ) / 1024 / 1024, 2) AS next_size_mb,
       ROUND(maxbytes / 1024 / 1024, 2) AS max_size_mb
FROM dba_data_files
WHERE tablespace_name IN (
    'WATERPOINTCARE_DATA',
    'WATERPOINTCARE_IDX'
)
ORDER BY tablespace_name;

SELECT tablespace_name,
       ROUND(bytes / 1024 / 1024, 2) AS size_mb,
       autoextensible,
       ROUND(increment_by * (
           SELECT value FROM v$parameter
           WHERE name = 'db_block_size'
       ) / 1024 / 1024, 2) AS next_size_mb,
       ROUND(maxbytes / 1024 / 1024, 2) AS max_size_mb
FROM dba_temp_files
WHERE tablespace_name = 'WATERPOINTCARE_TEMP';


SELECT username, tablespace_name, max_bytes
FROM dba_ts_quotas
WHERE username = 'GAD_ADMIN'
ORDER BY tablespace_name;

SELECT log_mode
FROM v$database;
