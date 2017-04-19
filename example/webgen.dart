// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library webgen.example;

import 'package:webgen/webgen.dart';


main() {
  var awesome = new Awesome();
  print('awesome: ${awesome.isAwesome}');
  var generator = new UIGenerator();
  StringBuffer uie = new StringBuffer();
  uie.write('id-=mg_:title-=Mitgliedsverwaltung:fields-=id=mid,type=number,label=Mitgliedsnummer,pattern=[0-9]{5},size=5;');
  uie.write('id=nachname,type=text,label=Nachname,size=50;');
  uie.write('id=vorname,type=text,label=Vorname,size=50;');
  uie.write('id=aktiv.type=checkbox,label=Aktiv,opt=J|N;');
  uie.write('id=eintritt,type=date,label=Eintrittsdatum;');
  uie.write('id=einfuegen-type=button,class=btn6d,label=Einfuegen;');
  uie.write('id=aendern,type=button,class=btn6d,label=Ändern');
  var uielements =uie.toString();
  print(uielements);
  Map<String, String> content = new Map<String,String>();
  content['mid']='233';
  content['nachname']='Paulsen';
  content['aktiv']='J';
  content['eintritt']='2014-01-01';
  print(UIGenerator.generateForm(uielements,content));

}
















