#!/bin/sh

#  ci_post_clone.sh
#  score-ios
#
#  Created by Hsia Lu wu on 3/5/25.
#  
#

echo "Downloading Secrets"
brew install wget
cd $CI_PRIMARY_REPOSITORY_PATH/ci_scripts
mkdir ../ScoreSecrets
wget -O ../ScoreSecrets/GoogleService-Info.plist "$GOOGLE_SERVICE_INFO"
wget -O ../ScoreSecrets/Keys.xcconfig "$KEYS"
wget -O ../ScoreSecrets/apollo-codegen-config-dev.json "$CODEGEN_DEV"
wget -O ../ScoreSecrets/apollo-codegen-config-prod.json "$CODEGEN_PROD"

echo "Generating API file"
../apollo-ios-cli generate -p "../ScoreSecrets/apollo-codegen-config-prod.json" -f
