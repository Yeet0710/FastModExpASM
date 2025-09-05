# Fast Modular Exponentiation in Assembly

Dieses Projekt demonstriert eine schnelle Implementierung der modularen Exponentiation in x86-64-Assembler (NASM) für das Microsoft-x64-ABI. Die Funktion `modexp` berechnet `(base^exp) mod m` und nutzt dafür das Verfahren **Square-and-Multiply**.

## Mathematik

Gegeben seien drei ganze Zahlen `base`, `exp` und `mod`. Die modulare Exponentiation wird über folgende Schritte ausgeführt:

1. Reduziere die Basis: `base := base mod mod`.
2. Initialisiere `result := 1`.
3. Solange `exp > 0`:
   - Ist das niederwertigste Bit von `exp` gesetzt, aktualisiere `result := (result * base) mod mod`.
   - Verschiebe `exp` um ein Bit nach rechts (`exp >>= 1`).
   - Quadriere die Basis und reduziere erneut: `base := (base * base) mod mod`.

Die modularen Multiplikationen erfolgen über die Hilfsroutine `modmul`, welche mit den CPU-Instruktionen `mul` und `div` das Produkt bildet und direkt modulo `mod` reduziert.

## Ausführung

Zum Assemblieren und Linken wird NASM sowie ein Windows‑x64‑Toolchain (z. B. MinGW) benötigt. Die folgenden Befehle erzeugen das Beispielprogramm `test.exe`, das `2^23 mod 5 = 3` ausgibt:

```bash
nasm -f win64 modmul.asm -o modmul.o
nasm -f win64 modexp.asm -o modexp.o
nasm -f win64 test.asm   -o test.o
gcc test.o modexp.o modmul.o -o test.exe
./test.exe
```

## Projektstruktur

- `modexp.asm` – Implementierung der modularen Exponentiation.
- `modmul.asm` – Schnelle modulare Multiplikation.
- `test.asm` – Beispielprogramm zur Demonstration.

