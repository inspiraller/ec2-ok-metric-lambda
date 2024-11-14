#!/bin/sh
sh delete-lambda.sh
sh create-and-zip.sh
sh create-lambda.sh