This is a Sandstorm app that runs the GNU MediaGoblin tests.

## How to build

- [Install vagrant-spk](https://docs.sandstorm.io/en/latest/vagrant-spk/installation/)

- `git clone https://github.com/paulproteus/gmg-tester`

- `cd gmg-tester`

- `vagrant-spk up`

- `vagrant-spk dev` then **make sure to visit the app in a browser** at local.sandstorm.io:6080 and create a grain!

- `export NEW_PUB_KEY=$(cd .sandstorm ; vagrant ssh -c 'spk keygen' | tail -n1)`

- `sed -i "s,mtxy58x9sy8dq7d3jgp1uw1m7cv0y71wj396pmguay6uf2n2vtyh,$NEW_PUB_KEY," .sandstorm/sandstorm-pkgdef.capnp`

- `vagrant-spk pack output.spk`

- Now you have `output.spk` and can run it anywhere.

## Roadmap

Current status:

**pre-v0.0.0**

### v0.0.0

- App exists and runs correctly in vagrant-spk.

- App exists, and bundles a copy of the GMG source code in the SPK, and runs the tests on Sandstorm.

- Within the grain, the `/` HTTP route contains information about if the build went OK.

### v0.0.1

- Each build gets a separate build log, and the top of the
  `index.html` page within the grain lists each build.

### v0.0.2

- App exports the status info over Sandstorm static publishing.

### v0.0.3

- App can use `git clone` to get a copy of the GMG code via
  `http://git.savannah.gnu.org/cgit/mediagoblin.git/` by using the Sandstorm `httpGet` API.  Note to
  self: Maybe can use `dulwich` for git fetching, plus pycapnp.

### v0.0.4

- App can be pinged over basic auth HTTP, which must for now be done outside Sandstorm
  because there's no cron-like API in Sandstorm. When it receives the ping, the app
  updates some status note
