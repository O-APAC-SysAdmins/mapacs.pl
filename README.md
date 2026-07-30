# mapacs.pl

Master Script for Asia Pacific SysAdmins

# Usage

Depending on if the script you need requires `sudo`:
``` shell
$ curl -L https://tinyurl.com/mapacspl | [sudo] perl - [mapacs.pl arguments] [- [script arguments]]
```

For example to run a script that requires `sudo` and you want `verbose` mode for `mapacs.pl`:
``` shell
$ curl -L https://tinyurl.com/mapacspl | sudo perl - -v
```

Or to run a script and you want to pass arguments to the underlying scrpt:
``` shell
$ curl -L https://tinyurl.com/mapacspl | perl - - -s
```

Or simplest without sudo or any arguments to neither `mapacs.pl` or underlying script:
``` shell
$ curl -L https://tinyurl.com/mapacspl | perl
```
