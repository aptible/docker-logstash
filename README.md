# ![](https://raw.github.com/aptible/straptible/master/lib/straptible/rails/templates/public.api/icon-60px.png) Logstash

![](https://quay.io/repository/aptible/logstash/status?token=10d8074c-a102-46de-a3d1-869397b251ae)

Logstash on Docker, configured with an HTTP listener.

## Installation and Usage

    docker pull quay.io/aptible/logstash

### Plugins

By default, this image includes a selection of common Logstash codec, filter, and output plugins.
If you need additional plugins, edit `./Gemfile`.

### Configuration

Use the following environment variables to configure logstash:

  + `LOGSTASH_FILTER_CONFIG` will be included as-in Logstash's `filter { }` configuration block.
  + `LOGSTASH_OUTPUT_CONFIG` will be included as-is in Logstash's `output { }` configuration block.


#### Using on Aptible

To use on Aptible as a log drain, you **must** set the `DISABLE_WEAK_CIPHER_SUITES` configuration option:

    aptible config:set DISABLE_WEAK_CIPHER_SUITES=true

We also strongly encourage you to deploy Logstash in a separate environment that it won't be draining, to
avoid sending Logstash its own logs (which would be catastrophic if you inadvertently configure Logstash
to output log messages to stdout!).

## Available Tags

  + `latest`: Currently Logstash 2.2.1

## Tests

Tests are run as part of the `Dockerfile` build. To execute them separately within a container, run:

    bats test

## Deployment

To push the Docker image to Quay, run the following command:

    make release

## Continuous Integration

Images are built and pushed to Docker Hub on every deploy. Because Quay currently only supports build triggers where the Docker tag name exactly matches a GitHub branch/tag name, we must run the following script to synchronize all our remote branches after a merge to master:

    make sync-branches

## Copyright

MIT License, see [LICENSE](LICENSE.md) for details.

Copyright (c) 2016 [Aptible](https://www.aptible.com). All rights reserved.

[<img src="https://avatars2.githubusercontent.com/u/1737686?s=60" style="border-radius: 50%;" alt="@krallin" />](https://github.com/krallin)
