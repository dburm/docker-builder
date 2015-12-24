# Docker package builder

This tool was developed as an alternative to [OBS build](https://github.com/openSUSE/obs-build) package builder.

The goals of this projects:

- ability to build packages for rpm and deb based distributions
- packages should be built in native way in isolated environment against updated upstream state
- ability to run build stage for different distributions in parallel on the same node
- ability to get root shell at build root for debugging purpose

## Prerequisites

The `Docker package builder` requires preinstalled [Docker](https://www.docker.com).
Also it worth to configure user to run docker without **sudo**.

## Parameters

    --config-dir, -c PATH_TO_CONFIG_FOLDER
        Path to config folder

    --no-keep-chroot, -n
        Remove build root after build stage. Useful in purpose of
        CI/automation

    --verbose, -v
        Be more verbose

    --build, -b
        Build package

    --update, -u
        Update a build root for selected distribution

    --shell, -s
        Start a root shell in the build root

    --init, -i
        Initialize a chroot for selected distribution

    --no-init
        Exit with error if chroot or docker image for selected
        distribution doesn't exist. Useful in purpose of
        CI/automation

    --repository, --repo, -r URL[,rpm-priority]
        Use additional package repository at URL. Supported formats
        are rpm and debian. This option can be used multiple times.
        `rpm-priority` is an integer, and makes sense for rpm
        repositories only.

    --pin [PIN_STRING]
    --pin-package [PIN_PACKAGE_STRING]
    --pin-priority [PIN_PRIORITY_STRING]
        Options to set up apt pinning rules. This options can be used
        multiple times

    --dist, -d DISTRIBUTION
        Distribution to use

    --source, --src PATH_TO_SOURCES
        Path to package source. Current directory if not specified

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
