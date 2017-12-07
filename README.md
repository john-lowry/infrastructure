To set up the bastion host, which is needed first:
```
ansible-playbook -i `aws ec2 describe-instances  --filters "Name=tag:Name,Values=bastion" |jq -r ".Reservations[].Instances[].PublicIpAddress"`, ansible/site.yml
```

```
ansible-playbook -i ansible/inventory/ec2.py --limit "tag_Name_proxy" ansible/site.yml
````



