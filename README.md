# webgen

A Dart lib for the Browser

## Usage

A simple snippets example:

  

```
import 'package:webgen/webgen.dart';

class  TRDocument {
  
  TabbedPane tbp;
  
  UIGenerator generator;
  Storage localStorage;
  TRDocument(Storage slocalStorage,String shost, String sext){
  
    generator = new UIGenerator();
     
    buildDocumentList();
  ..
     
    String srequest = generator.getConstServiceStr("getmitglied",localStorage, host, ext);
    srequest +=  "/mitglied/" + aktid;
    HttpRequest.getString(srequest).then((String results) {
      if (debug)  print("---->getMitglied:" + results);
      var mitglied = null;
      try {
        mitglied = JSON.decode(results);
      } catch (e) {
        print(e);
      }

  ...
  
     var vmap = new Map<String, String>();
    generator.getValueFromInputField(vmap,'medienid','med_medienid');
    generator.getValueFromInputField(vmap,'mid','med_mid');
    generator.getValueFromInputField(vmap,'medientyp','med_medientyp');
    generator.getValueFromInputField(vmap,'medienwert','med_medienwert');
    generator.getValueFromInputField(vmap,'storno','med_storno');

  ... 
    
    String elements = 'id-=nr:fields-=inp=nrid,inp=thema,ta=nachricht,inp=verantwortlich,inp=blogname,inp=cssclass,inp=verknuepft,inp=kategorie,inp=erstellt';
        var vmap;
        vmap = generator.getMaskenWerte(elements,'hex'); /textarea as hex coded
        
  ..
   
    vmap = generator.addConstWerte('insertnr',localStorage,host,ext,vmap);
      saveData(vmap);
   
   
        
    
    
    htmlm.setInnerHtml(htmlx, validator: validator);
        tbp = new TabbedPane('mitglied',"tblmitglied",'tab',['mitglied','passwort','anschrift','medien']);
        var hmitgl = document.query('#tab_mitglied');
        var hpassw = document.query('#tab_passwort');
        var hanschrift = document.query('#tab_anschrift');
        var hmedien = document.query('#tab_medien');



```

    
  generator.setMessage(
        '<h3 class="good">Die Anmeldung war erfolgreich! Jetzt editieren</h3>','#footer');  
    
    
    
    
    
    
  }















## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
