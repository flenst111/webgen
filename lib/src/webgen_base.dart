// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// TODO: Put public facing types in this file.

library webgen.base;
import 'dart:html';
import 'dart:convert';
import "package:utf/utf.dart";
import "package:crypto/crypto.dart";
import "package:markdown/markdown.dart";
import "package:cryptoutils/cryptoutils.dart";


class UIGenerator {
  static String generateForm(String uielements,var content) {
    // print('in generateform');
    var sbx = new StringBuffer();

    var elements = uielements.split(':');
    var map_elements = new Map<String,String>();
    elements.forEach((element){
        List tokens = element.split('-=');

        map_elements[tokens[0]]=tokens[1];
    });
    var id = map_elements['id'];
    var title = map_elements['title'];
    var cssclass = map_elements['class'] ;
    if (cssclass==null) cssclass = 'default';
    var sfields =  map_elements['fields'];
    var fields = sfields.split(';');
    sbx.write('<div id=\"form_${id}\" class=\"${cssclass}\">');
   // sbx.write('<h2> ${title} </h2>)');
    if (map_elements['pre']!= null){
    if (map_elements['pre'] == 'table')  sbx.write('<h2> ${title} </h2><table id=\"${id}\">'); //erweiterbar
    else sbx(map_elements['pre']);
    }
    fields.forEach((field){
      var lfe = field.split(',');
      var mfe =  new Map<String,String>();
      lfe.forEach((tk){
        List tokens = tk.split('=');
        // print("Attr:"+tokens[0]+"=="+tokens[1]);
        mfe[tokens[0]]=tokens[1];
      });
      // Ausnahmen abpruefen wie Radio button, button etc.
    //  print('generate2');
      if (mfe['pre']!=null) sbx.write(mfe['pre']);
      if (mfe['type']=='button'){
       // print('generate button');
        var fieldid=mfe['id'];

         var extid = 'btn_${id}${fieldid}';
         var label = mfe['label'];
         sbx.write('<button id=\"${extid}\"');
         var keys = mfe.keys;
         keys.forEach((key){
                print('Key:'+key);
                var value = mfe[key];
                if (key != 'type' && key != 'id' && key != 'post' && key != 'label' &&  key != 'pre')sbx.write(' ${key}=\"${value}\" ');
         });
         sbx.write('>${label}</button>');


      }else   if (mfe['type']=='label'){
       // print('generate label');
                var label = mfe['label'];
                sbx.write('<label>${label}</label>');
       } else   if (mfe['type']=='textarea'){
         // print('generate input');
                var fieldid=mfe['id'];
              //  print('FIELDID:'+fieldid.toString());
                if (fieldid != null){
                var extid = '${id}${fieldid}';
                var datalist = null;
                if (mfe['opt']!=null){
                datalist =  buildDataList(mfe, fieldid);
                }
                sbx.write('<textarea id=\"${extid}\"');
                        var keys = mfe.keys;
                        keys.forEach((key){
                               var value = mfe[key];
                               if (key != 'id'  && key != 'type'&& key != 'post' && key != 'pre' && key != 'opt')    sbx.write(' ${key}=\"${value}\" ');
                        });

                        sbx.write('>');
                        var scontent =content[fieldid].toString();
                                               if (scontent == null) scontent = '';
                                               sbx.write('${scontent}');
                                               sbx.write('</textarea>');
              if (datalist != null)sbx.write(datalist);
                }
              if (mfe['post'] != null) sbx.write(mfe['post']);



       }

      else{

      // print('generate input');
        var fieldid=mfe['id'];
      //  print('FIELDID:'+fieldid.toString());
        if (fieldid != null){
        var extid = '${id}${fieldid}';
        var datalist = null;
        if (mfe['opt']!=null){
        datalist =  buildDataList(mfe, fieldid);
        }
        sbx.write('<input id=\"${extid}\"');
                var keys = mfe.keys;
                keys.forEach((key){
                       var value = mfe[key];
                       if (key == 'disabled' || key=='readonly')sbx.write(' ${key} ');
                       else  if (key != 'id' && key != 'post' && key != 'pre' && key != 'opt')    sbx.write(' ${key}=\"${value}\" ');
                });
                var scontent =content[fieldid].toString();
                if (scontent == null) scontent = '';
                sbx.write(' value=\"${scontent}\" ');
                sbx.write('>');
      if (datalist != null)sbx.write(datalist);
        }
      if (mfe['post'] != null) sbx.write(mfe['post']);

      }
    });
     if (map_elements['post'] != null){
        if (map_elements['post'] == 'table')  sbx.write('</table>');
        else sbx(map_elements['post']);
        }
     sbx.write('</div>');
     return sbx.toString();
  }


  String generateGallery(String uielements,String host,String ext,[String dbsynonym]) {
    String synonym = 'verein';
    if (dbsynonym != null) synonym = dbsynonym;

    var sbx = new StringBuffer();
        var elements = uielements.split(':');
        var id = elements.elementAt(0);
        var classname = elements.elementAt(1);
        var typ = elements.elementAt(2);
        var simages =  elements.elementAt(3);
        var images = simages.split(';');
        sbx.write('<div id=\"${id}\">');
        images.forEach((img){
          if (typ == 'http' )
//                 sbx.write('<img id=\"${img}\" src=\"${host}${ext}/service/getdocument/dbsynonym/${synonym}/filename/${img}/\" alt=\"${img}\" />');
//                 else  sbx.write('<img src=\"${img}\" alt=\"${img}\"/>');
          sbx.write('<a href=\"${host}${ext}/service/getdocument/dbsynonym/${synonym}/filename/${img}/\"><img id=\"${img}\" src=\"${host}${ext}/service/getdocument/dbsynonym/${synonym}/filename/${img}/\" alt=\"${img}\" /></a>');
                           else  sbx.write('<a href=\"${img}\"><img src=\"${img}\" alt=\"${img}\"/></a>');
          });
        sbx.write('</div>');
        return sbx.toString();

    }


static String buildDataList(Map<String, String> mfe, String fieldid) {
      mfe['list']='${fieldid}_list';
    String listid = mfe['list'];
    var optionen = mfe['opt'];
    var lopt = optionen.split('|');
    var dl = new StringBuffer();
    dl.write( '<datalist id=\"${listid}\">');
    lopt.forEach((lo){
      dl.write('<option value=\"${lo}\">');
    });
    dl.write('</datalist>');
    return dl.toString();
  }
 static String generateHTMLListWithButtons(String id,String ulclass,String liclass,String buttonclass,List content) {
     var sbx = new StringBuffer();
     sbx.write('<ul class=\"${ulclass}\">');
     content.forEach((item){
       sbx.write('<li class=\"${liclass}\"><button class=\"${buttonclass}\" id=\"btn_${id}_${item}\">${item}</button></li>');
     });
    sbx.write('</ul');
    return sbx.toString();
 }
 static String generateHTMLListWithLink(String id,String ulclass,String liclass,String aclass,List content) {
      var sbx = new StringBuffer();
      sbx.write('<ul class=\"${ulclass}\">');
      content.forEach((item){
        sbx.write('<li class=\"${liclass}\"><a href=\"#\" class=\"${aclass}\" id=\"a_${id}_${item}\">${item}</a></li>');
      });
     sbx.write('</ul');
     return sbx.toString();
  }

static String generateList(String uielements,List content) {
     var sbx = new StringBuffer();

     var elements = uielements.split(':');
        var map_elements = new Map<String,String>();
        elements.forEach((element){
            List tokens = element.split('-=');

            map_elements[tokens[0]]=tokens[1];
        });
        var id = map_elements['id'];
        var title = map_elements['title'];
        var zeilenid =  map_elements['zeilenid'];
        var sfields =  map_elements['fields'];
        var fields = sfields.split(';');
        sbx.write('<div id=\"list_${id}\">');
        sbx.write('<h2> ${title} </h2><table id=\"${id}\">');
        var lifields = new List<Map>();
        fields.forEach((field){
          var lfe = field.split(',');
          var mfe =  new Map<String,String>();
          lfe.forEach((tk){
            print(tk);
            List tokens = tk.split('=');
            // print("Attr:"+tokens[0]+"=="+tokens[1]);
            mfe[tokens[0]]=tokens[1];
          });
          lifields.add(mfe);
        });
       //  sortieren gefaellig
       if (map_elements['sort'] != null){
         String sorter = map_elements['sort'];
         content.sort((a, b) => a[sorter].compareTo(b[sorter]));

}
       // filtern gefaellig
       var contenterg = content;
       if (map_elements['filter'] != null){
            String filter = map_elements['filter'];
            var filters =   filter.split('=');
            var filterkey = filters[0];
            var sfilter = filters[1];
            contenterg =new List<Map>();
            enthaelt(x,filt) => x[filterkey].contains(filt);
            content.forEach((c){
              if (enthaelt(c,sfilter)) contenterg.add(c);
         });
       }
       // headerzeile
       sbx.write('<tr>');
       lifields.forEach((m){
           var sclass = 'default';
           if (m['cssclass']!=null) sclass = m['cssclass'];
           var label = m['label'];
           sbx.write('<th class=\"${sclass}\">${label}</th>');
       });
       sbx.write('</tr>');
       contenterg.forEach((zeile){
        sbx.write('<tr>');
               lifields.forEach((m){
                   var sclass = 'default';
                   if (m['cssclass']!=null) sclass = m['cssclass'];
                   var bid = m['id'];
                   var idval =  zeile[zeilenid];
                   var label = m['label'];
                   if (m['id']== zeilenid){
                     sbx.write('<td class=\"${sclass}\"><button class=\"${sclass}\" id=\"btn_${id}${bid}_${idval}\">${idval}</button></td>');

                    }
                   else  if (m['type']== 'button'){
                     sbx.write('<td class=\"${sclass}\"><button class=\"${sclass}\" id=\"btn_${id}${bid}_${idval}\">${label}</button></td>');

                    }

                   else{
                     var fieldid = m['id'];
                     var value = zeile[fieldid];
                     sbx.write('<td class=\"${sclass}\">${value}</td>');
                    }
                });

               sbx.write('</tr>');


       });
       sbx.write('</table></div>');
           return sbx.toString();
      }
void getValueFromInputField(Map<String, String> vm, String key, String id) {
  InputElement input = querySelector('#' + id);
  if (input != null) {

      String retstr = input.value;
      retstr = retstr.trim();
      // print("VMAP-ELEM:" + key + '-' + retstr);
      if (retstr != null && retstr != 'null') vm[key] = retstr;
    }
  }


String getRTValueFromInputField(String id) {
  InputElement input = querySelector('#' + id);
  if (input != null) {
    String retstr = input.value;
    retstr = retstr.trim();
    return retstr;
  }
 return null;
}
Map<String,String> getMaskenWerte(String elements,[String tatyp='b64']) {
  var vmap = new Map<String, String>();
  var elementmap  = new Map<String, String>();
  var lelements = elements.split(':');
  lelements.forEach((elem){
    List tokens = elem.split('-=');
    elementmap[tokens[0]]=tokens[1];
});
  String docuid =elementmap['id'];
  String fields =elementmap['fields'];
  var lfields = fields.split(',');
  lfields.forEach((elem){
    List tokens = elem.split('=');
    String key = tokens[1];
    String dockey = docuid +'_'+key;
    String fieldtyp = tokens[0];
    if (fieldtyp=='inp') getValueFromInputField(vmap,key,dockey);
    else if  (fieldtyp=='ta') getValueFromTextArea(vmap, key,dockey,tatyp);
  });
  return vmap;
}
Map<String,String> getMaskenWertebyFieldId(String fields,[String tatyp='b64']) {
  var vmap = new Map<String, String>();
  var lfields = fields.split(',');
  lfields.forEach((elem){
    List tokens = elem.split('=');
    String dockey = tokens[1];
    var inttokens =dockey.split("_");
    var key = inttokens[1];
    String fieldtyp = tokens[0];
    if (fieldtyp=='inp') getValueFromInputField(vmap,key,dockey);
    else if  (fieldtyp=='ta') getValueFromTextArea(vmap, key,dockey,tatyp);
  });
  return vmap;
}


void getValueFromTextArea(Map<String, String> vm, String key, String id,[String tatyp='b64']) {
  var input = querySelector('#' + id);
  if (input != null) {
    String retstr = input.value;

   // print("VMAP-ELEM:" + key + '-' + retstr);
    if (retstr != null && retstr != 'null'){
      if (tatyp == 'b64') {
        var base64 = encodeBase64(retstr);
        //  print(base64);
        vm[key] = base64;
      } else if  (tatyp == 'hex') {
        List<int> bytes = UTF8.encode(retstr);
        var encodedHex = CryptoUtils.bytesToHex(bytes);
         vm[key] = encodedHex;


      }
  }
  }
}

enCodeBase64Url(String retstr) {
    var base64 = window.btoa(retstr);
  base64.replaceAll("+","-");
  base64.replaceAll("/","_");
  return base64;
}



encodeBase64(String retstr){
  var bytes = encodeUtf8(retstr);
  var base64 = CryptoUtils.bytesToBase64(bytes);
  base64.replaceAll("+","-");
  base64.replaceAll("/","_");
  return base64;
}

decodeBase64(String retstr){
  retstr.replaceAll("-","+");
  retstr.replaceAll("_","/");
  var by =CryptoUtils.base64StringToBytes(retstr);
  return decodeUtf8(by);
}

List<int> hexToBytes(String hex) {
    hex = hex.toLowerCase();
    final reqex = new RegExp('[0-9a-f]{2}');
    return reqex.allMatches(hex.toLowerCase()).map((Match match) =>
        int.parse(match.group(0), radix: 16)).toList();
}

void setMessage(nachricht,parentdivid) {
  var rem_message = document.querySelector('#message');
  if (rem_message != null) rem_message.remove();
  var sbx = new StringBuffer();
  sbx.write('<div id=\"message\">');
  sbx.write(nachricht);
  sbx.write('</div>');
  var xyzx = sbx.toString();
  var htmlk = document.querySelector('${parentdivid}');
  htmlk.appendHtml(xyzx);

}
String getConstServiceStr(String servicename,Storage localStorage,String host, String ext ){
  getsid(localStorage,host,ext);
  String hashcode = getHashCode(localStorage['sid']+localStorage['passwort']);
  String srequest = "${host}${ext}/service/${servicename}/sidbenutzer/${localStorage['benutzer']}/exttoken/${hashcode}";
  return srequest;
}
Map<String,String> addConstWerte(String servicename,Storage localStorage,String host, String ext,Map vm){
   getsid(localStorage,host,ext);
   String hashcode = getHashCode(localStorage['sid']+localStorage['passwort']);
  vm['service']=servicename;
  vm['sidbenutzer']= localStorage['benutzer'];
  vm['exttoken']= hashcode;
  return vm;
}
String  getMD5Passw(String passw) {

  String password = passw.trim();
  var halx;
  var hasher = md5;
  hasher.add("${password}".codeUnits);
  halx = CryptoUtils.bytesToHex(hasher.close());
  print(halx);
  return halx.toString();
}
String getHashCode(var hstr){
  var halx;
   var hasher = md5;
   // hasher.add("${password}".codeUnits);
   hasher.add("${hstr}".codeUnits);
   halx = CryptoUtils.bytesToHex(hasher.close());
   return halx;

}
void getsid(Storage localStorage,String host, String ext){
  var httpsb = new StringBuffer();
    httpsb.write('${host}${ext}/service/getsid/sidbenutzer/${localStorage['benutzer']}');
    print(httpsb.toString());
    HttpRequest.getString(httpsb.toString()).then((String results ){
    print("result:"+results);
    try{
     var anmeldung = JSON.decode(results);
     localStorage['sid'] = anmeldung['sid'];
     } catch(e) {
       print(e);
     }
    });

    }
void checksid(Storage localStorage,String host, String ext){
  var httpsb = new StringBuffer();
    String hashcode = getHashCode(localStorage['sid']+localStorage['passwort']);
    httpsb.write('${host}${ext}/service/checksid/sidbenutzer/${localStorage['benutzer']}/exttoken/${hashcode}');
    print(httpsb.toString());
    HttpRequest.getString(httpsb.toString()).then((String results ){
    print("result:"+results);
      try{
      } catch(e) {
       print(e);
     }
    });


   //  document.body.appendHtml(htmlx);
    }
StringBuffer getSpeicherStringBuffer(Map vmap,Storage localStorage,String host, String ext ){
  var httpsb = new StringBuffer();
   String srequest = getConstServiceStr("speichern",localStorage,host,ext );
   httpsb.write(srequest);
   vmap.forEach((k,v) =>  httpsb.write('/'+k+'/'+v));
   return httpsb;
  }


StringBuffer getInsertStringBuffer(Map vmap,Storage localStorage,String host, String ext ){
  var httpsb = new StringBuffer();
   String srequest = getConstServiceStr("insert",localStorage,host,ext );
   httpsb.write(srequest);
   vmap.forEach((k,v) =>  httpsb.write('/'+k+'/'+v));
   return httpsb;
  }

StringBuffer urlencodedstr(Map vmap){
  var httpsb = new StringBuffer();
    String separator='';
    vmap.forEach((k,v){
            httpsb.write(separator+ k+'=' +v);
            separator = '&';
    });
  return httpsb;

}




StringBuffer getInsertServiceStringBuffer(String service,Map vmap,Storage localStorage,String host, String ext ){
  var httpsb = new StringBuffer();
   String srequest = getConstServiceStr(service,localStorage,host,ext );
   httpsb.write(srequest);
   vmap.forEach((k,v) =>  httpsb.write('/'+k+'/'+v));
   return httpsb;
  }
StringBuffer getUpdateStringBuffer(Map vmap,Storage localStorage,String host, String ext ){
  var httpsb = new StringBuffer();
   String srequest = getConstServiceStr("update",localStorage,host,ext );
   httpsb.write(srequest);
   vmap.forEach((k,v) =>  httpsb.write('/'+k+'/'+v));
   return httpsb;
  }
StringBuffer getUpdateServiceStringBuffer(String service,Map vmap,Storage localStorage,String host, String ext ){
  var httpsb = new StringBuffer();
   String srequest = getConstServiceStr(service,localStorage,host,ext );
   httpsb.write(srequest);
   vmap.forEach((k,v) =>  httpsb.write('/'+k+'/'+v));
   return httpsb;
  }

baueDocument(filename,String host, String ext,[String synonym]) {
    String cssclass='default';
    String dbsynonym='verein';
    if (synonym != null) dbsynonym=synonym;
    String srequest = "${host}${ext}/service/getdocdatenbyfilename/filename/" + filename+"/dbsynonym/"+dbsynonym;
    print("Request:"+srequest);
    HttpRequest.getString(srequest).then((String results) {
    print("getdocdaten:" + results);
    try{
    if (results != null){
    var jsondat =  JSON.decode(results);
    if (jsondat !=null){
    var decstr = decodeBase64(jsondat['docu']);
    var validator = new NodeValidatorBuilder()
                  ..allowHtml5()
                  ..allowElement('a', attributes: ['href']);
    cssclass = jsondat['cssclass'];
    String xclass = 'class=\"${cssclass}\" ';
    decstr = parseDocument(decstr, xclass,host,ext);
    print("ERG2:"+decstr);
    var htmlstr = '<h2>${jsondat['docname']}</h2>${decstr}';
    DivElement dcontainer = new DivElement();
    dcontainer.id="content";
    dcontainer.setInnerHtml(htmlstr, validator: validator);
    document.querySelector('#artint').append(dcontainer);
    }
    }
    } catch(exception, stackTrace) {
      print(exception);
      print(stackTrace);
    }
  });
}

parseDocument(String decstr, String xclass,String host,String ext,[String dbsynonym]) {
   print("DECSTR BEFORE:"+decstr);
   if (decstr.startsWith('§§§')){
     decstr = markdownToHtml(decstr.substring(3));

   } else {
     decstr = decstr.replaceAll('+-', '<ul ${xclass}>');
     decstr = decstr.replaceAll('-+', '</ul>');
     decstr = decstr.replaceAll('+ul', '<ul ${xclass}>');
     decstr = decstr.replaceAll('-ul', '</ul>');
     //    decstr = decstr.replaceAll('+id', 'id=\"');
     //    decstr = decstr.replaceAll('-id', '\"');
     decstr = decstr.replaceAll('-ul', '</ul>');
     decstr = decstr.replaceAll('--', '<li ${xclass}>');
     decstr = decstr.replaceAll('+h2', '<h2 ${xclass} >');
     decstr = decstr.replaceAll('-h2', '</h2>');
     decstr = decstr.replaceAll('+h1', '<h1 ${xclass} >');
     decstr = decstr.replaceAll('-h1', '</h1>');
     decstr = decstr.replaceAll('+br', '<br/>');
     decstr = decstr.replaceAll('+b', '<b>');
     decstr = decstr.replaceAll('-b', '</b>');
     if (dbsynonym != null) decstr = decstr.replaceAll('+emb', '<embed  ${xclass} src=\"${host}${ext}/service/getdocument/dbsynonym/${dbsynonym}/filename/');
     else decstr = decstr.replaceAll('+emb', '<embed  ${xclass} src=\"${host}${ext}/service/getdocument/filename/');
     decstr = decstr.replaceAll('-emb', '\">');

     decstr = decstr.replaceAll('+iframe', '<iframe  ${xclass} sandbox=\"allow-same-origin\" src=\"${host}${ext}/service/getdocument/filename/');
     decstr = decstr.replaceAll('-iframe', '\"></iframe>'); //laut w3c-Schule richtig
     decstr = decstr.replaceAll('+em', '<em  ${xclass} >');
     decstr = decstr.replaceAll('-em', '</em>');
     decstr = decstr.replaceAll('+u', '<u  ${xclass}>');
     decstr = decstr.replaceAll('-u', '</u>');
     decstr = decstr.replaceAll('+tab', '<table  ${xclass}>');
     decstr = decstr.replaceAll('-tab', '</table>');
     decstr = decstr.replaceAll('+tr', '<tr  ${xclass}>');
     decstr = decstr.replaceAll('-tr', '</tr>');
     decstr = decstr.replaceAll('+th', '<th  ${xclass}>');
     decstr = decstr.replaceAll('-th', '</th>');
     decstr = decstr.replaceAll('+td', '<td  ${xclass}>');
     decstr = decstr.replaceAll('-td', '</td>');
     if (dbsynonym != null) decstr = decstr.replaceAll('+img', '<img  ${xclass} src=\"${host}${ext}/service/getdocument/dbsynonym/${dbsynonym}/filename/');
     else decstr = decstr.replaceAll('+img', '<img  ${xclass} src=\"${host}${ext}/service/getdocument/filename/');
     decstr = decstr.replaceAll('-img', '\">');

     if (decstr.indexOf("+a") >= 0) {
       decstr = decstr.replaceAll('::', '\">');
       decstr = decstr.replaceAll('+a', '<a  ${xclass} id=\"link\" href=\"');
       decstr = decstr.replaceAll('-a', '\</a>');

     }
   }
  print("DECSTR AFTER:"+decstr);
  return decstr;
}


}
class Form {
   String parent;
   String name;
   String sclass;
   String idprefix;
   List   formelements;
  Form(String cparent,String cname,String csclass,List fe){

  }

}
class TabbedPane {
  String parent;
  String name;
  String sclass;
  List tabs;
  String sdisplay;
  TabbedPane(String cparent,String cname,String csclass,List ctabs) {
    parent = cparent;
    name=cname;
    sclass=csclass;
    tabs = ctabs;
    StringBuffer sb = new StringBuffer();
    sb.write('<div class=\"Tabs ${sclass}CtrlBase\">');
    tabs.forEach((tab){
      sb.write('<div id="btn_tab_${tab}\" class=\"button ${sclass}Ctrl tab\"><span>${tab}</span></div>');
      });
    sb.write('</div>');
    sb.write('<div class=\"${sclass}Panels\">');
    tabs.forEach((tab){
        sb.write('<div id="tab_${tab}\" class=\"${sclass}Panel\"></div>');
     });
    sdisplay = tabs[0];
    String htab=sb.toString();
    print(htab);
    var hparent = document.query('#${parent}');


    var validator = new NodeValidatorBuilder()
                                 ..allowHtml5()
                                 ..allowSvg()
                                 ..allowElement('input', attributes: ['pattern','opt','data-tooltip'])
                                 ..allowElement('button', attributes: ['data-tooltip']);

    hparent.setInnerHtml(htab, validator: validator);

    display();

       }
  void setDisplay(String csdisplay){
    sdisplay =csdisplay;
    display();
  }

  void display() {
      tabs.forEach((pantab) {

       DivElement seltab =  document.query('#tab_${pantab}');
       seltab.style.display="none";
       });
       DivElement seltab =  document.query('#tab_${sdisplay}');
          seltab.style.display="block";
  }

  }



class WGGrid{

  var colnames = null;
   String parent;
   String name;
   String sclass;
   String idprefix;
WGGrid(String cparent,String cname,String csclass){
  parent = cparent;
  name = cname;
  sclass = csclass;
  }
  setColNames(ccolnames){
    colnames = ccolnames.split(',');

  }
  ///Create a grid with a custom element.
  TableElement getTable(List rows) {
    TableElement te = new TableElement();
    rows.forEach((row) => addRow(te, row));
    return te;
  }

  addRow(TableElement table, List cols) {
    TableRowElement tableRow = table.addRow();

    cols.forEach((column) {
      TableCellElement tableCell = tableRow.addCell();
      String content = column.toString();
      if (content.startsWith('http')) {
        content = "<a href=\"$content\">Link</a>";
        tableCell.appendHtml(content);
      } else tableCell.text = content;
    });
  }
}






























/// Checks if you are awesome. Spoiler: you are.
class Awesome {
  bool get isAwesome => true;
}
