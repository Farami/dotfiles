function db --wraps='dotnet build --property WarningLevel=0' --description 'alias db dotnet build --property WarningLevel=0'
  dotnet build --property WarningLevel=0 $argv
        
end
