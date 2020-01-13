package twig;

import twig.extension.Debug;

typedef TwigEnvironmentOptions = {
    ?debug:Bool,
}

/**
    Twig Environment adapter
**/
class TwigEnvironment{

    private var env:EnvironmentNative;

    public function new(loader:twig.loader.ILoader,options:TwigEnvironmentOptions){
        env = new EnvironmentNative(loader,php.Lib.associativeArrayOfObject(options));      
        
        //adds some usefull filters for haxe/PHP
        env.addFilter(new Filter("debug",debug)); //tries to print haxe objects as string
        env.addFilter(new Filter("tophparray",phpArray)); //transforms haxe arrays into php arrays
        
        if(options.debug){
            //to enable the dump() function
            //https://twig.symfony.com/doc/2.x/functions/dump.html
            env.addExtension( new twig.extension.Debug());
        }
    }

    public function render(tpl:String,params:Dynamic):String{

        var cleanedParams = new Map<String,Dynamic>();        

        //inject params differently depending on their type
		for( fname in Reflect.fields(params)){
			var field : Dynamic = Reflect.field(params,fname);
            
			if( Reflect.isFunction(field) ){
                // functions
				env.addFunction( new twig.Function(fname,field) );
            }else if ( Std.is(field,Array)){
                //Arrays are converted to PHP arrays
                cleanedParams[fname] = php.Lib.toPhpArray(field);
            }else if( Std.is(field,List) ){
                cleanedParams[fname] = php.Lib.toPhpArray(Lambda.array(field));
            }else if( Std.is(field,haxe.ds.StringMap) ){
                cleanedParams[fname] = php.Lib.associativeArrayOfHash(field);
            }/*else if( Std.is(field,haxe.ds.IntMap) ){
                cleanedParams[fname] = php.Lib.toPhpArray(Lambda.array(field));    
                this does not preserve int indexes
            }*/else{
                //regular param
                cleanedParams[fname] = field;
            }
		}

        return env.render(tpl,php.Lib.associativeArrayOfHash(cleanedParams));
    }

    public function addFunction(func:Function):Void{
        env.addFunction(func);
    }

    public function addFilter(filter:Filter){
        env.addFilter(filter);
    }

    public function addExtension(ext:Extension){
        env.addExtension(ext);
    }

    /**
        Try to print usual haxe types as string
    **/
    function debug(p:Dynamic):String{
        if(p==null) return "null";        
        return Std.string(p);       
    }

    function phpArray(arr:Array<Dynamic>):php.NativeArray{
        return php.Lib.toPhpArray(arr);
    }

}

@:native("Twig_Environment")
extern class EnvironmentNative{

    public function new(loader:twig.loader.ILoader,options:php.NativeArray);

    public function render(tpl:String,params:php.NativeArray):String;

    public function addFunction(func:Function):Void;

    public function addFilter(filter:Filter):Void;

    public function addExtension(ext:Extension):Void;

}