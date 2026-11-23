# Integración Numérica Compuesta: Regla de Simpson 1/3 en MATLAB y GNU Octave

[![MATLAB](https://img.shields.io/badge/Language-MATLAB%20%2F%20GNU%20Octave-blue.svg)](https://www.mathworks.com/products/matlab.html)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Implementación modular y cálculo de cuadratura numérica mediante la **Regla de Simpson 1/3 Compuesta** en MATLAB y GNU Octave. El proyecto aproxima integrales definidas sobre funciones continuas, compara el resultado computacional frente al valor analítico exacto y proporciona un desglose cuantitativo de los errores absolutos y relativos con precisión extendida (`format long`).

---

## 📐 Fundamento Teórico y Matemático

La regla de Simpson 1/3 aproxima el área bajo una curva interpolando pares sucesivos de subintervalos mediante un polinomio cuadrático de Lagrange de segundo grado ($P_2(x) = A x^2 + B x + C$).

### 1. Regla Simple de Simpson 1/3

Para un intervalo cerrado $[a, b]$ dividido en dos mitades por el punto medio $m = \frac{a+b}{2}$, con paso $h = \frac{b-a}{2}$:

$$I_{simp} = \int_{a}^{b} f(x) \, dx \approx \frac{h}{3} \left[ f(a) + 4f(a+h) + f(b) \right]$$

El término de error de truncamiento local es de orden $O(h^5)$:

$$E_{local} = -\frac{h^5}{90} f^{(4)}(\xi), \quad \xi \in (a, b)$$

### 2. Regla Compuesta de Simpson 1/3

Al integrar sobre un intervalo general $[x_i, x_f]$ discretizado en $M$ paneles de ancho $W = \frac{x_f - x_i}{M}$ (cada uno subdividido a su vez en dos subintervalos de paso $h = \frac{W}{2}$):

$$I_{total} = \sum_{k=1}^{M} \frac{h}{3} \left[ f(x_k) + 4f(x_k + h) + f(x_k + 2h) \right]$$

El error de truncamiento global acumulado es de orden $O(W^4)$ u $O(h^4)$, lo que confiere a la regla de Simpson 1/3 una convergencia notablemente superior frente al método del trapecio ($O(h^2)$).

### 3. Validación Analítica

El script de prueba evalúa la función potencial $f(x) = x^{4.5}$, cuya integral analítica exacta es:

$$I_{real} = \int_{x_i}^{x_f} x^{4.5} \, dx = \left[ \frac{x^{5.5}}{5.5} \right]_{x_i}^{x_f} = \frac{x_f^{5.5} - x_i^{5.5}}{5.5}$$

Permitiendo cuantificar con exactitud:
- **Error Absoluto**: $E_{abs} = |I_{real} - I_{calc}|$
- **Error Relativo**: $E_{rel} = \frac{E_{abs}}{I_{calc}}$

---

## 📂 Estructura del Proyecto

```text
simpson/
├── f.m           # Definicion de la funcion continua a integrar: f(x) = x^4.5
├── simp.m        # Evaluador de la regla de Simpson 1/3 simple en un panel de ancho W
└── simpson_T.m   # Funcion principal: cuadratura compuesta, suma acumulada y tabla de error
```

---

## 🚀 Requisitos y Ejecución

### Prerrequisitos

- **MATLAB** (R2016a o superior) o **GNU Octave** (4.0 o superior).

### Ejecución en GNU Octave (Línea de Comandos)

```bash
# Iniciar Octave en modo interactivo en la carpeta del repositorio
octave -q

# Invocar la función con límites [xi, xf] y cantidad de paneles M
octave:1> simpson_T(0, 5, 100)
```

### Ejecución en MATLAB

1. Abre MATLAB y sitúa el directorio de trabajo en la raíz del repositorio.
2. En la ventana de comandos (`Command Window`), invoca `simpson_T`:

```matlab
% Ejemplo: integrar f(x) de 1 a 10 dividiendo en 50 particiones
simpson_T(1, 10, 50);
```

### Salida de Ejemplo

```text
	I calc			I_real			err abs		err rel  
	 1.258492048591234e+05	 1.258492048600125e+05	   8.89e-07	   7.06e-12
```

---

## 📄 Licencia

Distribuido bajo la Licencia MIT. Consulta el archivo `LICENSE` para más información.
