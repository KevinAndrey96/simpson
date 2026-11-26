# Integración numérica con la regla de Simpson 1/3 en MATLAB y GNU Octave

[![CI](https://github.com/KevinAndrey96/matlab-composite-simpson-integration/actions/workflows/ci.yml/badge.svg)](https://github.com/KevinAndrey96/matlab-composite-simpson-integration/actions/workflows/ci.yml)
![MATLAB](https://img.shields.io/badge/MATLAB-R2026a-0076A8)
![GNU Octave](https://img.shields.io/badge/GNU%20Octave-11-0790C0)
[![Licencia: MIT](https://img.shields.io/badge/licencia-MIT-yellow.svg)](LICENSE)

Funciones de cuadratura numérica para MATLAB y GNU Octave: **regla de Simpson 1/3 compuesta**, **Simpson adaptativo** con corrección de Richardson y un **estudio de convergencia** que mide el orden observado del error. Todo el código corre sin toolboxes y se prueba en Octave 11 y en MATLAB en cada cambio.

## Contenido

- [Fundamento matemático](#fundamento-matemático)
- [Uso](#uso)
- [Resultados de convergencia](#resultados-de-convergencia)
- [Estructura](#estructura)
- [Pruebas y calidad](#pruebas-y-calidad)
- [Historia del proyecto](#historia-del-proyecto)

## Fundamento matemático

La regla de Simpson 1/3 aproxima la integral en cada par de subintervalos con el polinomio de interpolación de grado dos que pasa por tres nodos. Con $n$ subintervalos pares de ancho $h = (b - a)/n$ y nodos $x_i = a + i h$:

$$
\int_a^b f(x)\,dx \approx \frac{h}{3}\left[f(x_0) + 4\sum_{i\ \text{impar}} f(x_i) + 2\sum_{i\ \text{par}} f(x_i) + f(x_n)\right]
$$

El error de truncamiento global es

$$
E = -\frac{(b - a)\,h^4}{180}\,f^{(4)}(\xi), \qquad \xi \in (a, b),
$$

así que la regla es exacta para polinomios de hasta grado tres y, en funciones suaves, el error se divide entre 16 cada vez que $n$ se duplica (orden 4, frente al orden 2 del trapecio).

**Simpson adaptativo.** En lugar de una malla uniforme, cada intervalo se divide en dos mitades y se compara la estimación gruesa $S_1$ con la refinada $S_2$. Si $|S_2 - S_1| \le 15\,\varepsilon$ se acepta $S_2 + (S_2 - S_1)/15$ (extrapolación de Richardson); si no, cada mitad se refina con tolerancia $\varepsilon/2$. Así se gastan evaluaciones solo donde la función cambia rápido.

## Uso

```matlab
addpath('src');

% Regla compuesta con 64 subintervalos
area = composite_simpson(@(x) x.^4.5, 0, 5, 64);

% Simpson adaptativo con tolerancia absoluta 1e-10
[area, evaluaciones] = adaptive_simpson(@(x) exp(-x.^2), 0, 2, 1e-10);

% Orden observado del error al duplicar n
estudio = simpson_convergence(@sin, 0, pi, 2, 2.^(1:8));
[estudio.observed_order]
```

| Función | Descripción |
| :--- | :--- |
| `composite_simpson(f, a, b, n)` | Regla compuesta con `n` subintervalos pares. Acepta funciones vectorizadas o escalares, límites invertidos (`b < a`) y valida entradas con identificadores de error `simpson:*`. |
| `adaptive_simpson(f, a, b, tol, max_depth)` | Bisección adaptativa con corrección de Richardson. Devuelve también el número de evaluaciones de `f`. |
| `simpson_convergence(f, a, b, exacta, ns)` | Tabla con aproximación, errores absoluto y relativo y orden observado para cada `n`. |

## Resultados de convergencia

El ejemplo `examples/power_function_demo.m` reproduce el ejercicio original, $\int_0^5 x^{4.5}\,dx = 5^{5.5}/5.5 \approx 1270.493169033971$:

```text
       n             Simpson 1/3     abs error     rel error    order
       2    1370.496190115019317     1.000e+02     7.871e-02      NaN
       4    1276.576012006878273     6.083e+00     4.788e-03    4.039
       8    1270.869038578843629     3.759e-01     2.958e-04    4.016
      16    1270.516555738991201     2.339e-02     1.841e-05    4.006
      32    1270.494628222438450     1.459e-03     1.149e-06    4.002
      64    1270.493260175971500     9.114e-05     7.174e-08    4.001
     128    1270.493174729042039     5.695e-06     4.483e-09    4.000
     256    1270.493169389883633     3.559e-07     2.801e-10    4.000
     512    1270.493169056214811     2.224e-08     1.751e-11    4.000
    1024    1270.493169035361234     1.390e-09     1.094e-12    4.000
```

La columna `order` converge a 4, tal como predice la teoría.

```bash
octave-cli examples/power_function_demo.m
matlab -batch "run('examples/power_function_demo.m')"
```

## Estructura

```text
src/
  composite_simpson.m      regla de Simpson 1/3 compuesta
  adaptive_simpson.m       Simpson adaptativo con corrección de Richardson
  simpson_convergence.m    estudio de convergencia y orden observado
examples/
  power_function_demo.m    ejercicio original con x^4.5 en [0, 5]
tests/
  run_tests.m              ejecutor compatible con MATLAB y Octave
  test_*.m                 suites de pruebas
```

## Pruebas y calidad

```bash
octave-cli --eval "cd tests; run_tests"
matlab -batch "cd tests; run_tests"
```

15 pruebas cubren exactitud en polinomios cúbicos, orden de convergencia 4, límites invertidos, funciones no vectorizadas, singularidades, tolerancias del método adaptativo y validación de entradas. El pipeline de GitHub Actions ejecuta:

- **MISS_HIT** (`mh_style`, `mh_lint`, `mh_metric`) para estilo y análisis estático del código MATLAB.
- **GNU Octave 11** en el contenedor oficial `gnuoctave/octave`.
- **MATLAB** con las acciones oficiales de MathWorks.

## Historia del proyecto

Este repositorio nació en 2020 como un ejercicio de métodos numéricos con un script que integraba $x^{4.5}$ con una función fija y escribía en pantalla. En 2026 se reescribió como una pequeña librería con funciones reutilizables, validación de entradas, método adaptativo, pruebas automatizadas y CI en MATLAB y Octave. El código original se conserva en el tag [`v0.1-matlab-coursework-2020`](https://github.com/KevinAndrey96/matlab-composite-simpson-integration/tree/v0.1-matlab-coursework-2020).

## Autor

**Kevin Andrey Herrera Silva** · [GitHub](https://github.com/KevinAndrey96)

## Licencia

Distribuido bajo la [licencia MIT](LICENSE).
