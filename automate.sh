#!/bin/bash

IP=$1

#Colour Combinations

BGreen='\033[1;32m' 
BCyan='\033[1;36m'
BPurple='\033[1;35m' 
BYellow='\033[1;33m'
BRed='\033[1;31m'
BWhite='\033[1;37m'         

NC='\033[0m' 


#Banner

echo -e "${BYellow}"
figlet -f big "ASSet FINEdr" -k
echo -e "${NC}" 
echo -e "${BGreen}"              
echo "                            Author : Aman Tiwari"             
echo "                       Syntax : ./automate.sh {Domain}"
echo -e "${NC}"
echo -e "\n\n\n\n"

if [ "$#" -eq 1 ]; then
	echo "[+] Code Starting [+]"
	echo -e "\n\n"


	#Directory Checking 
	if [ ! -d $IP ]; then
		mkdir $IP
	fi


	if [ ! -d $IP/Whois ]; then
		mkdir $IP/Whois
	fi


	if [ ! -d $IP/Subfinder ]; then
		mkdir $IP/Subfinder 
	fi

	if [ ! -d $IP/Assetfinder ]; then
		mkdir $IP/Assetfinder
	fi

	if [ ! -d $IP/Httprobe ]; then
		mkdir $IP/Httprobe
	fi

	if [ ! -d $IP/Gowitness ]; then
		mkdir $IP/Gowitness
	fi

	echo -e "${BCyan}   !!!!....... Performing WhoIs .......!!!!! ${NC}\n"

	whois $IP > $IP/Whois/Info.txt 

	echo -e "${BCyan}   !!!!....... Whois Done .......!!!!! ${NC}\n"
	echo -e "${BYellow} !!!!....... Saved in $IP/Whois/Info.txt .......!!!!! ${NC}\n"
	echo -e "\n\n"
	echo -e "${BRed}    !!!!....... Finding Subdomains .......!!!!! ${NC}\n"

	subfinder -d $IP -o $IP/Subfinder/Subs.txt

	echo -e "${BRed}    !!!!....... Subdomains Found .......!!!!! ${NC}\n"
	echo -e "${BYellow} !!!!....... Saved in $IP/Subfinder/Subs.txt .......!!!!! ${NC}\n"
	echo -e "\n\n"

	echo -e "${BPurple} !!!!....... Finding Assets ( Credit @Tomnomnom ) .......!!!!! ${NC}\n"

	assetfinder -subs-only $IP | sort -u > $IP/Assetfinder/Findings.txt
	cat ./$IP/Assetfinder/Findings.txt | sed s/"www."// | sort -u > $IP/Assetfinder/R_Findings.txt

	echo -e "${BPurple} !!!!....... Assets Found ( Only Related to Subdomains ) .......!!!!! ${NC}\n"
	echo -e "${BYellow} !!!!....... Saved in $IP/Assetfinder/Findings.txt .......!!!!! ${NC}\n"
	echo -e "\n\n"
	echo -e "${BWhite}  !!!!....... Checking if Assets are Live ( Credit @Tomnomnom ) .......!!!!! ${NC}\n"

	cat $IP/Assetfinder/R_Findings.txt | httprobe -s -p https:443 >  $IP/Httprobe/Live.txt
	cut -d : -f 2 $IP/Httprobe/Live.txt | cut --complement -c 1,2 > $IP/Httprobe/R_Live.txt

	echo -e "${BWhite}  !!!!....... Live Assets Found and Refined .......!!!!! ${NC}\n"
	echo -e "${BYellow} !!!!....... Saved in $IP/Httprobe/Live.txt .......!!!!! ${NC}\n"
	echo -e "${BYellow} !!!!....... Refined Live Domains in $IP/Httprobe/R_Live.txt .......!!!!! ${NC}\n"
	echo -e "\n\n"
	echo -e "${BGreen}  !!!!....... Taking Pictures of Live Websites .......!!!!! ${NC}\n"

	gowitness file -f ./$IP/Httprobe/R_Live.txt -F -P ./$IP/Gowitness/pics --no-http

	echo -e "${BGreen}  !!!!....... Pictures Taken .......!!!!! ${NC}\n"
	echo -e "${BYellow} !!!!....... Saved in $IP/Gowitness/pics .......!!!!! ${NC}\n"
	echo -e "\n\n"

	echo "[+] Code Ending [+]"
fi
