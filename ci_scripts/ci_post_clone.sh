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
wget -O ../score_ios/ScoreSecrets/Keys.xcconfig "$KEYS"
wget -O ../score_ios/ScoreSecrets/apollo-codegen-config-dev.json "$CODEGEN_DEV"
wget -O ../score_ios/ScoreSecrets/apollo-codegen-config-prod.json "$CODEGEN_PROD"
