"""Gera img/desenho_mola.svg: corte do modelo com mola (x1c_mola_2x13mm.scad,
medidas para PC), com uma pastilha grossa e uma fina."""
from pathlib import Path

S = 20                      # px por mm
R_EXT = 14.95
YC, R_CAV = 7.0, 6.7        # centro e raio das cavidades
R_PAST, R_PIST = 6.5, 6.55
BASE, TAMPA = 11, 2
FUNDO, Z_CAV = 1.5, 5       # fundo do poço e fundo da cavidade
R_POCO, R_GUIA, H_GUIA = 3.3, 2.2, 1.2
R_JAN, R_JAN_TOPO, ABA_RETA = 5.7, 6.7, 0.6
PIST = 2
ESP = {-1: 3.5, 1: 1.5}     # pastilha grossa à esquerda, fina à direita

COR = dict(corpo="#c9d6e3", borda="#34495e", tampa="#7f8c9a", past="#9a9a9a",
           pist="#f0a030", mola="#4a4a4a", forca="#d0312d", laser="#7b3fe4")
X0, ZB = 360, 430
X = lambda x: X0 + S * x
Z = lambda z: ZB - S * z
out = []
w = out.append


def poly(pts, fill, stroke=COR["borda"], extra=""):
    p = " ".join(f"{X(x):.1f},{Z(z):.1f}" for x, z in pts)
    w(f'<polygon points="{p}" fill="{fill}" stroke="{stroke}" stroke-width="1.5" {extra}/>')


def rect(x0, z0, x1, z1, fill, extra=""):
    poly([(x0, z0), (x1, z0), (x1, z1), (x0, z1)], fill, extra=extra)


def seta(x0, y0, x1, y1, cor, larg=3):
    w(f'<line x1="{x0:.1f}" y1="{y0:.1f}" x2="{x1:.1f}" y2="{y1:.1f}" stroke="{cor}" '
      f'stroke-width="{larg}" marker-end="url(#s{cor[1:]})"/>')


def rotulo(px, py, ty, texto, tx=760):
    w(f'<line x1="{px:.1f}" y1="{py:.1f}" x2="{tx-6}" y2="{ty-5:.1f}" stroke="#222" stroke-width="1"/>'
      f'<circle cx="{px:.1f}" cy="{py:.1f}" r="2.5" fill="#222"/>')
    for i, linha in enumerate(texto.split("\n")):
        w(f'<text x="{tx}" y="{ty + i*20:.1f}" font-size="16">{linha}</text>')


def mola(xc, z0, z1, n=6):
    pts = [(xc - R_POCO + 0.45, z0)]
    for i in range(n * 2):
        z = z0 + (z1 - z0) * (i + 0.5) / (n * 2)
        pts.append((xc + (R_POCO - 0.45) * (1 if i % 2 == 0 else -1), z))
    pts.append((xc + R_POCO - 0.45, z1))
    p = " ".join(f"{X(x):.1f},{Z(z):.1f}" for x, z in pts)
    w(f'<polyline points="{p}" fill="none" stroke="{COR["mola"]}" stroke-width="3" stroke-linejoin="round"/>')


W, H = 1180, 600
w(f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}" '
  f'font-family="Helvetica, Arial, sans-serif" fill="#222">')
w('<defs>')
for cor in (COR["forca"], COR["laser"]):
    w(f'<marker id="s{cor[1:]}" markerWidth="10" markerHeight="10" refX="8" refY="5" orient="auto">'
      f'<path d="M0,0 L10,5 L0,10 z" fill="{cor}"/></marker>')
w('<pattern id="hach" width="8" height="8" patternUnits="userSpaceOnUse" patternTransform="rotate(45)">'
  f'<rect width="8" height="8" fill="{COR["corpo"]}"/><line x1="0" y1="0" x2="0" y2="8" stroke="#8fa3b8" stroke-width="2"/></pattern>')
w('</defs><rect width="100%" height="100%" fill="#fff"/>')
w('<text x="30" y="40" font-size="22" font-weight="bold">Corte pelo centro das duas pastilhas: ajuste de altura por mola</text>')
w('<text x="30" y="66" font-size="15" fill="#555">À esquerda, pastilha de 3,5 mm; à direita, de 1,5 mm. As duas faces ficam no mesmo plano sem nenhum ajuste.</text>')

# base cortada e vazios
rect(-R_EXT, 0, R_EXT, BASE, "url(#hach)")
for s in (-1, 1):
    xc = s * YC
    rect(xc - R_CAV, Z_CAV, xc + R_CAV, BASE, "#fff")
    rect(xc - R_POCO, FUNDO, xc + R_POCO, Z_CAV, "#fff")
    rect(xc - 0.75, 0, xc + 0.75, FUNDO, "#fff")

# tampa cortada (janelas com chanfro)
pts_tampa = [(-R_EXT, BASE), (R_EXT, BASE), (R_EXT, BASE + TAMPA), (-R_EXT, BASE + TAMPA)]
poly(pts_tampa, COR["tampa"])
for s in (-1, 1):
    xc = s * YC
    poly([(xc - R_JAN, BASE - 0.02), (xc + R_JAN, BASE - 0.02), (xc + R_JAN, BASE + ABA_RETA),
          (xc + R_JAN_TOPO, BASE + TAMPA + 0.02), (xc - R_JAN_TOPO, BASE + TAMPA + 0.02),
          (xc - R_JAN, BASE + ABA_RETA)], "#fff", stroke="none")
    w(f'<line x1="{X(xc-R_JAN):.1f}" y1="{Z(BASE):.1f}" x2="{X(xc-R_JAN):.1f}" y2="{Z(BASE+ABA_RETA):.1f}" stroke="{COR["borda"]}" stroke-width="1.5"/>')
    w(f'<line x1="{X(xc+R_JAN):.1f}" y1="{Z(BASE):.1f}" x2="{X(xc+R_JAN):.1f}" y2="{Z(BASE+ABA_RETA):.1f}" stroke="{COR["borda"]}" stroke-width="1.5"/>')

# pastilhas, pistões e molas
for s in (-1, 1):
    xc, e = s * YC, ESP[s]
    zp = BASE - e
    rect(xc - R_PAST, zp, xc + R_PAST, BASE, COR["past"])
    rect(xc - R_PIST, zp - PIST, xc + R_PIST, zp, COR["pist"])
    rect(xc - R_GUIA, zp - PIST - H_GUIA, xc + R_GUIA, zp - PIST, COR["pist"])
    mola(xc, FUNDO, zp - PIST)
    seta(X(xc + 4.6), Z(zp - PIST - 1.6), X(xc + 4.6), Z(zp - 0.3), COR["forca"], 2.5)
    w(f'<text x="{X(xc)}" y="{Z(zp + e/2) + 6:.1f}" font-size="15" fill="#fff" text-anchor="middle">{str(e).replace(".", ",")} mm</text>')

# plano de referência e laser
w(f'<line x1="{X(-R_EXT-1.5):.1f}" y1="{Z(BASE):.1f}" x2="{X(R_EXT+1.5):.1f}" y2="{Z(BASE):.1f}" '
  f'stroke="{COR["laser"]}" stroke-dasharray="7 4" stroke-width="2"/>')
for s in (-1, 1):
    seta(X(s * YC), Z(BASE + 6.5), X(s * YC), Z(BASE + 0.3), COR["laser"])
w(f'<text x="{X(-YC)+10:.1f}" y="{Z(BASE+5.5):.1f}" font-size="15" fill="{COR["laser"]}">laser (LA) / LIBS</text>')

rotulo(X(R_EXT - 2), Z(BASE + 1), Z(BASE + 4.6), "Tampa parafusada (2 × M3 escareado)")
rotulo(X(YC + R_JAN), Z(BASE + 0.3), Z(BASE + 2.4), "Borda da janela (0,8 mm): a pastilha é\nempurrada contra ela")
rotulo(X(R_EXT + 1.2), Z(BASE), Z(BASE - 0.5), "Plano de referência: as duas faces\nficam aqui, mesmo com espessuras diferentes")
rotulo(X(YC - 3), Z(BASE - 2.5), Z(BASE - 3.6), "Pistão com pino-guia (impresso)")
rotulo(X(YC + R_POCO - 0.5), Z(4.5), Z(BASE - 5.6), "Mola de compressão inox\n(Ø 6 mm, livre 10 mm)")
rotulo(X(YC + 4.6), Z(6.8), Z(BASE - 8.2), "A mola empurra a pastilha para cima")
rotulo(X(YC), Z(0.5), Z(BASE - 10.2), "Respiro (Ø 1,5 mm): deixa o poço purgar")

passos = ["Montagem:",
          "1. Coloque a mola no poço, o pistão por cima (pino para baixo) e a pastilha com a face para cima.",
          "2. Encaixe a tampa: as pastilhas sobem até a borda das janelas.",
          "3. Aperte os 2 parafusos da tampa até encostar. Pronto: sem ajuste de altura.",
          "Para trocar a pastilha, solte a tampa: a mola levanta a pastilha e ela sai fácil."]
for i, t in enumerate(passos):
    w(f'<text x="30" y="{Z(-2) + i*24:.1f}" font-size="16" {"font-weight=\"bold\"" if i == 0 else ""}>{t}</text>')
w('</svg>')
Path(__file__).with_suffix(".svg").write_text("\n".join(out), encoding="utf-8")
