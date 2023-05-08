#!/usr/bin/env bash

#v1.0

RED='\033[0;31m'
NC='\033[0m' # No Color
BLUE='\033[0;34m'

# First arg to the script should be a domain
domain_to_validate=$1


if [ -z "${domain_to_validate}" ]
then
    echo -e "${RED}You did not pass a domain${NC}"
    exit 1
fi


read -p "Would you like to check the CNAME configuration? (Y/N): " confirm
if [[ $confirm == [yY] ]]
then
    cname_path=$(dig +short CNAME "${domain_to_validate}")

    if [ -z "${cname_path}" ]
    then
        echo -e "${RED}The domain has no CNAME${NC}"
    else
        echo "There is a CNAME which is ${cname_path}"

        if [[ $cname_path == *appsflyer.com. ]]
        then
            echo -e "${BLUE}The CNAME is pointing to AF, meaning somehow to appsflyer.com${NC}"
        else
            echo -e "${RED}The CNAME is not pointing to AF${NC}"
        fi

        if [[ $cname_path == *customlinks.appsflyer.com. ]]
        then
            echo -e "${BLUE}The domain is pointing to the branded domain flow${NC}"
        elif [[ $cname_path == *esplinks.appsflyer.com. ]]
        then
            echo -e "${BLUE}The domain is pointing to the esp flow${NC}"
        else
            echo -e "${RED}The domain is not pointing to a valid flow in AF${NC}"
        fi
    fi
fi

read -p "Would you like to check the CAA configuration? (Y/N): " confirm
if [[ $confirm == [yY] ]]
then
    caa_rec=$(dig +short @ns-1122.awsdns-12.org. $domain_to_validate CAA)

    if [[ "$caa_rec" == *"0 issue \"letsencrypt.org\""* ]]
    then
        echo -e "${BLUE}There is a CAA and it has the right config allowing lets encript${NC}"
    elif [ -z "${caa_rec}" ]
    then
        echo -e "${BLUE}There is no CAA record, we are all good since it means lets encript can create a certificate${NC}"
    else
        echo -e "${RED}CAA record exists and does not have lets encript in it, meaning we cannot create a certificate${NC}"
    fi
fi

read -p "Would you like to check the certificate expiration configuration? (Y/N): " confirm
if [[ $confirm == [yY] ]]
then
    if true | openssl s_client -connect $domain_to_validate:443 2>/dev/null | \
        openssl x509 -noout -checkend 0; then
        echo -e "${BLUE}Certificate is not expired${NC}"
    else
        echo -e "${RED}Certificate is expired or we failed to check it${NC}"
    fi
fi

read -p "Would you like to check that we can send a click? (Y/N): " confirm
if [[ $confirm == [yY] ]]
then
    echo "Going to check that can reach the click web handler"
    click=$(curl https://$domain_to_validate/onelink)
    if [[ "$click" == ok ]]
    then
        echo -e "${BLUE}Was able to reach the click web handler${NC}"
        echo -e "${BLUE}This means the domain is set and working with AF${NC}"
    else
        echo -e "${RED}Was not able to reach the click web handler${NC}"
    fi
fi