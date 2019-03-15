package twig.converter;

/**
    Converts templo (*.mtt) templates to Twig templates
**/
class Templo{

    public static var THIS = null;
    var sourceFolder : String;
    var destFolder : String;

    public function new(){
        THIS = this;
    }

    
    public function convert(sourceTemplate:String):String{
        var str = sourceTemplate;

        //if
        var str = new EReg("(::if[A-z0-9 ()=+-.!]+::)+","g").map(str,function(e:EReg){            
            var v :String = e.matched(0);
            v = StringTools.replace(v,"::","");
            return "{%"+v+"%}";
        });

        //foreach item array -> for item in array
        var str = new EReg("(::foreach [A-z0-9]+ [A-z0-9]+::)+","g").map(str,function(e:EReg){            
            var v :String = e.matched(0);
            v = StringTools.replace(v,"::","");
            v = StringTools.replace(v,"foreach","");
            v = StringTools.trim(v).split(" ").join(" in ");
            
            return "{% for "+v+" %}";
        });

        //::end:: -> {%endfor%}
        var str = new EReg("(::end::)+","g").map(str,function(e:EReg){            
            var v :String = e.matched(0);
            v = StringTools.replace(v,"::","");
            return "{% endfor %}";
        });

        //basic variable
        var str = new EReg("(::[A-z0-9 ()=+-.]+::)+","g").map(str,function(e:EReg){            
            var v :String = e.matched(0);
            v = StringTools.replace(v,"::","");
            return "{{"+v+"}}";
        });

       

        Sys.print(str);

        return str;



    }

    public static function main(){
        var args = Sys.args();

        if(args.length==0){
            Sys.print("Please type source folder and destination folders as parameters");
            Sys.exit(0);
        } 

        var c = new Templo();
        c.sourceFolder = Sys.getCwd()+""+args[0];
        c.destFolder = Sys.getCwd()+""+args[1];

        if( !sys.FileSystem.isDirectory(c.sourceFolder) ) throw "source Folder is not a directory";
        if( !sys.FileSystem.isDirectory(c.destFolder) ) throw "destination Folder is not a directory";
        if( !sys.FileSystem.exists(c.sourceFolder) ) throw "source Folder is not a directory";
        if( !sys.FileSystem.exists(c.destFolder) ) throw "destination Folder is not a directory";

        c.parse();
    }

    function parse(?subPath=""){

        Sys.println("\n===== Read Folder "+sourceFolder+subPath+" ======\n");
        for( file in sys.FileSystem.readDirectory(sourceFolder+subPath)){
            Sys.println("\n===== Read file "+file+" ======\n");

            if( sys.FileSystem.isDirectory(sourceFolder+subPath+"/"+file) ){
                //create directory in dest folder
                sys.FileSystem.createDirectory(destFolder+subPath+"/"+file);

                parse(subPath+"/"+file);
            }else{
                var str = THIS.convert(sys.io.File.getContent(sourceFolder+subPath+"/"+file));
                sys.io.File.saveContent(destFolder+subPath+"/"+file, str);
                Sys.println("\n===== Write "+destFolder+subPath+"/"+file+" ======\n");
            }
            
        }
         
        
    }




}