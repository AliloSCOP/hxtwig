# hxtwig
Haxe externs for Twig template engine (PHP)

## Compatibility
 - Code : Haxe 4.X
 - Runtime : PHP 7.X
 - Twig Version : 2.X

## Install

You need to install these Haxe externs, and the original PHP library :

```
composer require twig/twig:2.12.3`
haxelib git git@github.com:CagetteNet/hxtwig.git
```
## How to start

```
php.Global.require_once(php.Web.getCwd() + '/../vendor/autoload.php');
var loader = new twig.loader.Filesystem(php.Web.getCwd() + "/../tpl/");
var twig = new twig.TwigEnvironment(loader,{debug:true});
Sys.println( twig.render('index.twig',{
  name : "Bob",
}) );
```
## Tips

The debug filter will print the object in a Haxe way ( Std.string() is used )
```
{{user|debug}}
```

The dump method will print the object in a PHP way ( var_dump() is used )
```
{{dump(user)}}
```

Every Map, List or Array sent to the template engine will be transformed to a regular PHP array in order to make it iterable by Twig. Nevertheless this transformation is done at the first level, in case of nested iterables, you may need the "tophparray" filter
```
{% for v in (haxeArray|tophparray) %}
```
