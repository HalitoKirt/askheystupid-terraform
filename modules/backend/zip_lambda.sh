#!/bin/bash
cd lambda
zip -r ../lambda.zip lambda_function.py
echo "Lambda zip created: lambda.zip"
