# Docker package builder

## Prerequisites

The Docker package builder requires preinstalled [Docker](https://www.docker.com).
Also it worth to configure effective user to run docker without sudo.

## Parameters

    --config-dir, -c PATH_TO_CONFIG_FOLDER
        Path to config folder

    --no-keep-chroot, -n
        Remove build root after build stage

    --verbose, -v
        Be more verbose

    --build, -b
        Build package

    --update, -u
        Update a build root for selected distribution

    --shell, -s
        Start a root shell in the build root

    --init, -i
        Initialize a build root for selected distribution

    --repository, --repo, -r URL[,rpm-priority]
        Use additional package repository at URL. Supported formats
        are rpm and debian. `rpm-priority` is an integer, and makes
        sense for rpm repositories only. This option can be used
        multiple times

    --pin [PIN_STRING]
    --pin-package [PIN_PACKAGE_STRING]
    --pin-priority [PIN_PRIORITY_STRING]
        Options to set up apt pinning rules. This options can be used
        multiple times

    --dist, -d DISTRIBUTION
        Distribution to use

    --source, --src PATH_TO_SOURCES
        Path to package source. Current directory if unspecified

    --output, -o
        Path to folder for build results. Default is buildresult/ inside
        source folder

## Examples

```
$ ./build --dist centos7 --verbose --init
```
```
$ ./build --dist centos7 --repository http://some.custom.repo/os --verbose --build --source /path/to/sources
```
```
$ ./build --dist centos7 --shell
```
```
$ ./build --dist trusty --build --pin-package "*" --pin "release a=stable, v=7" --pin-priority "900" --shell
```
