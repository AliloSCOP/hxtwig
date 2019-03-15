package twig;


@:native("Twig_Function")
extern class Function{

    public function new(functionName:String,func:Void->String);

}