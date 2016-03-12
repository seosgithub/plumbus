![Plumbus: The micro-service bus](https://raw.githubusercontent.com/sotownsend/plumbus/master/docs/images/banner.png)

[![Gem Version](https://badge.fury.io/rb/iarrogant.svg)](http://badge.fury.io/rb/plumbus)
[![Build Status](https://travis-ci.org/sotownsend/plumbus.svg)](https://travis-ci.org/sotownsend/plumbus)
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/sotownsend/plumbus/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
[![License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/sotownsend/plumbus/blob/master/LICENSE)

# What is this?

Plubus is an agnostic micro-service router. 

## Features
  - [x] Bring your archaic HTTP api into the micro-service age without modifying the API
  - [x] *Any language, any networking or queuing library*
  - [x] Distributed by design, even session information
  - [x] Everything is a stream/push. Even HTTP (just a very short stream session!)
  - [x] Mix & Match - Daisy-chainable


## Example scenerio
Let's take the case where you have an aging HTTP web-service API, and a new modern sock-io client.
<div style='text-align: center'>
  <img width=600 src='./docs/images/request_response_drivers.png' />
</div>

In this example, we're using an HTTP driver and sockio-driver on the request side. On the response side we have an HTTP driver & a redis-queue driver. This configuration
allows us to serve all of our services located on the redis-bus & HTTP-bus to both sockio users and HTTP users!

## Routing schemes
Each request contains an action-name and session-id used for routing. Each response-driver maintains a running-list of available actions. If multiple action-paths are available,
a round-robin scheme is used to deliver messages. Responses are delivered based on the session-id back to the original source. This allows many responses, for a request that has
requested multiple actions which resulted in requests to multiple response backends, to deliver to the correct requester & know the status of the requester as signals are propogated
back to the responders in the event the request is closed. A session is deemed over if all responders hang-up.

## Streaming
All connections in plumbus are streams. HTTP, as it is stateless, is just treated as a degenerate stream that closes it's session after a response is given. One of the neat-things
about plumbus is that streams are able to hit multiple responses (by virtue of a request stream has sent multiple action requests and those were routed to seperate responses). This
provides you with load-balancing on traditionally single-server streams (like sock.io).

## Configuration
Configure is handled through a ruby file. This file contains a listing of `ports` which are just driver instances that are declared on either the request or response side.
```ruby
port(:request, 'plumbus-http') do
  #Driver specific config
end

port(:request, 'plumbus-sockio') do
  #Driver specific config
end

port(:response, 'plumbus-http') do
  #Driver specific config
end

port(:response, 'plumbus-redis-queue') do
  #Driver specific config
end
```

# Setup
```js
#Setup
gem install plumbus
```

# Usage
#### SYNOPSIS
```js
plumbus config
```
#### DESCRIPTION
config is a ruby file that declares backends & frontends (called ports).

## Requirements

- Modern **nix** (FreeBSD, Mac, or Linux)
- Ruby 2.2.1 or Higher (Very important)

## Communication
> ♥ This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Installation

RVM users:
Run `gem install plumbus`

System ruby installation?
Run `sudo gem install plumbus`

---

## FAQ

### When should I use plumbus?

Todo

### Creator

- [Seo Townsend](http://github.com/sotownsend) ([@seotownsend](https://twitter.com/seotownsend))


## License

plumbus is released under the MIT license. See LICENSE for details.
