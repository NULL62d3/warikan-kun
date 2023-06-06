
# Check python3 is installed.
if (Get-Command python -ea SilentlyContinue){
    Write-Output "Python is exist."
} else {
    Write-Output "Install Python3 by yourself!"
    Write-Output "Download from here: https://www.python.org/downloads/"
    Write-Output "After installing python3, run this script again."
    exit
}

# Check pyenv is exist or not.
$env='pyenv'

if (Get-Command $env -ea SilentlyContinue){
    Write-Output "$env has been installed."

} else {
    Write-Output "$env is not installed."
    Write-Output "Runninng env/setup_pyenv.ps1..."
    ./scripts/setup_pyenv.ps1
    Write-Output "Done."
}

# Check env/pyenv.cfg is exist
$cfg = "env/pyvenv.cfg"

while($true){
    if ((Test-Path $cfg) -eq $true){
        Write-Output "$cfg is exist."
        break
    } 

    Write-Output "$cfg is not exist."
    Write-Output "creating env..."

    if (Get-Command python -ea SilentlyContinue){
        python -m venv env
        if ($? -eq $true){break}
    }
    if (Get-Command py -ea SilentlyContinue){
        py -m venv env
        if ($? -eq $true){break}
    }
    Write-Output "Python command does not work!!"
    exit
}

Write-Output "env creation done."

# Activation
Write-Output "Activate environment..."
./env.ps1

# Check python version
Write-Output "Checking python version..."
$pyver=Get-Content '.python-version'

if (Get-Command python -ea SilentlyContinue){
    if ($(python --version) -eq "Python $pyver"){
        Write-Output "Python version is ok."
    } else {
        Write-Output "Python version is different."
        Write-Output "Installing python..."
        pyenv install $pyver
        pyenv local $pyver
        Write-Output "Done."
    }
} else {
    Write-Output "Python is not exist."
    Write-Output "Installing python..."
    pyenv install $pyver
    pyenv local $pyver
    Write-Output "Done."
}


Write-Output "Install requirements..."
python -m pip install --upgrade pip
pip install -r ./requirements.txt
Write-Output "Done."

Write-Output "Setup all done."