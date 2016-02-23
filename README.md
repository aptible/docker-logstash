# ![](https://raw.github.com/aptible/straptible/master/lib/straptible/rails/templates/public.api/icon-60px.png) Logstash
[![Build Status](https://travis-ci.org/aptible/docker-logstash.svg?branch=master)](https://travis-ci.org/aptible/docker-logstash)


Logstash on Docker, configured with an HTTP listener.


## Installation and Usage

To run as an app on Aptible:

  1. Create an app on your [Aptible Dashboard][0] for Logstash. In the steps
  that follow, we'll use `YOUR_LOGSTASH_HANDLE` to refer to the handle you
  chose for your app. Make sure you substitute it for the actual handle
  accordingly!

  2. Use the [Aptible CLI][1] to configure Logstash. That's where you'll provide
  your Logstash filter and output configurations: `LOGSTASH_FILTER_CONFIG` is
  injected in the `filter { }` block (between the braces), and
  `LOGSTASH_OUTPUT_CONFIG` is injected in the `output { }` block (likewise).
  Refer to [the Logstash documentation][2] for more information. Just **make
  sure you don't log to stdout or stderr, or you might end up sending Logstash
  its own logs for processing (would be _very_ bad).**

  ```shell
  # Example configuration. Note that you MUST set DISABLE_WEAK_CIPHER_SUITES=true

  aptible config:set --app YOUR_LOGSTASH_HANDLE \
    LOGSTASH_FILTER_CONFIG='' \
    LOGSTASH_OUTPUT_CONFIG='' \
    DISABLE_WEAK_CIPHER_SUITES=true
  ```

  3. Clone this repository and push it to your Aptible app:

  ```shell
  git clone https://github.com/aptible/docker-logstash.git
  cd docker-logstash
  git remote add aptible git@beta.aptible.com:YOUR_LOGSTASH_HANDLE.git
  git push aptible master
  ```

  4. [Create a HTTPS endpoint for your app in Aptible][3]. Make sure your
  certificate is valid if you intend to use this app as a HTTPS log drain.

Now, you'll probably want to start sending logs to your Logstash instance!
To do so, [jump to step 2 of "How do I setup a HTTPS log drain?"][10].


### Plugins

By default, this image includes a selection of common Logstash codec, filter,
and output plugins.  If you need additional plugins, edit `./Gemfile`.


## Available Tags

  + `latest`: Currently Logstash 2.2.1


## Tests

Tests are run as part of the `Dockerfile` build. To execute them separately
within a container, run:

    bats test


## Deployment

To push the Docker image to Quay, run the following command:

    make release


## Copyright

MIT License, see [LICENSE](LICENSE.md) for details.

Copyright (c) 2016 [Aptible](https://www.aptible.com). All rights reserved.

[<img src="https://avatars2.githubusercontent.com/u/1737686?s=60" style="border-radius: 50%;" alt="@krallin" />](https://github.com/krallin)

  [0]: https://dashboard.aptible.com
  [1]: https://github.com/aptible/aptible-cli
  [2]: https://www.elastic.co/guide/en/logstash/current/configuration.html
  [3]: https://support.aptible.com/topics/paas/how-to-add-internal-or-external-domain/
  [10]: https://support.aptible.com/topics/paas/how-do-i-setup-a-https-log-drain/
