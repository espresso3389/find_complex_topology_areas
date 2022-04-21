import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:topojson/topojson.dart';
import 'package:weather_japan/src/weather_areas.dart';

void main(List<String> arguments) async {
  for (final area in areas.values) {
    try {
      final resp = await http.get(Uri.parse(
          'https://geoshape.ex.nii.ac.jp/jma/resource/AreaInformationCity_weather/20220324/${area.class20}.topojson'));
      final json = jsonDecode(utf8.decode(resp.bodyBytes));
      final tj = TopoJson.fromJson(json);
      print('${area.class20}: ${getCountOfHoles(tj)}');
    } catch (e) {
      print('${area.class20}: $e');
    }
  }
}

int getCountOfHoles(TopoJson tj) {
  int total = 0;
  for (final object in tj.visitAllObjects()) {
    if (object.type == TopoJsonObjectType.polygon) {
      final count = (object as TopoJsonPolygon).rings.length;
      if (count > 1) total += count - 1;
    }
  }
  return total;
}

/*
3421300: 11
0620500: 10
0620600: 8
4646800: 7
0636500: 6
1221300: 5
1223700: 4
1520200: 5
0621300: 3
0630200: 3
0636100: 3
0638100: 3
0720700: 2
0734401: 2
0822800: 2
0854600: 2
1120200: 2
1121100: 3
1124600: 1
1210000: 2
1221700: 1
1221800: 2
1222400: 2
1222600: 2
1223100: 1
1223300: 1
1223900: 3
1232200: 1
1234900: 2
1241000: 1
1242300: 1
1320900: 1
1321000: 1
1322300: 1
1413000: 1
1421700: 1
1510000: 1
1520500: 1
1521200: 2
1521800: 1
1620600: 1
1720300: 1
1738400: 4
1850100: 2
1920200: 3
1921100: 2
1936400: 1
1942300: 1
1943000: 2
2030900: 1
2121100: 1
2130300: 1
2446100: 1
2620400: 1
2621400: 2
2710000: 1
2714000: 1
2720500: 1
2720600: 1
2721500: 1
2723000: 2
2736100: 2
2738300: 2
2821400: 1
2942600: 1
3034100: 1
3034300: 1
3234300: 1
3521500: 3
3534300: 1
4022400: 1
4044700: 1
4220100: 1
4220800: 1
4221100: 1
4620800: 3
4622100: 1
4652700: 2
4720700: 1
*/
