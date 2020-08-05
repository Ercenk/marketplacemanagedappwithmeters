#!/bin/bash

az login --identity
az identity list 

# run steps 2 and 3 to get managed app ID
az role assignment create --role "Reader" --assignee-object-id "<principal ID for the managed identity>" --scope "managed app resource ID from steps 2 and 3"