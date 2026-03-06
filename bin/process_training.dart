// ignore_for_file: avoid_print
/// Script to process training xlsx files into a single JSON for the app.
///
/// Usage: dart run bin/process_training.dart
///
/// Reads all xlsx files from assets/training_xlsx/ and generates
/// assets/training_plans_data.json with structured training data.
import 'dart:convert';
import 'dart:io';
import 'package:excel/excel.dart';

const monthNames = {
  '01': 'Enero',
  '02': 'Febrero',
  '03': 'Marzo',
  '04': 'Abril',
  '05': 'Mayo',
  '06': 'Junio',
  '07': 'Julio',
  '08': 'Agosto',
  '09': 'Septiembre',
  '10': 'Octubre',
  '11': 'Noviembre',
  '12': 'Diciembre',
};

const groupNames = {
  'A': 'Grupo A - Alta (19-20)',
  'B': 'Grupo B - Media (17-18)',
  'C': 'Grupo C - Baja (15-16)',
  'D': 'Grupo D - Deficiente (<14)',
  'E': 'Post Lactancia',
};

const groupOrder = ['A', 'B', 'C', 'D', 'E'];

void main() {
  final xlsxDir = Directory('assets/training_xlsx');
  if (!xlsxDir.existsSync()) {
    print('Error: assets/training_xlsx/ not found');
    exit(1);
  }

  final files = xlsxDir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.xlsx'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  print('Found ${files.length} xlsx files');

  // Structure: group -> month -> weeks
  final data = <String, Map<String, List<Map<String, dynamic>>>>{};

  for (final file in files) {
    final name = file.uri.pathSegments.last.replaceAll('.xlsx', '');
    final parts = name.split('-');
    if (parts.length != 2) {
      print('  Skipping unknown format: $name');
      continue;
    }

    final monthNum = parts[0]; // "01"
    final groupId = parts[1]; // "A", "B", etc.

    print('  Processing $name -> Month $monthNum, Group $groupId');

    try {
      final bytes = file.readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);

      final weeks = <Map<String, dynamic>>[];

      for (var i = 0; i < excel.tables.keys.length; i++) {
        final sheetName = excel.tables.keys.elementAt(i);
        final sheet = excel.tables[sheetName]!;

        final weekData = _parseSheet(sheet, i + 1, sheetName);
        weeks.add(weekData);
      }

      data.putIfAbsent(groupId, () => {});
      data[groupId]![monthNum] = weeks;
    } catch (e) {
      print('    Error processing $name: $e');
    }
  }

  // Build final JSON structure
  final grupos = <Map<String, dynamic>>[];

  for (final groupId in groupOrder) {
    if (!data.containsKey(groupId)) continue;

    final months = data[groupId]!;
    final meses = <Map<String, dynamic>>[];

    final sortedMonths = months.keys.toList()..sort();
    for (final monthNum in sortedMonths) {
      meses.add({
        'id': '${monthNames[monthNum]!.toLowerCase()}_2026',
        'nombre': monthNames[monthNum],
        'semanas': months[monthNum],
      });
    }

    grupos.add({
      'id': groupId,
      'nombre': groupNames[groupId] ?? 'Grupo $groupId',
      'meses': meses,
    });
  }

  final output = {'grupos': grupos};
  final jsonStr = const JsonEncoder.withIndent('  ').convert(output);

  File('assets/training_plans_data.json').writeAsStringSync(jsonStr);
  print('\nGenerated assets/training_plans_data.json');
  print('  ${grupos.length} groups, total months: ${grupos.fold<int>(0, (s, g) => s + (g['meses'] as List).length)}');
}

Map<String, dynamic> _parseSheet(Sheet sheet, int weekNum, String sheetName) {
  final dias = <Map<String, dynamic>>[];

  // Find the header row with day names
  int headerRow = -1;
  int horaCol = -1;
  int diaCol = -1;
  final dayColumns = <String, int>{}; // day name -> column index

  for (var r = 0; r < sheet.maxRows && r < 20; r++) {
    for (var c = 0; c < sheet.maxColumns && c < 10; c++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: r));
      final val = _cellText(cell).toUpperCase().trim();
      if (val == 'HORA') {
        headerRow = r;
        horaCol = c;
      }
      if (val == 'DÍA' || val == 'DIA') {
        diaCol = c;
      }
      if (headerRow == r) {
        if (val == 'MARTES' || val == 'MIERCOLES' || val == 'MIÉRCOLES' ||
            val == 'JUEVES' || val == 'VIERNES' || val == 'LUNES' ||
            val == 'SABADO' || val == 'SÁBADO') {
          dayColumns[val] = c;
        }
      }
    }
    if (headerRow >= 0) break;
  }

  if (headerRow < 0) {
    // Fallback: try to extract any text content
    return {
      'numero': weekNum,
      'titulo': 'Micro $weekNum',
      'dias': [],
    };
  }

  // Parse rows after header
  String currentSeccion = '';
  String currentHora = '';

  // Collect blocks per day
  final dayBlocks = <String, List<Map<String, String>>>{};
  for (final day in dayColumns.keys) {
    dayBlocks[day] = [];
  }

  for (var r = headerRow + 1; r < sheet.maxRows; r++) {
    // Check hora column
    if (horaCol >= 0) {
      final horaVal = _cellText(sheet.cell(
              CellIndex.indexByColumnRow(columnIndex: horaCol, rowIndex: r)))
          .trim();
      if (horaVal.isNotEmpty) {
        currentHora = horaVal;
      }
    }

    // Check dia column for section name
    if (diaCol >= 0) {
      final diaVal = _cellText(sheet.cell(
              CellIndex.indexByColumnRow(columnIndex: diaCol, rowIndex: r)))
          .trim()
          .toUpperCase();
      if (diaVal.contains('INICIAL')) {
        currentSeccion = 'PARTE INICIAL';
      } else if (diaVal.contains('PRINCIPAL')) {
        currentSeccion = 'PARTE PRINCIPAL';
      } else if (diaVal.contains('FINAL')) {
        currentSeccion = 'PARTE FINAL';
      }
    }

    // Read each day column
    for (final entry in dayColumns.entries) {
      final dayName = entry.key;
      final col = entry.value;
      final cellVal = _cellText(sheet.cell(
              CellIndex.indexByColumnRow(columnIndex: col, rowIndex: r)))
          .trim();

      if (cellVal.isNotEmpty) {
        dayBlocks[dayName]!.add({
          'hora': _cleanHora(currentHora),
          'seccion': currentSeccion,
          'actividad': cellVal,
        });
      }
    }
  }

  // Build dias list
  // Normalize day order
  const dayOrder = ['LUNES', 'MARTES', 'MIERCOLES', 'MIÉRCOLES', 'JUEVES', 'VIERNES', 'SABADO', 'SÁBADO'];
  final sortedDays = dayColumns.keys.toList()
    ..sort((a, b) => dayOrder.indexOf(a).compareTo(dayOrder.indexOf(b)));

  for (final day in sortedDays) {
    final blocks = dayBlocks[day]!;
    if (blocks.isNotEmpty) {
      dias.add({
        'nombre': _normalizeDayName(day),
        'bloques': blocks,
      });
    }
  }

  return {
    'numero': weekNum,
    'titulo': 'Micro $weekNum',
    'dias': dias,
  };
}

String _cellText(Data cell) {
  final value = cell.value;
  if (value == null) return '';
  String text;
  if (value is TextCellValue) {
    text = value.value.toString();
  } else if (value is IntCellValue) {
    text = value.value.toString();
  } else if (value is DoubleCellValue) {
    text = value.value.toString();
  } else if (value is FormulaCellValue) {
    text = value.formula;
  } else {
    text = value.toString();
  }
  // Normalize line breaks and clean up whitespace
  return text.replaceAll('\r\n', '\n').replaceAll('\r', '\n').trim();
}

/// Cleans hora values like "06:45\nA\n07:00" → "06:45 - 07:00"
String _cleanHora(String hora) {
  // Match pattern: time\nA\ntime
  final parts = hora.split('\n').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
  if (parts.length == 3 && parts[1].toUpperCase() == 'A') {
    return '${parts[0]} a ${parts[2]}';
  }
  return hora.replaceAll('\n', ' ').trim();
}

String _normalizeDayName(String day) {
  switch (day.toUpperCase()) {
    case 'LUNES':
      return 'Lunes';
    case 'MARTES':
      return 'Martes';
    case 'MIERCOLES':
    case 'MIÉRCOLES':
      return 'Miércoles';
    case 'JUEVES':
      return 'Jueves';
    case 'VIERNES':
      return 'Viernes';
    case 'SABADO':
    case 'SÁBADO':
      return 'Sábado';
    default:
      return day;
  }
}
