package twig.converter;

/**
    Converts templo (*.mtt) templates to Twig templates
**/
class Templo{

    public static var THIS = null;
    var baseDir : String;

    public function new(){
        THIS = this;
    }

    
    public function convert(sourceTemplate:String):String{

       // sourceTemplate = "salut les ::amis:: , comment ça va ::coucou::";

        var ereg = new EReg("(::[A-Za-z0-9]+::)+","g");
       
        //var str = ereg.replace(sourceTemplate,"{{$1}}");

        var str = ereg.map(sourceTemplate,function(e:EReg){
            
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

        var sourceFolder = Sys.getCwd()+"/"+args[0];
        var destFolder = Sys.getCwd()+"/"+args[1];

        if( !sys.FileSystem.isDirectory(sourceFolder) ) throw "source Folder is not a directory";
        if( !sys.FileSystem.isDirectory(destFolder) ) throw "destination Folder is not a directory";
        if( !sys.FileSystem.exists(sourceFolder) ) throw "source Folder is not a directory";
        if( !sys.FileSystem.exists(destFolder) ) throw "destination Folder is not a directory";

        var c = new Templo();
        c.baseDir = Sys.getCwd();
        c.parse(sourceFolder);

        
    }

    function parse(folder:String){
        trace("read dir "+folder);
        for( file in sys.FileSystem.readDirectory(folder)){
            trace(file);

            if( sys.FileSystem.isDirectory(folder+"/"+file) ){
                parse(folder+"/"+file);
            }else{
                THIS.convert(sys.io.File.getContent(folder+"/"+file));
            }
            
        }
         
        
    }




}