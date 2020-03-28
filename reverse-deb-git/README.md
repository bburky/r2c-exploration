# reverse-deb-git

This is an input set generator for the [r2c platform](https://app.r2c.dev/) that gathers reverse dependencies of Debian packages.

This script uses `apt-cache rdepends` to list all the reverse dependencies of the selected package(s) and then lists the URLs of their git development repositories using `debcheckout`. The current HEAD of the repository is queried using `git ls-remote` (some packages actually define a specific branch, but I ignore it out of laziness).

The output is JSON compatible with [`r2c upload-inputset`](https://docs.r2c.dev/en/latest/intro/custom-inputs.html).

## Usage

Run the script:

```
./reverse-deb-git.sh libcurl3-gnutls libcurl3-nss libcurl4 > libcurl.json
```

Or use the included Dockerfile with all dependencies included.

```
docker build -t reverse-deb-git .
docker run --rm -t reverse-deb-git libcurl3-gnutls libcurl3-nss libcurl4 > libcurl.json
```

And upload it:
```
r2c upload-inputset .\libcurl4.json
```

## Notes

<https://salsa.debian.org/> has replaced <https://anonscm.debian.org/>, but not all the packages have updated their repository URLs.

Sometimes connections to <https://salsa.debian.org/> time out and get incorrectly skipped.

There's no guarantee that all the reverse dependencies are implmented in the same programming language. A C language library will have mostly C reverse dependencies, but not all. This may make analysis difficult.