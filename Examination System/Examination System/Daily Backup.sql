create or alter procedure proc_dailybackup
as
begin
    declare @backup_path nvarchar(500);
    declare @file_name nvarchar(500);
    declare @db_name nvarchar(100) = 'Examination_System'; 
    declare @date_suffix nvarchar(20);
    declare @full_file_path nvarchar(500);
    declare @file_exists int;
    declare @backup_name nvarchar(200);

   
    set @date_suffix = format(getdate(), 'yyyyMMdd_HHmmss');

   
    set @backup_path = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\';  -- Recommended: Use a simpler backup path

    
    set @full_file_path = @backup_path + @db_name + '_backup_' + @date_suffix + '.bak';

    
    set @backup_name = @db_name + '_FullBackup_' + @date_suffix;

    begin try
        
        backup database @db_name 
        to disk = @full_file_path
        with format, init, name = @backup_name, stats = 10;

       
        exec xp_fileexist @full_file_path, @file_exists output;

        if @file_exists = 1
        begin
            print ' Backup completed successfully: ' + @full_file_path;
        end
        else
        begin
            print ' Warning: Backup process ran but file was not found!';
        end
    end try
    begin catch
        print ' Error in database backup. Error Number: ' 
              + cast(error_number() as varchar) 
              + ', Message: ' + error_message();
    end catch
end;
exec  proc_dailybackup