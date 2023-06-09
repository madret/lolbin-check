# INPUT ACTION: Define path to CSV database file
$csvPath = "C:\path\to\database.csv"

# INPUT ACTION: Define path to text file containing suspicious executables
$inputPath = "C:\path\to\executables.txt"

# Read CSV into array of strings
$csvLines = Get-Content $csvPath
$csvData = @{}

foreach ($line in $csvLines) {
    $values = $line.Split(",")
    
    # Add the values to the hashtable using the first column as the key to lowercase
    $csvData[$values[0].ToLower()] = $values[1]
}

# Read input file
$lines = Get-Content $inputPath

# ANSI color codes 
$green = "`e[92m"
$blue = "`e[94m"
$reset = "`e[0m"

foreach ($line in $lines) {
    # Split 
    $words = $line.Split(" ")
    
    foreach ($word in $words) {
        # Convert the word to lowercase
        $lowerWord = $word.ToLower()
        
        # Check if the word ends with ".exe"
        if ($lowerWord.EndsWith(".exe")) {
            # Check if the process is in the hashtable converted to lowercase
            if ($csvData.ContainsKey($lowerWord)) {
                $extraInfo = "$blue https://lolbas-project.github.io/lolbas/Binaries/" + ($word -replace '\.exe$','') + "/$reset"
                
                Write-Output "$($green)$word$($reset) is a LOLBIN. Additional information, double click and browse: $extraInfo"
            }
        }
    }
}
