# DDV

Repository with DDV's application codebase.

## Scratch Org Creation Steps

1. Create a connection to the Devhub in your IDE using your credentials

2. Create a new scratch org with default duration days with an alias and set it as the default

```
sf org create scratch -f config/project-scratch-def.json -v <MyHub> -a <alias> --set-default
```

```
sfdx org create scratch -f config/project-scratch-def.json -a <alias> --set-default
```

- If the username is not set as default in you VSC use the following command

```
sf config set target-org <my-scratch-org-alias>
```

```
sfdx force:config:set target-org=<alias>
```

3. To set duration days to your scratch org during creation

```
sf org create scratch -f config/project-scratch-def.json -v <MyHub> -a <alias> --set-default --duration-days 30
```

```
sfdx org create scratch -f config/project-scratch-def.json -a <alias> --set-default --duration-days 30
```

4. Open scratch org

```
sf org open --target-org <scratchOrgAlias>
```

- To get information of the scratch org

```
sf org display
```

```
sfdx user display
```

- To generate a password for the user

```
sfdx user:password:generate
```

```
sf force user password generate
```

5. Deploy/Push metadata to scratch org

```
sf project deploy start
```

- Use this other command if you want to force push metadata to overwrite

```
sf project deploy start --ignore-conflicts
```

```
sfdx force:source:push -f
```

6. To retrieve an specific medatada from your scratch org use the following command

- To retrieve all metadata of the same type

```
sf project retrieve start -m <metadataName>
```

```
sfdx force:source:retrieve -m <metadataName>
```

- To retrieve with specific path

```
sf project retrieve start -d "<relativepath>"
```

```
sfdx force:source:retrieve -p "<relativepath>"
```

[Salesforce CLI Commands Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_unified.htm)

# Package Creation

- To create new package

```
sf package create --name "<Package Name>" --package-type Managed --path "<relativepath>" --target-dev-hub <Dev Hub Org Alias>
```
```
Example:
sf package create --name "Event Calendarization" --package-type Managed --path "force-app" --target-dev-hub devHub
```

- To create new package version

```
sf package version create --package <Pacakge Id> --definition-file config/project-scratch-def.json --wait 20 --target-dev-hub <Dev Hub Org Alias> --installation-key-bypass --code-coverage
```
```
Example:
sf package version create --package 0HoPl00000000MbKAI --definition-file config/project-scratch-def.json --wait 20 --target-dev-hub devHub --installation-key-bypass --code-coverage
```

- To create new package version without ancestor check

```
sf package version create --package <Pacakge Id> --definition-file config/project-scratch-def.json --wait 20 --target-dev-hub <Dev Hub Org Alias> --installation-key-bypass --code-coverage --skipancestorcheck
```
```
Example:
sf package version create --package 0HoPl00000000MbKAI --definition-file sfdx-project.json --wait 20 --target-dev-hub RadicalDevhub --installation-key-bypass --code-coverage --skipancestorcheck
```

- To promote the package
```
sf package version promote --package <Pacakge Version Id> --target-dev-hub <Dev Hub Org Alias>
```
```
Example:
sf package version promote --package 04tPl0000002z7RIAQ --target-dev-hub devHub
```

# Code Analyzer

- To run general code analyser report

```
sf scanner run --format=csv --outfile=CodeAnalyzerGeneral.csv --target="./" --category="Security"
```

- To run DFA code analyser report

```
sf scanner run dfa --format=csv --outfile=CodeAnalyzerDFA.csv --target="./" --projectdir="./" --category="Security"
```

- To run PMD app exchange code analyser report

```
sf scanner run --engine="pmd-appexchange" --format=csv --outfile=CodeAnalyzerPmdAppExchange.csv --target="./"
```

# Branching Strategy

- Create your feature branch off of the `develop` branch.
- Create a Scratch Org.
- Perform your changes and test in your Scratch Org
- Update your feature branch with the head branch before creating the PR to avoid conflicts.
- Once you are ready, submit a PR against the `develop` branch.
