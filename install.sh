#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo -e '\e[31mThis script must be run with SUDO ! \e[0m'
   exit 1
fi

# Check if jq is installed or not
if ! command -v jq &> /dev/null
then
    echo -e '\e[31mjq could not be found. Please install jq first\e[0m'
    exit
fi

# Parse the Input Arguments
read -p $'\033[38;5;208mEnter your OpenAI key: \033[0m' token

# Verify the token using the OpenAI API
response=$(curl -s https://api.openai.com/v1/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $token" \
  -d '{"model": "text-davinci-003", "prompt": "Say this is a test", "temperature": 0, "max_tokens": 7}')

# Check if the token is valid
if [[ "$response" == *"\"object\":\"text_completion\""* ]]; then
  # Check if the simbba directory already exists
  if [[ -d "/opt/simbba" ]]; then
    # Save the token to the access.key file in the simbba directory
    echo "$token" | sudo tee /opt/simbba/access.key > /dev/null
    sudo cp ./fish/meow.chor /bin/simbba
    chmod +x /bin/simbba
    echo -e '\e[32mChatBot Setup Successfully 🤖\e[0m'
  else
    # Create the simbba directory and save the token to the access.key file
    sudo mkdir /opt/simbba && echo "$token" | sudo tee /opt/simbba/access.key > /dev/null
    sudo cp ./fish/meow.chor /bin/simbba
    chmod +x /bin/simbba
    echo -e '\e[32mChatBot Setup Successfully 🤖\e[0m'
  fi
else
  echo -e '\e[31mPlease provide a valid OpenAI key\e[0m'
fi
