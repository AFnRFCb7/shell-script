{
    inputs =
        {
        } ;
    outputs =
        { self } :
            {
		lib =
			{
                            implementation =
                                {
                                    extensions ? { } ,
                                    mounts ? { } ,
                                    name ,
                                    nixpkgs ,
                                    profile ? null ,
                                    script ,
					system ,
					targetPkgs ? pkgs : [ pkgs.coreutils ]
                                } :
                                    let
                                        pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                                        shell-script =
                                                pkgs.buildFHSUserEnv
                                                    {
                                                        extraBwrapArgs = builtins.attrValues ( builtins.mapAttrs ( name : { host-path , is-read-only , ... } : "${ if is-read-only then "--ro-bind" else "--bind" } ${ host-path } ${ name }" ) mounts ) ;
                                                        name = name ;
                                                        profile = profile ;
                                                        runScript = script extensions ;
							targetPkgs = targetPkgs ;
                                                    } ;
                                        in
                                            {
                                                shell-script = "date" ; # "${ shell-script }/bin/${ name }" ;
                                            } ;
			} ;
		} ;
}
