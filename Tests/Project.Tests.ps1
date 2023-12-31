$moduleManifest = Get-Content $ENV:BHPSModuleManifest | Out-String | Invoke-Expression


Describe "General project validation: $ENV:BHProjectName" {

    $scripts = Get-ChildItem $ENV:BHProjectPath -Include *.ps1, *.psm1, *.psd1 -Recurse

    # TestCases are splatted to the script so we need hashtables
    $testCase = $scripts | Foreach-Object { @{file = $_ } }         
    It "Script <file> should be valid powershell" -TestCases $testCase {
        param($file)

        $file.fullname | Should -Exist

        $contents = Get-Content -Path $file.fullname -ErrorAction Stop
        $errors = $null
        $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
        $errors.Count | Should -Be 0
    }

    It "Module '$ENV:BHProjectName' can import cleanly as long as RequiredModules are present" {
        Write-Host "$($moduleManifest.RequiredModules)"
        { Import-Module ($moduleManifest.RequiredModules) -Force -DisableNameChecking } | Should -Not -Throw
        { Import-Module (Join-Path $ENV:BHPSModulePath "$ENV:BHProjectName.psm1") -force } | Should -Not -Throw
    }
}