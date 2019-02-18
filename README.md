# Summon Buildkite Plugin

[`summon`](https://github.com/cyberark/summon) is a tool for fetching secrets
from secure storage; this plugin makes it easy to use in
[Buildkite](https://buildkite.com/) jobs.

Some reasons you might care:

- Maybe you're still hardcoding secrets in your Buildkite pipeline settings? If
  so, that is bad and you should stop. This plugin helps you stop.
- You can immediately leverage any of the [existing `summon` secrets
  providers](https://github.com/cyberark/summon-aws-secrets), so you have
  flexibility in what secure storage you use.
- By installing different default providers on different machines, you can
  fetch secrets appropriately in different locations without changing
  configuration, e.g., pulling from a local keyring in development but from
  [AWS SM](https://github.com/cyberark/summon-aws-secrets) in CI.

## Examples

Here's a simple pipeline configuration:

```yml
steps:
  - plugins:
      - angaza/summon#v0.1.0:
          secrets-file: path/to/secrets.yml
```

The secrets fetched by `summon` are exported as environment variables to the
rest of the step, including subsequent plugins. To use with [the Docker Compose
plugin](https://github.com/buildkite-plugins/docker-compose-buildkite-plugin),
for example:

```yml
steps:
  - plugins:
      - angaza/summon#v0.1.0:
          secrets-file: path/to/secrets.yml
      - docker-compose#v2.6.0:
          config: path/to/docker-compose.yml
          run: service-name
```

Most `summon` options are supported:

```yml
steps:
  - plugins:
      - angaza/summon#v0.1.0:
          secrets-file: path/to/secrets.yml
          provider: summon-s3
          environment: production
          substitutions:
            - REGION=us-east-1
```

The plugin runs during [the `post-checkout`
hook](https://buildkite.com/docs/agent/v3/hooks#available-hooks), the earliest
point at which the repo is available, since you will typically (but are not
required to) reference a checked-in `secrets.yml` file.

## Prerequisites

`summon` must already be installed in the environment where your agent runs,
along with whatever provider(s) will be used.

## Tests

You can run the tests for this plugin with:

```sh
docker-compose run --rm tests
```

## License

MIT (see [LICENSE](LICENSE))
