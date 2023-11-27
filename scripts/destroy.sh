bold=$(tput bold)
normal=$(tput sgr0)
PURPLE='\033[0;35m'
NC='\033[0m'

echo "${PURPLE}${bold}\nDESTROYING INFRASTRUCTURE...\n${normal}${NC}"
terraform destroy -auto-approve
echo "${PURPLE}${bold}\nINFRASTRUCTURE DESTROYED SUCCESSFULLY \n${normal}${NC}"
