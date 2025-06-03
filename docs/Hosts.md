# Hosts
Unify provides options to define hosts and choose which [[modules]] they will import. Here is very simple example of a file configuring a NixOS host.

``` nix
{ inputs, config }:
{
	unify.hosts.nixos.desktop = {
		modules = with config.unify.modules [
			# Unify modules to use for NixOS configuration
			cosmic
			gaming
			guest
		];

		users = {
			# Use the same Unify modules for a user's Home-Manager configuration
			quasi = {
				modules = config.unify.hosts.nixos.desktop.modules;
				home = {}; # Per-user home-manager configuration
			}
			# Use only specific Unify modules for a users Home-Manager configuration
			guest.modules = with config.unify.modules; [
				guest
			]
		};
	}

	args = { }; # Additional arguments to be passed to NixOS and Home-Manager modules. 
	# By default, the value hostConfig is passed, including all the values 

	nixos = { }; # Per-host NixOS configuration
	home = { }; # Per-host Home-Manager configuration, applied to all users on host
}
```

Note that you can use Unify modules without using the host options. Since Unify modules are added as flake outputs, you can define configurations using the typical flake options and import the modules however you'd like. 

