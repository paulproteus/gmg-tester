This is a Sandstorm app that runs the GNU MediaGoblin tests.

## Roadmap

Current status:

**pre-v0.0.0***

### v0.0.0

- App exists and runs correctly in vagrant-spk.

- App exists, and bundles a copy of the GMG source code in the SPK, and runs the tests on Sandstorm.

- Within the grain, the `/` HTTP route contains information about if the build went OK.

### v0.0.1

- App exports the status info over Sandstorm static publishing.

### v0.0.2

- App can use `git clone` to get a copy of the GMG code via
  `http://git.savannah.gnu.org/cgit/mediagoblin.git/` by using the Sandstorm `httpGet` API.  Note to
  self: Maybe can use `dulwich` for git fetching, plus pycapnp.

### v0.0.3

- App can be pinged over basic auth HTTP, which must for now be done outside Sandstorm
  because there's no cron-like API in Sandstorm. When it receives the ping, the app
  updates some status note