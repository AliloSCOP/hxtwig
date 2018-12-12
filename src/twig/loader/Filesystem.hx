package twig.loader;


@:native("Twig_Loader_Filesystem")
extern class Filesystem implements ILoader{
    public function new(pathToTemplates:String);
}

