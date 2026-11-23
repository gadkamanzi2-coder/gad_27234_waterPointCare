
ALTER SESSION SET CONTAINER =

GRANT DBA TO gad_admin;

SELECT username, account_status
FROM dba_users
WHERE username = 'GAD_ADMIN';

SELECT granted_role
FROM dba_role_privs
WHERE grantee = 'GAD_ADMIN';
