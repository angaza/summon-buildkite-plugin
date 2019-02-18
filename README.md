# Summon Buildkite Plugin

[`summon`](https://github.com/cyberark/summon) is a tool for fetching secrets
from secure storage; this plugin makes it easier to use in Buildkite jobs.

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

This plugin runs during [the `post-checkout`
hook](https://buildkite.com/docs/agent/v3/hooks#available-hooks), since you
will typically (but are not required to) reference a `secrets.yml` file from
your repo.

## Prerequisites

`summon` must already be installed in the environment where your agent runs,
along with whatever [providers](https://cyberark.github.io/summon/#providers)
you need.

## Tests

You can run the tests for this plugin with:

```sh
docker-compose run --rm tests
```

## License

MIT (see [LICENSE](LICENSE))
