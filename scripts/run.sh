bold=$(tput bold)
normal=$(tput sgr0)
PURPLE='\033[0;35m'
NC='\033[0m'


echo "${PURPLE}${bold}\nBUILDING INFRASTRUCTURE...\n${normal}${NC}"
terraform init
terraform plan
terraform apply -auto-approve
python3 aws_amplify.py
echo "${PURPLE}${bold}\nINFRASTRUCTURE BUILT SUCCESSFULLY \n${normal}${NC}"
