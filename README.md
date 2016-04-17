Hiera OS X Keychain Backend
===========================

A simple [Hiera](https://docs.puppet.com/hiera/latest/) backend for looking up OS X keychain.

Requirements
------------

This Hiera backend requires OS X, obviously.

Usage
-----

Install `hiera-osxkeychain` gem to the Hiera environment.

    gem intall hiera-osxkeychain

In `hiera.yaml` config file, add `osxkeychain` backend and specify service name used in keychain. By default, service name is `hiera`.

    :backends:
      - osxkeychain
      ...
    :yaml":
      ...
    :osxkeychain:
      :service: "hiera"
    :hierarchy:
      ...

Create generic password items in OS X keychain with specified service name.
Use account name for each Hiera lookup key.

For example, launch _Keychain Access.app_, then use _New Password Item..._ under _File_ menu.
Give `hiera` (or service name you specified in `hiera.yaml`) to _Keychain Item Name:_,
Hiera lookup key name to _Account Name:_, then set _Password:_.

Try looking up the key from command line.

    hiera -c /path/to/hiera.yaml key

You may see a prompt to approve keychain access from `security` command.

Limitation
----------

Since keychain is a simple flat secure key-value storage, currently it doesn't support hierarchy.
Also doesn't support interporations on the value, which I believe shouldn't be used in the situation of keychain usage.