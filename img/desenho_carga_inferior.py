"""Gera img/desenho_carga_inferior.svg: corte do modelo carregado por baixo
(x1c_mola_carga_inferior_2x13mm.scad, medidas para PC)."""
from pathlib import Path

S = 22
R_EXT, YC, R_CAV, R_PAST, R_PIST = 14.95, 7.0, 6.7, 6.5, 6.55
H, T_FUNDO, BORDA, BORDA_RETA, R_JAN = 10, 2, 0.6, 0.3, 5.7
PIST, R_PINO, H_PINO, DESCIDA = 2, 2.0, 2.5, 0.55
ESP = {-1: 3.5, 1: 1.5}
COR = dict(corpo="#c9d6e3", borda="#34495e", fundo="#f2c27b", past="#9a9a9a",
           pist="#f0a030", mola="#4a4a4a", forca="#d0312d", laser="#7b3fe4")
X0, ZB = 380, 470
X = lambda x: X0 + S * x
Z = lambda z: ZB - S * z
out = []
w = out.append


def poly(pts, fill, stroke=COR["borda"]):
    p = " ".join(f"{X(x):.1f},{Z(z):.1f}" for x, z in pts)
    w(f'<polygon points="{p}" fill="{fill}" stroke="{stroke}" stroke-width="1.5"/>')


def rect(x0, z0, x1, z1, fill, stroke=COR["borda"]):
    poly([(x0, z0), (x1, z0), (x1, z1), (x0, z1)], fill, stroke)


def seta(x0, y0, x1, y1, cor, larg=3):
    w(f'<line x1="{x0:.1f}" y1="{y0:.1f}" x2="{x1:.1f}" y2="{y1:.1f}" stroke="{cor}" '
      f'stroke-width="{larg}" marker-end="url(#s{cor[1:]})"/>')


def rotulo(px, py, ty, texto, tx=790):
    w(f'<line x1="{px:.1f}" y1="{py:.1f}" x2="{tx-6}" y2="{ty-5:.1f}" stroke="#222" stroke-width="1"/>'
      f'<circle cx="{px:.1f}" cy="{py:.1f}" r="2.5" fill="#222"/>')
    for i, linha in enumerate(texto.split("\n")):
        w(f'<text x="{tx}" y="{ty + i*20:.1f}" font-size="16">{linha}</text>')


def mola(xc, z0, z1, n=7, r=2.85):
    pts = [(xc - r, z0)] + [(xc + r * (1 if i % 2 == 0 else -1), z0 + (z1 - z0) * (i + 0.5) / (2 * n))
                            for i in range(2 * n)] + [(xc + r, z1)]
    p = " ".join(f"{X(x):.1f},{Z(z):.1f}" for x, z in pts)
    w(f'<polyline points="{p}" fill="none" stroke="{COR["mola"]}" stroke-width="2" stroke-linejoin="round"/>')


W, Hc = 1230, 760
w(f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{Hc}" viewBox="0 0 {W} {Hc}" '
  f'font-family="Helvetica, Arial, sans-serif" fill="#222"><defs>')
for cor in (COR["forca"], COR["laser"]):
    w(f'<marker id="s{cor[1:]}" markerWidth="10" markerHeight="10" refX="8" refY="5" orient="auto">'
      f'<path d="M0,0 L10,5 L0,10 z" fill="{cor}"/></marker>')
w('<pattern id="hach" width="8" height="8" patternUnits="userSpaceOnUse" patternTransform="rotate(45)">'
  f'<rect width="8" height="8" fill="{COR["corpo"]}"/><line x1="0" y1="0" x2="0" y2="8" stroke="#8fa3b8" stroke-width="2"/></pattern>')
w('</defs><rect width="100%" height="100%" fill="#fff"/>')
w('<text x="30" y="40" font-size="22" font-weight="bold">Carregado por baixo: corte pelo centro das duas pastilhas (em uso)</text>')
w('<text x="30" y="66" font-size="15" fill="#555">Pastilha de 3,5 mm à esquerda e de 1,5 mm à direita. Acima da face de análise fica só a borda de 0,6 mm do próprio corpo.</text>')

# corpo cortado: bloco menos furos passantes e janelas
rect(-R_EXT, 0, R_EXT, H, "url(#hach)")
for s in (-1, 1):
    xc = s * YC
    rect(xc - R_CAV, -0.01, xc + R_CAV, H - BORDA, "#fff", "none")
    poly([(xc - R_JAN, H - BORDA - 0.01), (xc + R_JAN, H - BORDA - 0.01), (xc + R_JAN, H - BORDA + BORDA_RETA),
          (xc + R_JAN + 0.3, H + 0.01), (xc - R_JAN - 0.3, H + 0.01), (xc - R_JAN, H - BORDA + BORDA_RETA)], "#fff", "none")
    for x0, x1 in ((xc - R_CAV, xc - R_JAN), (xc + R_JAN, xc + R_CAV)):
        w(f'<line x1="{X(x0):.1f}" y1="{Z(H-BORDA):.1f}" x2="{X(x1):.1f}" y2="{Z(H-BORDA):.1f}" stroke="{COR["borda"]}" stroke-width="1.5"/>')
    for xx in (xc - R_CAV, xc + R_CAV):
        w(f'<line x1="{X(xx):.1f}" y1="{Z(0):.1f}" x2="{X(xx):.1f}" y2="{Z(H-BORDA):.1f}" stroke="{COR["borda"]}" stroke-width="1.5"/>')

# fundo (baioneta) travado, um pouco abaixo do corpo
rect(-R_EXT, -DESCIDA - T_FUNDO, R_EXT, -DESCIDA, COR["fundo"])

for s in (-1, 1):
    xc, e = s * YC, ESP[s]
    zf = H - BORDA
    rect(xc - R_PAST, zf - e, xc + R_PAST, zf, COR["past"])
    rect(xc - R_PIST, zf - e - PIST, xc + R_PIST, zf - e, COR["pist"])
    rect(xc - R_PINO, zf - e - PIST - H_PINO, xc + R_PINO, zf - e - PIST, COR["pist"])
    mola(xc, -DESCIDA, zf - e - PIST)
    seta(X(xc + 4.6), Z(zf - e - PIST - 2), X(xc + 4.6), Z(zf - e - PIST - 0.2), COR["forca"], 2.5)
    w(f'<text x="{X(xc)}" y="{Z(zf - e/2) + 6:.1f}" font-size="15" fill="#fff" text-anchor="middle">{str(e).replace(".", ",")} mm</text>')

w(f'<line x1="{X(-R_EXT-1.5):.1f}" y1="{Z(H-BORDA):.1f}" x2="{X(R_EXT+1.5):.1f}" y2="{Z(H-BORDA):.1f}" '
  f'stroke="{COR["laser"]}" stroke-dasharray="7 4" stroke-width="2"/>')
for s in (-1, 1):
    seta(X(s * YC), Z(H + 5), X(s * YC), Z(H - BORDA + 0.2), COR["laser"])
w(f'<text x="{X(-YC)+10:.1f}" y="{Z(H+4.2):.1f}" font-size="15" fill="{COR["laser"]}">laser (LA) / LIBS</text>')

rotulo(X(YC + R_JAN + 0.4), Z(H - 0.3), Z(H + 2.2), "Borda de 0,6 mm do próprio corpo:\nsegura 0,8 mm da beirada da pastilha")
rotulo(X(R_EXT + 1.2), Z(H - BORDA), Z(H - 0.6), "Plano de referência: as faces encostam\nna borda, qualquer que seja a espessura")
rotulo(X(R_EXT - 0.6), Z(4), Z(H - 3.8), "Corpo (impresso de cabeça para baixo:\na borda sai lisa e plana, direto da mesa)")
rotulo(X(YC - 3), Z(H - BORDA - 1.5 - 1), Z(H - 6.6), "Pistão com pino-guia")
rotulo(X(YC + 2.85), Z(3), Z(H - 8.4), "Mola leve (fio 0,3 mm): ~0,2–0,4 N")
rotulo(X(R_EXT - 3), Z(-DESCIDA - 1), Z(H - 10.4), "Fundo com baioneta: gira ~35° e trava")

passos = ["Montagem:",
          "1. Vire o corpo de cabeça para baixo e coloque cada pastilha com a face de análise para baixo (ela apoia na borda).",
          "2. Coloque o pistão (pino para cima) e a mola sobre o pino.",
          "3. Encaixe o fundo com as garras nos rasgos, empurre e gire ~35° no sentido HORÁRIO (olhando para o fundo) até o clique. Vire o conjunto.",
          "Nada gira sobre a face da pastilha: só o fundo gira, e ele toca apenas as molas."]
for i, t in enumerate(passos):
    w(f'<text x="30" y="{Z(-4.6) + i*24:.1f}" font-size="16" {"font-weight=\"bold\"" if i == 0 else ""}>{t}</text>')
w('</svg>')
Path(__file__).with_suffix(".svg").write_text("\n".join(out), encoding="utf-8")
