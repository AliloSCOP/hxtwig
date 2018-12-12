package twig.loader;

@:native("Twig_Loader_Array")
extern class ArrayLoader implements ILoader{
    public function new(args:php.NativeArray);
}