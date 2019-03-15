package twig;

@:native("Twig_Filter")
extern class Filter{

    public function new(name:String,filterFunction:Dynamic->Dynamic);

}
