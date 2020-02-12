package twig;

import php.NativeIndexedArray;
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
        env.addFilter(new Filter("tophparray",hx2php)); //transforms haxe iterables into php arrays

        env.addFunction(new Function("toPhpArray",cast php.Lib.toPhpArray));
        env.addFunction(new Function("arrayOfObject",cast php.Lib.associativeArrayOfObject));

        //https://twig.symfony.com/doc/2.x/functions/dump.html
        env.addExtension( new twig.extension.Debug() );
        
    }

    public function render(tpl:String,params:Dynamic):String{

        var cleanedParams = new Map<String,Dynamic>();        

        //inject params differently depending on their type
		for( fname in Reflect.fields(params)){
			var field : Dynamic = Reflect.field(params,fname);
            
			if( Reflect.isFunction(field) ){
                // functions
				env.addFunction( new twig.Function(fname,field) );
            }else if ( Std.is(field,Array) || Std.is(field,List) || Std.is(field,haxe.ds.StringMap) || Std.is(field,haxe.ds.IntMap) ){
                cleanedParams[fname] = hx2php(field);
            }else{
                //regular param
                cleanedParams[fname] = field;
            }
		}

        return env.render(tpl,php.Lib.associativeArrayOfHash(cleanedParams));
    }

    /**
        Converts haxe iterables to php Array
    **/
    function hx2php(it:Iterable<Dynamic>):php.NativeArray{
        if ( Std.is(it,Array)){            
            return php.Lib.toPhpArray(cast it);
        }else if( Std.is(it,List) ){
            return php.Lib.toPhpArray(Lambda.array(it));
        }else if( Std.is(it,haxe.ds.StringMap) ){
            return php.Lib.associativeArrayOfHash( cast it);
        }else if( Std.is(it,haxe.ds.IntMap) ){
            var it:haxe.ds.IntMap<Dynamic> = cast it;
            var out = new php.NativeIndexedArray();
            for( k in it.keys() ) out[k]= it.get(k);
            return out;
        }else{
            throw "unknown haxe iterable";
        }
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

  

}

@:native("Twig_Environment")
extern class EnvironmentNative{

    public function new(loader:twig.loader.ILoader,options:php.NativeArray);

    public function render(tpl:String,params:php.NativeArray):String;

    public function addFunction(func:Function):Void;

    public function addFilter(filter:Filter):Void;

    public function addExtension(ext:Extension):Void;

}