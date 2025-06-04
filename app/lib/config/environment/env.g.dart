// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env.dart';

// **************************************************************************
// EnviedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// generated_from: .env.development
final class _Env {
  static const List<int> _enviedkeyenv = <int>[
    3441804721,
    3777945934,
    2434581868,
    743998681,
    3689556910,
    1014729783,
    3342660408,
    1774363386,
    2776884906,
    3456586622,
    2030424499,
  ];

  static const List<int> _envieddataenv = <int>[
    3441804757,
    3777945899,
    2434581786,
    743998652,
    3689556930,
    1014729816,
    3342660424,
    1774363287,
    2776884943,
    3456586512,
    2030424519,
  ];

  static final Environment env = Environment.values.byName(
    String.fromCharCodes(
      List<int>.generate(
        _envieddataenv.length,
        (int i) => i,
        growable: false,
      ).map((int i) => _envieddataenv[i] ^ _enviedkeyenv[i]),
    ),
  );

  static const List<int> _enviedkeybackendUrl = <int>[
    1757091645,
    3449273183,
    960156428,
    4233494492,
    480775247,
    1666795221,
    3414303204,
    2368779978,
    2262863286,
    1044818531,
    2976097157,
    1164525010,
    3612118156,
    3568159086,
    681236787,
    2197063503,
    475504785,
    801136422,
    72492798,
    4196172577,
    436327968,
  ];

  static const List<int> _envieddatabackendUrl = <int>[
    1757091669,
    3449273131,
    960156536,
    4233494444,
    480775285,
    1666795258,
    3414303179,
    2368779942,
    2262863321,
    1044818432,
    2976097252,
    1164524990,
    3612118244,
    3568158977,
    681236800,
    2197063483,
    475504811,
    801136403,
    72492750,
    4196172561,
    436327952,
  ];

  static final String backendUrl = String.fromCharCodes(
    List<int>.generate(
      _envieddatabackendUrl.length,
      (int i) => i,
      growable: false,
    ).map((int i) => _envieddatabackendUrl[i] ^ _enviedkeybackendUrl[i]),
  );
}
