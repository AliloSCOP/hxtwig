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
