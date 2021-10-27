# Use Demo Database as default configuration
Date: 2021-10-26
<br><br>

## Status

Accepted
<br><br>

## Context
Current configuration of Bahmni Docker comes with fresh database images as default configuration. This makes it difficult for developers/implementers to get started with Bahmni because fresh database needs certain basic configurations like adding locations,visit types, etc to be done even before logging in to Bahmni EMR.
<br><br>

## Descision
To make it easier for developers/implementers to get started with Bahmni, the database image tags will be set to demo tags so that people can start using Bahmni just by doing `docker-compose up`. Now, once the user gets familiar with Bahmni and is aware of the configurations, different user flows, then they can set the tag values to fresh and start with a fresh implementation.
<br><br>

## Consequences
Making the default configuration to demo database helps people to get onboarded on Bahmni quickly with minimal knowledge to the configurations. This might be an additional task for existing implementers to change the tags to fresh database. Also, the demo databse backups must be validated thoroughly so that there is no issue with master data setup for atomfeed sync.
<br><br>

## References:
1. [JIRA Card](https://bahmni.atlassian.net/jira/software/projects/BDI/boards/23?selectedIssue=BDI-37)
2. [Bahmni Configuraions Wiki](https://bahmni.atlassian.net/wiki/spaces/BAH/pages/34013647/Configuration+101)
