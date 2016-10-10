#!/bin/bash
# Copyright (C) 2016 Paget96 @ XDA-Developers
# Thanks to brut.all and ibotpeaches for APKTool
# Thanks to aureljared @ XDA-Developers for zipalign/sign script for Linux.
#=======================================================================#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
#=======================================================================#

if [ ! -d ./Input ]; then
    mkdir ./Input
fi
if [ ! -d ./Output ]; then
    mkdir ./Output
fi


function decompile() {

    echo -n "Filename without .apk extension: "
    read -r appname
        if [ -f ./Input/$appname.apk ]; then
            sh ./binary/apktool/apktool d ./Input/$appname.apk
            echo "APK file decompiled successfully"
        else
            echo -e "$appname.apk does not exist. Check file name and try again !"
        fi
    echo ""    
    echo ""    

}

function compile() {

    echo -n "Filename without .apk extension: "
    read -r appfolder
    if [ -d ./$appfolder ]; then
        cd ./$appfolder
        java -jar ../binary/apktool/apktool.jar b -d -o ../Output/$appfolder-modified.apk
        cd ..
        echo "APK file compiled successfully"
    else
        echo -e "$appfolder does not exist. Check source folder !"
    fi
    echo ""    
    echo ""    

}    

function sign() {

    cd ./Output/
    # Phase 1
    echo -e "Enter the name of the apk you want to sign."
    echo -e "Example: SystemUI"
    echo -e ""
    echo -e "NOTE:"
    echo -e "What you enter here will also be the filename of your final APK."
    echo -e "APK must be in the same folder as this script."
    echo -n "Filename without .apk extension: "
    read appname

    # Check existence
    if [ -f $appname-modified.apk ]
    then
        echo -e ""
        echo -e "APK exists."
    else
        echo -e "$appname-modified.apk does not exist inside /Output folder. Exiting..."
    fi

    # Phase 2
    echo -e "Signing APK..."
    java -jar ../binary/sign/signapk.jar ../binary/sign/testkey.x509.pem ../binary/sign/testkey.pk8 $appname-modified.apk $appname-signed.apk
    echo "APK file sigend successfully"

    echo ""    
    echo ""    
}  


PS3='Please enter your choice: '
options=("Decompile" "Compile" "Sign .apk package" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Decompile")
           decompile ;;
        "Compile")
            compile ;;
        "Sign .apk package")
            sign ;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done