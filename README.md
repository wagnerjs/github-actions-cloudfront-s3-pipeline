# github-actions-cloudfront-s3-pipeline
Resposistory for practice Github Actions with AWS S3 &amp; Cloudfront.

## Terraform

To use Terraform in this project:

1. Install [Terraform](https://www.terraform.io/downloads.html).
2. Navigate to the `infra/` directory:
    ```
    cd infra
    ```
3. Initialize the Terraform workspace:
    ```
    terraform init
    ```
4. Review and customize the variables in `terraform.tfvars` or `variables.tf` as needed. Mandatory: `assume_role.role_arn`, `assume_role.external_id` and `github_assume_role.repo`
5. Preview the changes:
    ```
    terraform plan
    ```
6. Apply the configuration to provision AWS resources:
    ```
    terraform apply
    ```
7. After deployment, note the outputs for S3 bucket and CloudFront distribution IDs.

**Note:** Ensure your AWS credentials are configured locally or use OIDC as described below.

## Manual Configuration

### Create S3 bucket

Create a S3 bucket (Eg: `github-actions-cloudfront-s3-pipeline`).

### Cloudfront distribution

Create a Cloudfront distribution for S3 bucket above.

Configure "Default root object" to index.html.

### OIDC

Configure OIDC to federate Github actions. Reference: [Configuring OpenID Connect in Amazon Web Services](https://docs.github.com/en/actions/how-tos/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services)

#### Create role

Create a new role of type Web identity using the provider and audience created above and defining your Github Organization/Account, Repository and branch (optional). Eg.:

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::887155144097:oidc-provider/token.actions.githubusercontent.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                },
                "StringLike": {
                    "token.actions.githubusercontent.com:sub": "repo:wagnerjs/github-actions-cloudfront-s3-pipeline:*"
                }
            }
        }
    ]
}
```

#### Create an inline policy

On created role, add an Inline Police with the following permissions. Eg.:

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Statement1",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::github-actions-cloudfront-s3-pipeline",
                "arn:aws:s3:::github-actions-cloudfront-s3-pipeline/*"
            ]
        },
        {
            "Sid": "Statement2",
            "Effect": "Allow",
            "Action": [
                "cloudfront:CreateInvalidation"
            ],
            "Resource": [
                "arn:aws:cloudfront::887155144097:distribution/E2ZRK5Q5EW2UCD"
            ]
        }
    ]
}
```

### Create workflow

Check `.github/workflows/frontend-pipeline.yml`.

Documentation: [Configure AWS Credentials for GitHub Actions
](https://github.com/aws-actions/configure-aws-credentials?tab=readme-ov-file#oidc-audience) 

## About the blog app

### How to use

```
npm run dev     # Starts the development server.

npm run build   # Builds the app for production.

npm start       # Runs the built app in production mode.
```

Your blog should be up and running on [http://localhost:3000](http://localhost:3000)!
