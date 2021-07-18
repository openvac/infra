# INFRA

Infrastructure-as-Code by way of Terraform.

### Development

You'll need:

* Terraform Account
* GitHub Personal Access Token
* Discord API Token

First login to Terraform if you havn't already:

```sh
terraform login
terraform init # once done
```

Then obtain all the necessary tokens and set them in your environment:

```sh
export TF_VAR_discord_token=...
export TF_VAR_github_token=replacewithyourgithubtokenhere
```

Then you should be good to go.

**NOTE:** We're using Terraform Cloud so if you only want to edit some resources and no
need for validating/testing locally then you may be able to work without the the tokens.
