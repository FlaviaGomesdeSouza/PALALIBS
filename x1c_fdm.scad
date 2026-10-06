// Preset para impressão FDM (Bambu Lab X1 Carbon, bico 0,4 mm).
// Usa o modelo principal e só troca as medidas que mudam no FDM:
// folgas por material, insertos de latão M3 e tampa mais grossa.
// Em OpenSCAD a última atribuição vale, então estes valores substituem
// os do arquivo incluído.

include <porta_amostras_30mm.scad>

/* [Peça] */
peca = "conjunto"; // [base, tampa, pistao, conjunto]
fixacao = "tampa"; // [tampa, lateral]
// FDM: só 1 ou 2 pastilhas (com 3 a parede fica com ~0,5 mm)
n_pastilhas = 2; // [1, 2]
// PC contrai ~0,5–0,7 % ao esfriar: furos saem menores e o externo também
material = "PC"; // [PC, PETG]

// Altura total: confira o máximo que o porta-amostras do equipamento aceita
altura = 12;

// Folgas por material (ajuste depois do anel de teste).
// Não use ao mesmo tempo a compensação de contração do fatiador.
folga_secao    = material == "PC" ? 0.1  : 0.2;
folga_pastilha = material == "PC" ? 0.4  : 0.25;
folga_pistao   = 0.3;
furo_parafuso  = material == "PC" ? 4.1  : 4.0;   // inserto M3 no fundo
furo_tampa_base = furo_parafuso;                  // inserto M3 da tampa
chanfro_inferior = 0.6;

// Fundo com inserto de latão M3 para o parafuso de altura
espessura_fundo = 4;
espessura_pistao = 1.6;

// Tampa de 2 mm presa com M3 escareado (DIN 965) em insertos M3
espessura_tampa = 2.0;
aba = 0.8;
aba_reta = 0.6;
r_parafusos_tampa = 11.3;
furo_tampa = 3.4;
d_cabeca_tampa = 6.0;
h_cabeca_tampa = 1.7;

// Parafuso lateral M3 com ponta de nylon, rosca aberta com macho direto no plástico
furo_lateral = 2.5;
z_lateral = 2.0;
