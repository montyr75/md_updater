import 'dart:html';

import 'package:angular2/angular2.dart';
import 'package:logging/logging.dart';
import 'package:polymer/polymer.dart';
import 'package:polymer_elements/iron_flex_layout/classes/iron_flex_layout.dart';
import 'package:polymer_elements/iron_icons.dart';
import 'package:polymer_elements/editor_icons.dart';
import 'package:polymer_elements/paper_header_panel.dart';
import 'package:polymer_elements/paper_toolbar.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_textarea.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_material.dart';
import 'package:polymer_elements/paper_icon_button.dart';
import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/paper_tooltip.dart';

@Component(selector: 'main-app',
    encapsulation: ViewEncapsulation.Native,
    templateUrl: 'main_app.html',
    directives: const [],
    providers: const [],
    styleUrls: const ['../../styles/mdb/bootstrap.min.css']
)
class MainApp {
  final Logger _log;

  String filename;
  String md;
  List<Match> linkMatches;
  List<Map> links = [];

  @ViewChild('md_ta') ElementRef md_ta;

  MainApp(Logger this._log) {
    _log.info("$runtimeType()");
  }

  void importMarkdownFile(Event event, FileList files) {
    _log.info("$runtimeType::importMarkdownFile()");

    if (convertToDart(event).detail['confirmed']) {
      // set up a file reader
      final reader = new FileReader();
      reader.onLoad.listen((ProgressEvent e) {
        filename = files.first.name;
        md = reader.result;
        getLinks();
      });

      // if we have a file, read it
      if (files.isNotEmpty) {
        reader.readAsText(files.first);
      }
    }
  }

  void goToLink(int index) {
    int start = linkMatches[index].start;
    int end = linkMatches[index].end;
    (md_ta.nativeElement as TextAreaElement).setSelectionRange(start, end);
  }

  void getLinks() {
    if (links.isNotEmpty) {
      links.clear();
    }

    RegExp regExp = new RegExp(r"(\[(.*?)\])(\((.*?)\))");
    linkMatches = regExp.allMatches(md).toList();
    for (Match m in linkMatches) {
      String text = m.group(2);
      String url = m.group(3);
      url = url.substring(1, url.length - 1);
      links.add({
        'text': text,
        'url': url
      });
    }
  }
}