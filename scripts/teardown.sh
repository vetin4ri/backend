#!/usr/bin/env bash

# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# Stop immediately if something goes wrong
set -euo pipefail

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
# shellcheck source=scripts/common.sh
source "$ROOT/scripts/common.sh"

check_dependency_installed gcloud
check_dependency_installed terraform

get_project

check_variable_set "PROJECT"
check_variable_set "STAGE"
check_variable_set "SMS_API_TOKEN"
check_stage_variable_set

echo
echo "Do you want to run \"terraform destroy\" on project \"${PROJECT}\" ?"
ask_for_confirmation

# Show plan
(cd "${ROOT}/terraform" && terraform plan \
  -destroy \
  -input=false \
  -var "project_id=${PROJECT}" \
  -var "stage=${STAGE}" \
  -var "sms_api_token=${SMS_API_TOKEN}" \
)

# Destroy
(cd "${ROOT}/terraform" && terraform destroy \
  -auto-approve \
  -var "project_id=${PROJECT}" \
  -var "stage=${STAGE}" \
  -var "sms_api_token=${SMS_API_TOKEN}" \
)
