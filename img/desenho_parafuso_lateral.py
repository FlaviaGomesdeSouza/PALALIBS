"""Gera img/desenho_parafuso_lateral.svg: corte e vista de cima da versão
com parafuso lateral (2 pastilhas), com as medidas padrão do .scad."""
from pathlib import Path

S = 18  # px por mm
R_EXT = 14.95          # raio externo (29,9 mm)
R_CAV = 6.55           # raio da cavidade (13,1 mm)
R_PAST = 6.5           # raio da pastilha
YC = 6.85              # centro das cavidades (vista de cima)
ALT, FUNDO = 10, 3     # altura e fundo
Z_LAT, R_FURO = 8, 1.25  # eixo do furo lateral (2 mm abaixo do topo)
PAST = 3               # espessura de pastilha ilustrada
PIST = 2
CALCO = 2.5
X_SEC = (R_EXT**2 - YC**2) ** 0.5  # meia largura do corte A–A

COR = dict(corpo="#c9d6e3", borda="#34495e", past="#9a9a9a", pist="#f0a030",
           calco="#6fbf73", paraf="#5b5b5b", forca="#d0312d", laser="#7b3fe4")

out = []
w = out.append


def rect(x0, y0, x1, y1, fill, stroke=COR["borda"], extra=""):
    x, y = min(x0, x1), min(y0, y1)
    w(f'<rect x="{x:.1f}" y="{y:.1f}" width="{abs(x1-x0):.1f}" height="{abs(y1-y0):.1f}" '
      f'fill="{fill}" stroke="{stroke}" stroke-width="1.5" {extra}/>')


def seta(x0, y0, x1, y1, cor, larg=3):
    w(f'<line x1="{x0:.1f}" y1="{y0:.1f}" x2="{x1:.1f}" y2="{y1:.1f}" stroke="{cor}" '
      f'stroke-width="{larg}" marker-end="url(#seta-{cor[1:]})"/>')


def rotulo(px, py, tx, ty, texto):
    w(f'<line x1="{px:.1f}" y1="{py:.1f}" x2="{tx-4:.1f}" y2="{ty-5:.1f}" stroke="#222" stroke-width="1"/>'
      f'<circle cx="{px:.1f}" cy="{py:.1f}" r="2.5" fill="#222"/>')
    for i, linha in enumerate(texto.split("\n")):
        w(f'<text x="{tx:.1f}" y="{ty + i*20:.1f}" font-size="16">{linha}</text>')


def parafuso_h(x0, x1, zc, X, Z):
    """Parafuso sem cabeça horizontal com filetes."""
    rect(X(x0), Z(zc + R_FURO), X(x1), Z(zc - R_FURO), COR["paraf"])
    x = x0 + 0.35
    while x < x1:
        w(f'<line x1="{X(x):.1f}" y1="{Z(zc+R_FURO):.1f}" x2="{X(x+0.25):.1f}" y2="{Z(zc-R_FURO):.1f}" '
          f'stroke="#999" stroke-width="1"/>')
        x += 0.5


W, H = 1120, 1170
w(f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}" '
  f'font-family="Helvetica, Arial, sans-serif" fill="#222">')
w('<defs>')
for cor in (COR["forca"], COR["laser"], "#222222"):
    w(f'<marker id="seta-{cor[1:]}" markerWidth="10" markerHeight="10" refX="8" refY="5" orient="auto">'
      f'<path d="M0,0 L10,5 L0,10 z" fill="{cor}"/></marker>')
w('<pattern id="hach" width="8" height="8" patternUnits="userSpaceOnUse" patternTransform="rotate(45)">'
  f'<rect width="8" height="8" fill="{COR["corpo"]}"/><line x1="0" y1="0" x2="0" y2="8" stroke="#8fa3b8" stroke-width="2"/></pattern>')
w('</defs><rect width="100%" height="100%" fill="#ffffff"/>')

# ---------------- Painel A: corte vertical ----------------
X0, ZB = 330, 400
X = lambda x: X0 + S * x
Z = lambda z: ZB - S * z
w('<text x="30" y="40" font-size="22" font-weight="bold">A) Corte A–A (de lado, passando pelo centro da pastilha 1)</text>')

# corpo cortado (hachurado) e vazios
rect(X(-X_SEC), Z(ALT), X(X_SEC), Z(0), "url(#hach)")
rect(X(-R_CAV), Z(ALT), X(R_CAV), Z(FUNDO), "#fff")
rect(X(-R_FURO), Z(FUNDO), X(R_FURO), Z(0), "#fff")
rect(X(R_CAV), Z(Z_LAT + R_FURO), X(X_SEC), Z(Z_LAT - R_FURO), "#fff")

# peças
z_past = ALT - PAST
rect(X(-R_PAST), Z(ALT), X(R_PAST), Z(z_past), COR["past"])
rect(X(-R_CAV + 0.1), Z(z_past), X(R_CAV - 0.1), Z(z_past - PIST), COR["pist"])
rect(X(-1.2), Z(z_past - PIST), X(1.2), Z(-1.5), COR["paraf"])
for z in [i * 0.5 for i in range(-2, int((z_past - PIST) * 2))]:
    w(f'<line x1="{X(-1.2):.1f}" y1="{Z(z):.1f}" x2="{X(1.2):.1f}" y2="{Z(z+0.25):.1f}" stroke="#999"/>')
rect(X(R_CAV), Z(Z_LAT + 1.15), X(R_CAV + CALCO), Z(Z_LAT - 1.15), COR["calco"])
parafuso_h(R_CAV + CALCO, X_SEC - 0.3, Z_LAT, X, Z)

# topo / face de análise
w(f'<line x1="{X(-X_SEC-1):.1f}" y1="{Z(ALT):.1f}" x2="{X(X_SEC+1):.1f}" y2="{Z(ALT):.1f}" '
  f'stroke="{COR["laser"]}" stroke-dasharray="6 4" stroke-width="1.5"/>')
seta(X(-2), Z(ALT + 5), X(-2), Z(ALT + 0.3), COR["laser"])
w(f'<text x="{X(-1.4):.1f}" y="{Z(ALT+4):.1f}" font-size="16" fill="{COR["laser"]}">laser (LA) / LIBS</text>')

# forças
seta(X(X_SEC + 3.5), Z(Z_LAT), X(X_SEC + 0.6), Z(Z_LAT), COR["forca"])
seta(X(0), Z(-4.2), X(0), Z(-1.8), COR["forca"])

# rótulos
TX = 640
rotulo(X(X_SEC + 2), Z(Z_LAT + 0.2), TX + 90, Z(ALT + 2.2), "1. Aperte o parafuso lateral (chave Allen)")
rotulo(X(R_CAV + 1.8), Z(Z_LAT + 0.6), TX + 90, Z(ALT - 0.2), "2. Ele empurra o calço de nylon/PTFE")
rotulo(X(R_CAV), Z(Z_LAT - 0.5), TX + 90, Z(ALT - 2.4), "3. O calço aperta a BORDA da pastilha\n    contra a parede oposta da cavidade")
rotulo(X(3), Z(ALT - 1.5), TX + 90, Z(ALT - 5.4), "Pastilha: face rente ao topo")
rotulo(X(-4), Z(z_past - 1), TX + 90, Z(ALT - 7.4), "Pistão (sobe/desce)")
rotulo(X(1.2), Z(1.5), TX + 90, Z(ALT - 9.4), "Parafuso de baixo: ajusta a ALTURA")
w(f'<text x="{X(-X_SEC):.1f}" y="{Z(-5.6):.1f}" font-size="15">A pastilha fica presa entre o calço e a parede: não cai mesmo com o porta-amostras inclinado.</text>')
w(f'<text x="{X(-X_SEC-1.3):.1f}" y="{Z(ALT)+5:.1f}" font-size="14" fill="{COR["laser"]}" text-anchor="end">topo</text>')

# ---------------- Painel B: vista de cima ----------------
CX, CY = 330, 860
PX = lambda x: CX + S * x
PY = lambda y: CY - S * y
w(f'<text x="30" y="{CY - R_EXT*S - 30:.0f}" font-size="22" font-weight="bold">B) Vista de cima (os furos laterais ficam por dentro, tracejados)</text>')
w(f'<circle cx="{CX}" cy="{CY}" r="{R_EXT*S:.1f}" fill="{COR["corpo"]}" stroke="{COR["borda"]}" stroke-width="2"/>')
for sinal, n in ((1, 1), (-1, 2)):
    cy = YC * sinal
    w(f'<circle cx="{PX(0)}" cy="{PY(cy):.1f}" r="{R_CAV*S:.1f}" fill="#fff" stroke="{COR["borda"]}" stroke-width="1.5"/>')
    w(f'<circle cx="{PX(-0.05*sinal):.1f}" cy="{PY(cy):.1f}" r="{R_PAST*S:.1f}" fill="{COR["past"]}"/>')
    w(f'<text x="{PX(0)}" y="{PY(cy)+7:.1f}" font-size="22" fill="#fff" text-anchor="middle" font-weight="bold">{n}</text>')
    xa, xb = R_CAV * sinal, (R_CAV + CALCO) * sinal
    xe = (R_EXT**2 - cy**2) ** 0.5 * sinal
    tr = 'stroke-dasharray="5 3" opacity="0.85"'
    rect(PX(xa), PY(cy + 1.15), PX(xb), PY(cy - 1.15), COR["calco"], extra=tr)
    rect(PX(xb), PY(cy + R_FURO), PX(xe - 0.3 * sinal), PY(cy - R_FURO), COR["paraf"], extra=tr)
    seta(PX(xe + 3.2 * sinal), PY(cy), PX(xe + 0.5 * sinal), PY(cy), COR["forca"])
# linha de corte A–A
w(f'<line x1="{PX(-R_EXT-1.5):.1f}" y1="{PY(YC):.1f}" x2="{PX(R_EXT+1.5):.1f}" y2="{PY(YC):.1f}" '
  f'stroke="#222" stroke-dasharray="14 4 3 4" stroke-width="1.2"/>')
w(f'<text x="{PX(-R_EXT-3.2):.1f}" y="{PY(YC)+6:.1f}" font-size="16" font-weight="bold">A</text>')
w(f'<text x="{PX(R_EXT+2):.1f}" y="{PY(YC)-8:.1f}" font-size="16" font-weight="bold">A</text>')
rotulo(PX(R_EXT), PY(YC - 0.2), TX + 90, PY(YC + 3), "Rosca M3 na lateral do cilindro\n(um parafuso por pastilha)")
seta(PX(3.5), PY(YC - 3), PX(-4.5), PY(YC - 3), COR["forca"], 2)
rotulo(PX(-1), PY(YC - 3), TX + 90, PY(YC - 2.5), "A pastilha é empurrada contra\no lado oposto da cavidade")
rotulo(PX(-R_CAV - 1.3), PY(-YC + 0.6), TX + 90, PY(-YC + 0.3), "Calço (tracejado): só ele toca\na pastilha, nunca o metal do parafuso")
w('</svg>')

Path(__file__).with_suffix(".svg").write_text("\n".join(out), encoding="utf-8")
