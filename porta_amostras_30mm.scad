// Porta-amostras com seção de 30 mm para pastilhas prensadas de 13 mm
// (LA-ICP-MS / LIBS), sem embutimento em resina e sem polimento.
// Mesma ideia dos porta-amostras de seções polidas de MEV: a pastilha
// fica presa mecanicamente e a altura de cada uma é ajustável.
//
// Cada cavidade tem um pistão (disco solto) sob a pastilha e um parafuso
// M3 por baixo que o empurra para cima (ajuste de altura).
//
// Duas formas de prender a pastilha (parâmetro "fixacao"):
//   "tampa"   – tampa de topo com janelas um pouco menores que a pastilha.
//               O parafuso de baixo empurra a pastilha contra a borda da
//               janela: prende E nivela todas no mesmo plano, qualquer que
//               seja a espessura. Funciona com 1, 2 ou 3 pastilhas.
//   "lateral" – parafuso M3 radial pela lateral do cilindro, com um calço
//               de nylon/PTFE na ponta que aperta a borda da pastilha.
//               Só cabe com 1 ou 2 pastilhas (com 3 a parede tem ~0,5 mm).
//
// Peças: "base", "tampa", "pistao", "calco", "conjunto".

/* [Peça] */
peca = "conjunto"; // [base, tampa, pistao, calco, conjunto]
fixacao = "tampa"; // [tampa, lateral]

/* [Seção do porta-amostras] */
// Diâmetro nominal da seção aceita pelo porta-amostras do equipamento (mm)
diametro_secao = 30;
// Folga diametral para entrar no porta-amostras (mm)
folga_secao = 0.1;
// Altura total do conjunto montado (mm); ajuste à altura que o equipamento aceita
altura = 10;

/* [Pastilhas] */
// Número de pastilhas (1, 2 ou 3)
n_pastilhas = 3; // [1, 2, 3]
// Diâmetro das pastilhas (mm)
diametro_pastilha = 13;
// Folga diametral da cavidade (mm); 0.05–0.15 para usinagem, 0.15–0.25 para impressão 3D
folga_pastilha = 0.1;
// Parede mínima entre cavidades vizinhas (mm)
parede_entre = 0.6;

/* [Ajuste de altura (fundo)] */
// Espessura do fundo, onde fica a rosca M3 (mm)
espessura_fundo = 3;
// Furo do fundo: 2.5 para abrir rosca M3 com macho; 3.2 para M3 com porca/inserto
furo_parafuso = 2.5;
// Espessura do pistão (mm)
espessura_pistao = 2;
// Folga diametral entre pistão e cavidade (mm)
folga_pistao = 0.2;

/* [Tampa (fixacao = tampa)] */
// Espessura da tampa (mm); a face da pastilha fica esse tanto abaixo do topo
espessura_tampa = 1.5;
// Quanto a borda da janela cobre a pastilha, no raio (mm)
aba = 0.6;
// Parte reta da borda da janela antes do chanfro (mm)
aba_reta = 0.4;
// Raio do círculo dos parafusos M2 da tampa (mm)
r_parafusos_tampa = 12.5;
// Furo na base para os parafusos da tampa: 1.6 para rosca M2 com macho
furo_m2_base = 1.6;

/* [Parafuso lateral (fixacao = lateral)] */
// Furo lateral: 2.5 para abrir rosca M3 com macho
furo_lateral = 2.5;
// Profundidade do eixo do furo lateral abaixo do topo (mm); mínimo furo_lateral/2 + 0.5
z_lateral = 2.0;
// Diâmetro e comprimento do calço de nylon/PTFE
diametro_calco = 2.3;
comprimento_calco = 2.5;

/* [Acabamento] */
chanfro = 0.3;
$fn = 128;

d_secao = diametro_secao - folga_secao;
d_cavidade = diametro_pastilha + folga_pastilha;
d_pistao = d_cavidade - folga_pistao;
t_tampa = fixacao == "tampa" ? espessura_tampa : 0;
altura_base = altura - t_tampa;
prof_cavidade = altura_base - espessura_fundo;
d_janela = diametro_pastilha - 2 * aba;
dist_centros = d_cavidade + parede_entre;

r_centros = n_pastilhas == 1 ? 0
          : n_pastilhas == 2 ? dist_centros / 2
          : dist_centros / sqrt(3);
parede_externa = d_secao / 2 - r_centros - d_cavidade / 2;

// Janela da tampa: chanfro de 45° para cima, limitado para não encostar na vizinha
d_janela_topo = min(d_janela + 2 * (espessura_tampa - aba_reta),
                    n_pastilhas > 1 ? dist_centros - 0.6 : d_secao,
                    2 * (d_secao / 2 - r_centros) - 0.6);

n_parafusos_tampa = n_pastilhas == 1 ? 3 : n_pastilhas;

echo(str("Parede externa mínima: ", parede_externa, " mm"));
echo(str("Espessura de pastilha aceita: até ", prof_cavidade - espessura_pistao, " mm"));
assert(parede_externa > 0.3, "Parede externa < 0,3 mm: reduza parede_entre ou n_pastilhas");
assert(prof_cavidade > espessura_pistao, "Cavidade rasa demais para o pistão");
if (fixacao == "lateral")
    echo(str("Calço lateral: pastilhas com pelo menos ~", z_lateral, " mm de espessura"));
assert(fixacao == "tampa" || z_lateral >= furo_lateral / 2 + 0.5, "Furo lateral rompe o topo: aumente z_lateral");
assert(fixacao == "tampa" || n_pastilhas <= 2,
       "Parafuso lateral não cabe com 3 pastilhas em 30 mm; use fixacao = \"tampa\"");

function angulo(i) = 90 + i * 360 / n_pastilhas;
function centros() = [for (i = [0 : n_pastilhas - 1])
    [r_centros * cos(angulo(i)), r_centros * sin(angulo(i))]];
function parafusos_tampa() = [for (i = [0 : n_parafusos_tampa - 1])
    let(a = 90 + 180 / n_parafusos_tampa + i * 360 / n_parafusos_tampa)
    [r_parafusos_tampa * cos(a), r_parafusos_tampa * sin(a)]];
// Parafuso lateral: sai da cavidade para fora, perpendicular à linha dos centros
function dir_lateral(i) = n_pastilhas == 1 ? 0 : angulo(i) - 90;

module cilindro_chanfrado(d, h) {
    hull() {
        translate([0, 0, chanfro]) cylinder(d = d, h = h - 2 * chanfro);
        cylinder(d = d - 2 * chanfro, h = h);
    }
}

module base() {
    difference() {
        cilindro_chanfrado(d_secao, altura_base);
        for (c = centros()) translate([c[0], c[1], 0]) {
            translate([0, 0, espessura_fundo]) cylinder(d = d_cavidade, h = altura);
            translate([0, 0, -1]) cylinder(d = furo_parafuso, h = altura);
        }
        if (fixacao == "tampa")
            for (p = parafusos_tampa()) translate([p[0], p[1], -1])
                cylinder(d = furo_m2_base, h = altura + 2);
        if (fixacao == "lateral")
            for (i = [0 : n_pastilhas - 1]) {
                c = centros()[i];
                translate([c[0], c[1], altura_base - z_lateral])
                    rotate([0, 90, dir_lateral(i)]) cylinder(d = furo_lateral, h = d_secao);
            }
        // Numeração das cavidades gravada no fundo (lida de baixo)
        for (i = [0 : n_pastilhas - 1]) {
            p = centros()[i] + [3.5, 0];
            translate([p[0], p[1], -0.01]) linear_extrude(0.4)
                mirror([1, 0, 0]) text(str(i + 1), size = 2.5, halign = "center", valign = "center");
        }
    }
}

module tampa() {
    difference() {
        cilindro_chanfrado(d_secao, espessura_tampa);
        for (c = centros()) translate([c[0], c[1], -0.01]) {
            cylinder(d = d_janela, h = aba_reta + 0.02);
            translate([0, 0, aba_reta])
                cylinder(d1 = d_janela, d2 = d_janela_topo, h = espessura_tampa - aba_reta + 0.03);
        }
        // Escareado para parafuso M2 de cabeça chata (DIN 965)
        for (p = parafusos_tampa()) translate([p[0], p[1], -0.01]) {
            cylinder(d = 2.3, h = espessura_tampa + 1);
            translate([0, 0, espessura_tampa - 1.2]) cylinder(d1 = 2.3, d2 = 4.0, h = 1.22);
        }
    }
}

module pistao() {
    cylinder(d = d_pistao, h = espessura_pistao);
}

module calco() {
    cylinder(d = diametro_calco, h = comprimento_calco);
}

if (peca == "base") base();
else if (peca == "tampa") tampa();
else if (peca == "pistao") pistao();
else if (peca == "calco") calco();
else {
    base();
    for (c = centros()) translate([c[0], c[1], espessura_fundo + 1]) color("orange") pistao();
    if (fixacao == "tampa") translate([0, 0, altura_base + 3]) color("silver") tampa();
}
