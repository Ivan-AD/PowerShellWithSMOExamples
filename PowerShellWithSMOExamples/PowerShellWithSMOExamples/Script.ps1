function ID-Create-Table{
                <# 
                .SYNOPSYS
                Create table in SQL Database with one column (identity ID column, bigint datatype).
                .SYNTAX
                ID-Create-Table -tableName <new table name> -schemaName <schema name> -dbName <database name> -sqlServerName <SQL Server name>
                Emample: ID-Create-Database -tableName "ISO27001" -schemaName "dbo" -dbName "RiskManagementDatabase" -sqlServerName "SQLServer\ITDepartmentInstance"
                .Parameter $tableName
                New Table Name. Example: "ISO27001"
                .Parameter $schemaName
                Existing schema in the selected Database. Examlpe: "dbo" (The dbo schema is the default schema for a newly created database.)
                .Parameter dbName 
                New Database Name. Example: "RiskManagementDatabase"
                .Parameter sqlServerName
                Existing SQL Server Name. Example: "SQLServer\ITDepartmentInstance"
                #>
                param
                (
                                [Parameter(Mandatory=$true)][string] $tableName,
                                [Parameter(Mandatory=$true)][string] $schemaName,
                                [Parameter(Mandatory=$true)][string] $dbName,
                                [Parameter(Mandatory=$true)][string] $sqlServerName
                )
                #Create active instance of a $sqlServerName server
                $srv = New-Object('Microsoft.SqlServer.Management.Smo.Server') $sqlServerName

                #Create active instance of a $dbName database 
                $db = $srv.Databases[$dbName]
                
                #Create the new table object from standart SQL table template with 
                #name - $tableName in the schema - $schemaName.
                $tb = New-Object('Microsoft.SqlServer.Management.Smo.Table') ($db, $tableName, $schemaName)

                #Create the identity ID column in the table
                $col = New-Object('Microsoft.SqlServer.Management.Smo.Column') ($tb, 'ID', [Microsoft.SqlServer.Management.Smo.Datatype]::Bigint)
                $col.Identity = $true
                $col.IdentitySeed = 1
                $col.IdentityIncrement = 1
                $tb.Columns.Add($col)


                #Create the table
                $tb.Create()
}


function ID-Add-Column-In-Table{
       <# 
       .SYNOPSYS 
       Add column in table. 
       .SYNTAX 
       ID-Add-Column-In-Table -columnName <new column Name> -datatype <data type> -tableName <existing table name> -dbName <existing database name> -sqlServerName <SQL Server Name> 
       Emample: 
              $datatype = [Microsoft.SqlServer.Management.Smo.Datatype]::Char(155) 
              ID-Create-Database -columnName "ClouseID" -datatype $datatype -tableName "ISO27001" -dbName "RiskManagementDatabase" -sqlServerName "SQLServer\ITDepartmentInstance" 
       .Parameter columnName. Example: "ClouseID" 
       .Parameter datatype. Example: [Microsoft.SqlServer.Management.Smo.Datatype]::NVarChar(10) 
       .Parameter tableName 
       New Table Name. Example: "ISO27001" 
       .Parameter dbName 
       New Database Name. Example: "RiskManagementDatabase" 
       .Parameter sqlServerName 
       Existing SQL Server Name. Example: "SQLServer\ITDepartmentInstance" 
       #> 
       param
       ( 
              [Parameter(Mandatory=$true)][string] $columnName,
              [Parameter(Mandatory=$true)][System.Object] $datatype,
              [Parameter(Mandatory=$true)][string] $tableName,
              [Parameter(Mandatory=$true)][string] $dbName,
              [Parameter(Mandatory=$true)][string] $sqlServerName
       ) 
       #Create active instance of a $sqlServerName server
       $srv = New-Object('Microsoft.SqlServer.Management.Smo.Server') $sqlServerName

       #Create active instance of a $dbName database 
       $db = $srv.Databases[$dbName]
       
       #Create active instance of a $tableName table
       $tb = $db.Tables[$tableName]

       #Create column in the table
       $col = New-Object('Microsoft.SqlServer.Management.Smo.Column') ($tb, $columnName, $datatype)
       $col.Nullable = $false;
       $tb.Columns.Add($col)

       #Update the table
       $tb.Alter()
}​
 

function ID-Create-PrimaryKey {
       <# 
       .SYNOPSYS
       Create Primary Key.
       .SYNTAX
       ID-Add-PrimaryKey -primaryKeyName $primaryKeyName -columnName <existing column Name> -tableName <existing table name> -dbName <existing database name> -sqlServerName <SQL Server Name>
       Emample: ID-Create-PrimaryKey -primaryKeyName "PK_ISO27001_ClouseID" -columnName "ClouseID" -tableName "ISO27001" -dbName "RiskManagementDatabase" -sqlServerName "SQLServer\ITDepartmentInstance"
       .Parameter columnName. 
       Example: "ClouseID"
       .Parameter tableName 
       Existing Table in Database. Example: "ISO27001"
       .Parameter dbName 
       Existing Database in SQL instance. Example: "RiskManagementDatabase"
       .Parameter sqlServerName
       Existing SQL Server Name. Example: "SQLServer\ITDepartmentInstance"
       #>
       [Parameter(Mandatory=$true)][string] $primaryKeyName
       [Parameter(Mandatory=$true)][string] $columnName,
       [Parameter(Mandatory=$true)][string] $tableName,
       [Parameter(Mandatory=$true)][string] $dbName,
       [Parameter(Mandatory=$true)][string] $sqlServerName

       #Create active instance of a $sqlServerName server
       $srv = New-Object('Microsoft.SqlServer.Management.Smo.Server') $sqlServerName

       #Create active instance of a $dbName database 
       $db = $srv.Databases[$dbName]
       
       #Create active instance of a $tableName table
       $tb = $db.Tables[$tableName]

       #Create the Primary Key
       $idxPK = new-object ('Microsoft.SqlServer.Management.Smo.Index') ($tb, $primaryKeyName)
       $idxPK.IndexKeyType = "D​riPrimaryKey"
       $idxPK.IsClustered = $true
       $idxPKcol = new-object ('Microsoft.SqlServer.Management.Smo.IndexedColumn') ($idxPK, $columnName)
       $idxPK.IndexedColumns.Add($idxPKcol)
       $tb.Indexes.Add($idxPK)

       # Update/Modify/Alter the table
       $tb.Alter()
}​


function ID-Create-ForeignKey {
      <# 
      .SYNOPSYS
      Create Primary Key.
      .SYNTAX
      ID-Create​-ForeignKey -foreignKeyName $foreignKeyName -columnName $columnName -tableName $tableName -referencedColumn $referencedColumn -referencedTable $referencedTable -dbName $dbName -sqlServerName $sqlServerName
      .Parameter -foreignKeyName
      Foreign key name. Example: FK_ClouseID_ISO27001
      .Parameter -columnName
      Existing column from table columnName. Example: "ClauseID" - column from table ISO27001Controls
      .Parameter -tableName
      Existing Table in Database. Example: "ISO27001Controls"
      .Parameter - referencedColumn
      Related column in table. Example "ClauseID"
      .Parameter -referencedTable
      Related table in Database. Example "ISO27001"
      .Parameter dbName 
      New Database Name. Example: "RiskManagementDatabase"
      .Parameter sqlServerName
      Existing SQL Server Name. Example: "SQLServer\ITDepartmentInstance"
      #>
      [Parameter(Mandatory=$true)][string] $foreignKeyName
      [Parameter(Mandatory=$true)][string] $columnName,
      [Parameter(Mandatory=$true)][string] $tableName,
      [Parameter(Mandatory=$true)][string] $referencedColumn,
      [Parameter(Mandatory=$true)][string] $referencedTable,
      [Parameter(Mandatory=$true)][string] $dbName,
      [Parameter(Mandatory=$true)][string] $sqlServerName

      #Create active instance of a $sqlServerName server
      $srv = New-Object('Microsoft.SqlServer.Management.Smo.Server') $sqlServerName

      #Create active instance of a $dbName database 
      $db = $srv.Databases[$dbName]
      
      #Create active instance of a $tableName table
      $tb = $db.Tables[$tableName]

      #Create the Foreign Key
      $foreignKey = new-object ('Microsoft.SqlServer.Management.Smo.ForeignKey') ($tb, $foreignKeyName)
      $foreignKeyColumn = new-object ('Microsoft.SqlServer.Management.Smo.ForeignKeyColumn') ($foreignKey, $columnName, $referencedColumn)
      $foreignKey.Columns.Add($foreignKeyColumn)
      $foreignKey.ReferencedTable = $referencedTable
      $foreignKey.ReferencedTableSchema = "dbo"

      $foreignKey.Create()

      # Update/Modify/Alter the table
      $tb.Alter()
}

