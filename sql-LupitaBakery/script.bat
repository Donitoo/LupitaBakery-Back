@echo off
for /F "tokens=1,3" %%A in ('reg query HKLM\SOFTWARE\Oracle /s /v ORACLE_HOME') DO IF "%%A" == "ORACLE_HOME" (SETX ORACLE_HOME %%B /m)
for /F "tokens=1,3" %%A in ('reg query HKLM\SOFTWARE\Oracle /s /v ORACLE_HOME') DO IF "%%A" == "ORACLE_HOME" (SET ORACLE_HOME=%%B)
echo. >> %ORACLE_HOME%\network\admin\tnsnames.ora
echo lupitabakeryapp.tomukomatsu.com = >> %ORACLE_HOME%\network\admin\tnsnames.ora
echo  (DESCRIPTION = >> %ORACLE_HOME%\network\admin\tnsnames.ora
echo    (ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521)) >> %ORACLE_HOME%\network\admin\tnsnames.ora
echo    (CONNECT_DATA = >> %ORACLE_HOME%\network\admin\tnsnames.ora
echo      (SERVER = DEDICATED) >> %ORACLE_HOME%\network\admin\tnsnames.ora
echo      (SERVICE_NAME = lupitabakeryapp.tomukomatsu.com) >> %ORACLE_HOME%\network\admin\tnsnames.ora
echo    ) >> %ORACLE_HOME%\network\admin\tnsnames.ora
echo  ) >> %ORACLE_HOME%\network\admin\tnsnames.ora
exit