#!/usr/bin/env bash
set -euxo pipefail
echo "Start user data"
REGION=$(ec2-metadata --availability-zone | sed -n 's/.*placement: \([a-zA-Z-]*[0-9]\).*/\1/p');
aws s3 cp s3://resource-opinion-stg/get-pip.py - | python3
export VAULT_PASSWORD="{{ vault_password }}"
aws s3 sync s3://bootstrap-opinion-stg/playbooks/ansible-mysql /tmp/ansible-mysql --region $REGION && cd /tmp/ansible-mysql
echo "$VAULT_PASSWORD" > /tmp/ansible-mysql/secret
bash main.sh -r $REGION
rm /tmp/ansible-mysql/secret
echo "End user data"

# #!/usr/bin/env bash
# set -euxo pipefail
# echo "Start user data"
# curl https://bootstrap.pypa.io/get-pip.py | python3
# aws s3 cp s3://opinion-stg-bootstrap/playbooks/ansible-mysql/ /tmp/ansible-mysql --recursive && cd /tmp/ansible-mysql && bash main.sh
# echo "End user data"