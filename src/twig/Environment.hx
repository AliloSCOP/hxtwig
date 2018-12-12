package twig;

@:native("Twig_Environment")
extern class Environment{

    public function new(loader:twig.loader.ILoader);

    public function render(tpl:String,params:php.NativeArray):String;

}