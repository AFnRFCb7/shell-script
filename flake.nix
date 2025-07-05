{
    inputs =
        {
        } ;
    outputs =
        { self } :
            let
		lib =
			{
                            implementation =
                                {
                                    extensions ? { } ,
                                    mounts ? { } ,
                                    name ,
                                    nixpkgs ,
                                    profile ? null ,
                                    script
                                } :
                                    let
                                        pkgs = builtins.import nixpkgs { system = system ; } ;
                                        shell-script =
                                                pkgs.buildFHSUserEnv
                                                    {
                                                        extraBwrapArgs = builtins.attrValues ( builtins.mapAttrs ( name : { host-path , is-read-only , ... } : "${ if is-read-only then "--ro-bind" else "--bind" } ${ host-path } ${ name }" ) mounts ) ;
                                                        name = name ;
                                                        profile = profile ;
                                                        runScript = script ;
                                                    } ;
                                        in
                                            {
                                                shell-script = "${ shell-script { } }/bin/${ primary.name }" ;
                                            } ;
			} ;
}
