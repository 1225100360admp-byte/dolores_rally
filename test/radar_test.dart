import 'package:dolores_rally/dominio/geo.dart';
import 'package:dolores_rally/dominio/radar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'ayudas.dart';

void main() {
  group('puntoEnRadar', () {
    final norte = destino(origen, 0, 250);
    final este = destino(origen, 90, 250);
    final sur = destino(origen, 180, 250);

    test('norte mirando al norte: ARRIBA', () {
      final (x, y) = puntoEnRadar(usuario: origen, rumbo: 0, objetivo: norte, alcance: 500)!;
      expect(x, closeTo(0, 0.01));
      expect(y, closeTo(-0.5, 0.01));
    });
    test('este mirando al norte: DERECHA', () {
      final (x, y) = puntoEnRadar(usuario: origen, rumbo: 0, objetivo: este, alcance: 500)!;
      expect(x, closeTo(0.5, 0.01));
      expect(y, closeTo(0, 0.01));
    });
    test('al girar hacia el este, pasa ARRIBA', () {
      final (x, y) = puntoEnRadar(usuario: origen, rumbo: 90, objetivo: este, alcance: 500)!;
      expect(x, closeTo(0, 0.01));
      expect(y, closeTo(-0.5, 0.01));
    });
    test('sur mirando al norte: ABAJO', () {
      final (_, y) = puntoEnRadar(usuario: origen, rumbo: 0, objetivo: sur, alcance: 500)!;
      expect(y, closeTo(0.5, 0.01));
    });
    test('más lejos que el alcance no aparece', () {
      expect(puntoEnRadar(usuario: origen, rumbo: 0, objetivo: destino(origen, 0, 800), alcance: 500),
          isNull);
    });
  });

  group('temperaturaPorDistancia', () {
    test('umbrales', () {
      expect(temperaturaPorDistancia(10), Temperatura.ardiente);
      expect(temperaturaPorDistancia(15), Temperatura.ardiente);
      expect(temperaturaPorDistancia(40), Temperatura.caliente);
      expect(temperaturaPorDistancia(100), Temperatura.tibio);
      expect(temperaturaPorDistancia(300), Temperatura.frio);
      expect(temperaturaPorDistancia(900), Temperatura.helado);
    });
    test('mientras más lejos, nunca se pone más caliente', () {
      var anterior = Temperatura.ardiente.index;
      for (var m = 0.0; m <= 1000; m += 5) {
        final actual = temperaturaPorDistancia(m).index;
        expect(actual, lessThanOrEqualTo(anterior));
        anterior = actual;
      }
    });
  });
}
