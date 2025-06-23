{
	nixConfig.bash-prompt-suffix = "dev$ ";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
	};

	outputs = { self, nixpkgs }:
		let pkgs = nixpkgs.legacyPackages.x86_64-linux; in {
			devShell.x86_64-linux = pkgs.mkShell {
				GROQ_API_KEY = "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";
				packages = [ pkgs.cmake pkgs.gcc pkgs.curl pkgs.simdjson ];
		};
	};
}