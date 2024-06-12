## deploy-lambda-function
This repository will deploy a Lambda function in AWS using Terraform.
The Lambda function consists of a small python app which accepts POST requests with a body of text and returns the most common words in a JSON format which can be downloaded from S3.

## Usage
- You will need to have Terraform installed (I recommend using [tfenv](https://github.com/tfutils/tfenv)).
- You should also have [pre-commit](https://pre-commit.com/) installed.
- Update the `bucket_name` variable, as it should be a globally unique name.
- After you apply the Terraform configuration, you will get the `function_url` as output.
- Use this function url to construct your request to the service.

```
curl -X POST \
  https://xxxx.execute-api.eu-west-1.amazonaws.com/testing/process-text \
  -H 'Content-Type: application/json' \
  -d '{ "text": "example text with some example words and some repeated words" }'
```

You should then receive a url to download the JSON with the most common words.
